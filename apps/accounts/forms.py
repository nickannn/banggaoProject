from django import forms
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from .models import CustomUser


class CustomUserCreationForm(UserCreationForm):
    """회원가입 폼"""

    class Meta:
        model = CustomUser
        fields = [
            'email', 'name', 'password1', 'password2',
            'birth_date', 'gender', 'nationality', 'language', 'profile_image'
        ]
        widgets = {
            'email': forms.EmailInput(attrs={
                'class': 'form-control',
                'placeholder': '이메일'
            }),
            'name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '이름'
            }),
            'birth_date': forms.DateInput(attrs={
                'class': 'form-control',
                'type': 'date'
            }),
            'gender': forms.Select(attrs={
                'class': 'form-control'
            }),
            'nationality': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '국적'
            }),
            'language': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': '사용 언어'
            }),
            'profile_image': forms.FileInput(attrs={
                'class': 'form-control'
            }),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['password1'].widget.attrs.update({
            'class': 'form-control',
            'placeholder': '비밀번호'
        })
        self.fields['password2'].widget.attrs.update({
            'class': 'form-control',
            'placeholder': '비밀번호 확인'
        })


class CustomAuthenticationForm(AuthenticationForm):
    """로그인 폼"""

    username = forms.EmailField(
        label='이메일',
        widget=forms.EmailInput(attrs={
            'class': 'form-control',
            'placeholder': '이메일',
            'autofocus': True
        })
    )
    password = forms.CharField(
        label='비밀번호',
        widget=forms.PasswordInput(attrs={
            'class': 'form-control',
            'placeholder': '비밀번호'
        })
    )
    remember_me = forms.BooleanField(
        label='로그인 상태 유지',
        required=False,
        widget=forms.CheckboxInput(attrs={'class': 'form-check-input'})
    )


class ProfileUpdateForm(forms.ModelForm):
    """프로필 수정 폼"""

    class Meta:
        model = CustomUser
        fields = ['name', 'birth_date', 'gender', 'nationality', 'language', 'profile_image']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'birth_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'gender': forms.Select(attrs={'class': 'form-control'}),
            'nationality': forms.TextInput(attrs={'class': 'form-control'}),
            'language': forms.TextInput(attrs={'class': 'form-control'}),
            'profile_image': forms.FileInput(attrs={'class': 'form-control'}),
        }
