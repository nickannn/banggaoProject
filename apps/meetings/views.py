from django.contrib.auth.mixins import LoginRequiredMixin, UserPassesTestMixin
from django.contrib import messages
from django.db import IntegrityError, transaction
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from django.urls import reverse_lazy
from django.views import View
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from .models import Meeting, MeetingParticipant
from .forms import MeetingForm


class MeetingListView(ListView):
    """모임 목록"""
    model = Meeting
    template_name = 'meetings/meeting_list.html'
    context_object_name = 'meetings'
    paginate_by = 10

    def get_queryset(self):
        queryset = super().get_queryset()
        region = self.request.GET.get('region')
        if region and region != 'all':
            queryset = queryset.filter(region=region)
        return queryset.select_related('host').prefetch_related('participants')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['regions'] = Meeting.Region.choices
        context['selected_region'] = self.request.GET.get('region', 'all')
        return context


class MeetingAPIListView(View):
    """모임 목록 API (AJAX)"""

    def post(self, request):
        region = request.POST.get('region', 'all')
        if region == 'all':
            meetings = Meeting.objects.all()
        else:
            meetings = Meeting.objects.filter(region=region)

        meetings = meetings.select_related('host').prefetch_related('participants')

        data = []
        for m in meetings:
            data.append({
                'id': m.id,
                'title': m.title,
                'description': m.description,
                'region': m.region,
                'location_name': m.location_name,
                'location_address': m.location_address,
                'language': m.language,
                'language_ratio': m.language_ratio,
                'difficulty': m.difficulty,
                'difficulty_label': m.get_difficulty_display(),
                'target_audience': m.target_audience,
                'target_audience_label': m.get_target_audience_display(),
                'date': m.meeting_date.isoformat(),
                'capacity': m.capacity,
                'fee': m.fee,
                'supplies': m.supplies,
                'cancellation_policy': m.cancellation_policy,
                'participants_count': m.participant_count,
                'available_spots': m.available_spots,
                'host_name': m.host.name,
                'host_email': m.host.email,
                'kakao_link': m.kakao_link,
                'image_url': m.image.url if m.image else None,
            })
        return JsonResponse(data, safe=False)


class MeetingDetailView(DetailView):
    """모임 상세"""
    model = Meeting
    template_name = 'meetings/meeting_detail.html'
    context_object_name = 'meeting'

    def get_queryset(self):
        return super().get_queryset().select_related('host').prefetch_related('participants')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        if self.request.user.is_authenticated:
            context['is_participant'] = MeetingParticipant.objects.filter(
                meeting=self.object,
                user=self.request.user
            ).exists()
            context['is_host'] = self.object.host == self.request.user
        return context


class MeetingCreateView(LoginRequiredMixin, CreateView):
    """모임 생성"""
    model = Meeting
    form_class = MeetingForm
    template_name = 'meetings/meeting_form.html'
    success_url = reverse_lazy('meetings:list')

    def form_valid(self, form):
        form.instance.host = self.request.user
        messages.success(self.request, '모임이 생성되었습니다!')
        return super().form_valid(form)


class MeetingUpdateView(LoginRequiredMixin, UserPassesTestMixin, UpdateView):
    """모임 수정 (주최자만)"""
    model = Meeting
    form_class = MeetingForm
    template_name = 'meetings/meeting_form.html'

    def test_func(self):
        return self.get_object().host == self.request.user

    def get_success_url(self):
        messages.success(self.request, '모임이 수정되었습니다.')
        return reverse_lazy('meetings:detail', kwargs={'pk': self.object.pk})


class MeetingDeleteView(LoginRequiredMixin, UserPassesTestMixin, DeleteView):
    """모임 삭제 (주최자만)"""
    model = Meeting
    success_url = reverse_lazy('meetings:list')

    def test_func(self):
        return self.get_object().host == self.request.user

    def delete(self, request, *args, **kwargs):
        messages.success(request, '모임이 삭제되었습니다.')
        return super().delete(request, *args, **kwargs)


class MeetingJoinView(LoginRequiredMixin, View):
    """모임 참가"""

    def post(self, request, pk):
        user = request.user

        try:
            with transaction.atomic():
                meeting = Meeting.objects.select_for_update().get(pk=pk)

                # 이미 참가 중인지 확인
                if MeetingParticipant.objects.filter(meeting=meeting, user=user).exists():
                    return JsonResponse({'status': 0, 'message': '이미 참가 중입니다.'})

                # 주최자인지 확인
                if meeting.host_id == user.id:
                    return JsonResponse({'status': 0, 'message': '주최자는 자동으로 참가됩니다.'})

                current_count = MeetingParticipant.objects.filter(meeting=meeting).count()
                if current_count >= meeting.capacity:
                    return JsonResponse({'status': -1, 'message': '정원이 초과되었습니다.'})

                try:
                    participant = MeetingParticipant.objects.create(meeting=meeting, user=user)
                except IntegrityError:
                    return JsonResponse({'status': 0, 'message': '이미 참가 중입니다.'})

                participants_count = MeetingParticipant.objects.filter(meeting=meeting).count()
                if participants_count > meeting.capacity:
                    participant.delete()
                    return JsonResponse({'status': -1, 'message': '정원이 초과되었습니다.'})

                available_spots = max(0, meeting.capacity - participants_count)
        except Meeting.DoesNotExist:
            return JsonResponse({'status': -1, 'message': '모임을 찾을 수 없습니다.'}, status=404)

        return JsonResponse({
            'status': 1,
            'message': '참가 완료!',
            'participants_count': participants_count,
            'available_spots': available_spots,
        })


class MeetingCancelView(LoginRequiredMixin, View):
    """모임 참가 취소"""

    def post(self, request, pk):
        meeting = get_object_or_404(Meeting, pk=pk)
        user = request.user

        deleted, _ = MeetingParticipant.objects.filter(
            meeting=meeting, user=user
        ).delete()

        if deleted:
            return JsonResponse({
                'status': 1,
                'message': '참가 취소 완료!',
                'participants_count': meeting.participant_count,
                'available_spots': meeting.available_spots
            })
        return JsonResponse({'status': -1, 'message': '참가 정보를 찾을 수 없습니다.'})
