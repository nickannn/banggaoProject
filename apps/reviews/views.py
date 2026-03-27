from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, UserPassesTestMixin
from django.urls import reverse_lazy
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from .models import Review
from .forms import ReviewForm


class ReviewListView(ListView):
    """리뷰 목록"""
    model = Review
    template_name = 'reviews/review_list.html'
    context_object_name = 'reviews'
    paginate_by = 20

    def get_queryset(self):
        return super().get_queryset().select_related('author')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['form'] = ReviewForm(user=self.request.user)
        return context


class ReviewCreateView(CreateView):
    """리뷰 작성"""
    model = Review
    form_class = ReviewForm
    template_name = 'reviews/review_form.html'
    success_url = reverse_lazy('reviews:list')

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        kwargs['user'] = self.request.user
        return kwargs

    def form_valid(self, form):
        messages.success(self.request, '리뷰가 등록되었습니다!')
        return super().form_valid(form)


class ReviewUpdateView(LoginRequiredMixin, UserPassesTestMixin, UpdateView):
    """리뷰 수정"""
    model = Review
    form_class = ReviewForm
    template_name = 'reviews/review_form.html'
    success_url = reverse_lazy('reviews:list')

    def test_func(self):
        review = self.get_object()
        return review.author == self.request.user

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        kwargs['user'] = self.request.user
        return kwargs

    def form_valid(self, form):
        messages.success(self.request, '리뷰가 수정되었습니다.')
        return super().form_valid(form)


class ReviewDeleteView(LoginRequiredMixin, UserPassesTestMixin, DeleteView):
    """리뷰 삭제"""
    model = Review
    success_url = reverse_lazy('reviews:list')

    def test_func(self):
        review = self.get_object()
        return review.author == self.request.user or self.request.user.is_staff

    def delete(self, request, *args, **kwargs):
        messages.success(request, '리뷰가 삭제되었습니다.')
        return super().delete(request, *args, **kwargs)
