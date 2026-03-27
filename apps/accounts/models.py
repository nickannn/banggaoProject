from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin
from django.db import models
from apps.core.models import TimeStampedModel
from .managers import CustomUserManager


class CustomUser(AbstractBaseUser, PermissionsMixin, TimeStampedModel):
    """
    커스텀 사용자 모델
    Spring User 모델 매핑:
    - userEmail -> email (USERNAME_FIELD)
    - userPwd -> password (AbstractBaseUser에서 해싱 처리)
    - userName -> name
    - userBirth -> birth_date
    - userGender -> gender
    - userNationality -> nationality
    - userLanguage -> language
    - attachedImage -> profile_image
    - userReg_date -> created_at (TimeStampedModel)
    """

    class Gender(models.TextChoices):
        MALE = 'M', '남성'
        FEMALE = 'F', '여성'
        OTHER = 'O', '기타'

    email = models.EmailField(
        '이메일',
        unique=True,
        error_messages={'unique': '이미 등록된 이메일입니다.'}
    )
    name = models.CharField('이름', max_length=50)
    birth_date = models.DateField('생년월일', null=True, blank=True)
    gender = models.CharField(
        '성별',
        max_length=1,
        choices=Gender.choices,
        blank=True
    )
    nationality = models.CharField('국적', max_length=50, blank=True)
    language = models.CharField('사용 언어', max_length=50, blank=True)
    profile_image = models.ImageField(
        '프로필 이미지',
        upload_to='profile_images/%Y/%m/%d/',
        blank=True,
        null=True
    )

    # Django 필수 필드
    is_active = models.BooleanField('활성화', default=True)
    is_staff = models.BooleanField('스태프 권한', default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    class Meta:
        db_table = 'users'
        verbose_name = '사용자'
        verbose_name_plural = '사용자들'

    def __str__(self):
        return f'{self.name} ({self.email})'
