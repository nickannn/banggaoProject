from django import forms
from .models import Meeting


class MeetingForm(forms.ModelForm):
    """모임 생성/수정 폼"""

    meeting_date = forms.DateTimeField(
        input_formats=['%Y-%m-%dT%H:%M', '%Y-%m-%d %H:%M', '%Y-%m-%d %H:%M:%S'],
        widget=forms.DateTimeInput(
            format='%Y-%m-%dT%H:%M',
            attrs={
                'class': 'form-control',
                'type': 'datetime-local',
            }
        ),
    )

    class Meta:
        model = Meeting
        fields = [
            'title', 'description', 'region', 'location_name',
            'location_address', 'language', 'language_ratio',
            'difficulty', 'target_audience', 'meeting_date',
            'capacity', 'fee', 'supplies', 'cancellation_policy',
            'kakao_link', 'image'
        ]
        widgets = {
            'title': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '모임 제목'
            }),
            'description': forms.Textarea(attrs={
                'class': 'form-control',
                'placeholder': '모임 설명',
                'rows': 5
            }),
            'region': forms.Select(attrs={
                'class': 'form-control'
            }),
            'location_name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '장소명 (예: 강남역 스타벅스)'
            }),
            'location_address': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '주소'
            }),
            'language': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '사용 언어 (예: 한국어, English)'
            }),
            'language_ratio': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '언어 비율 (예: 한국어 50% / English 50%)'
            }),
            'difficulty': forms.Select(attrs={
                'class': 'form-control'
            }),
            'target_audience': forms.Select(attrs={
                'class': 'form-control'
            }),
            'capacity': forms.NumberInput(attrs={
                'class': 'form-control',
                'min': 2,
                'max': 100
            }),
            'fee': forms.NumberInput(attrs={
                'class': 'form-control',
                'min': 0,
                'step': 1000,
                'placeholder': '무료는 0'
            }),
            'supplies': forms.Textarea(attrs={
                'class': 'form-control',
                'rows': 3,
                'placeholder': '예: 필기구, 노트북'
            }),
            'cancellation_policy': forms.Textarea(attrs={
                'class': 'form-control',
                'rows': 4,
                'placeholder': '예: 시작 24시간 전까지 취소 가능'
            }),
            'kakao_link': forms.URLInput(attrs={
                'class': 'form-control',
                'placeholder': '카카오톡 오픈채팅 링크 (선택)'
            }),
            'image': forms.FileInput(attrs={
                'class': 'form-control'
            }),
        }
