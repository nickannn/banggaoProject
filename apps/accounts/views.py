from django.contrib.auth import login, logout
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.views import LoginView as AuthLoginView
from django.contrib import messages
from django.shortcuts import redirect
from django.urls import reverse_lazy
from django.views import View
from django.views.generic import TemplateView, CreateView, UpdateView
from .forms import CustomUserCreationForm, CustomAuthenticationForm, ProfileUpdateForm
from .models import CustomUser


class HomeView(TemplateView):
    """메인 페이지"""
    template_name = 'pages/home.html'


class AboutView(TemplateView):
    """소개 페이지"""
    template_name = 'pages/about.html'


class SignUpView(CreateView):
    """회원가입"""
    model = CustomUser
    form_class = CustomUserCreationForm
    template_name = 'accounts/signup.html'
    success_url = reverse_lazy('accounts:home')

    def form_valid(self, form):
        response = super().form_valid(form)
        login(self.request, self.object)
        messages.success(self.request, f'{self.object.name}님, 환영합니다!')
        return response


class LoginView(AuthLoginView):
    """로그인"""
    form_class = CustomAuthenticationForm
    template_name = 'accounts/login.html'
    redirect_authenticated_user = True

    def form_valid(self, form):
        remember_me = form.cleaned_data.get('remember_me')
        if not remember_me:
            self.request.session.set_expiry(0)
        return super().form_valid(form)

    def get_success_url(self):
        messages.success(self.request, f'{self.request.user.name}님, 안녕하세요!')
        return super().get_success_url()


class LogoutView(View):
    """로그아웃"""

    def post(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            messages.info(request, '로그아웃 되었습니다.')
            logout(request)
        return redirect('accounts:home')

    def get(self, request, *args, **kwargs):
        # 상태 변경은 POST에서만 처리
        return redirect('accounts:home')


class ProfileView(LoginRequiredMixin, TemplateView):
    """프로필 조회"""
    template_name = 'accounts/profile.html'


class ProfileUpdateView(LoginRequiredMixin, UpdateView):
    """프로필 수정"""
    model = CustomUser
    form_class = ProfileUpdateForm
    template_name = 'accounts/profile_edit.html'
    success_url = reverse_lazy('accounts:profile')

    def get_object(self):
        return self.request.user

    def form_valid(self, form):
        messages.success(self.request, '프로필이 수정되었습니다.')
        return super().form_valid(form)
