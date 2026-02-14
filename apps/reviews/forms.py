from django import forms
from .models import Review


class ReviewForm(forms.ModelForm):
    """리뷰 작성 폼"""

    class Meta:
        model = Review
        fields = ['author_name', 'content']
        widgets = {
            'author_name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '이름 (비회원)'
            }),
            'content': forms.Textarea(attrs={
                'class': 'form-control',
                'placeholder': '리뷰 내용을 작성해주세요',
                'rows': 5
            }),
        }

    def __init__(self, *args, user=None, **kwargs):
        super().__init__(*args, **kwargs)
        self.user = user
        if user and user.is_authenticated:
            # 로그인 사용자는 이름 입력 불필요
            self.fields['author_name'].required = False
            self.fields['author_name'].widget = forms.HiddenInput()

    def save(self, commit=True):
        instance = super().save(commit=False)
        if self.user and self.user.is_authenticated:
            instance.author = self.user
            instance.author_name = ''
        if commit:
            instance.save()
        return instance
