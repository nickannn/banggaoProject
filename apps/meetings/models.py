from django.db import models
from django.conf import settings
from apps.core.models import TimeStampedModel


class Meeting(TimeStampedModel):
    """
    모임 모델
    Spring Meeting 모델 매핑:
    - id -> id (auto)
    - title -> title
    - description -> description
    - region -> region
    - location_name -> location_name
    - location_address -> location_address
    - language -> language
    - date -> meeting_date
    - capacity -> capacity
    - hostEmail -> host (ForeignKey)
    - participants -> participants (ManyToManyField - 정규화)
    - kakaolink -> kakao_link
    - attachedImage -> image
    - reg_date -> created_at
    """

    class Region(models.TextChoices):
        SEOUL = '서울', '서울'
        BUSAN = '부산', '부산'
        DAEGU = '대구', '대구'
        INCHEON = '인천', '인천'
        GWANGJU = '광주', '광주'
        DAEJEON = '대전', '대전'
        ULSAN = '울산', '울산'
        SEJONG = '세종', '세종'
        GYEONGGI = '경기', '경기'
        GANGWON = '강원', '강원'
        CHUNGBUK = '충북', '충북'
        CHUNGNAM = '충남', '충남'
        JEONBUK = '전북', '전북'
        JEONNAM = '전남', '전남'
        GYEONGBUK = '경북', '경북'
        GYEONGNAM = '경남', '경남'
        JEJU = '제주', '제주'

    class Difficulty(models.TextChoices):
        BEGINNER = 'BEGINNER', '입문'
        INTERMEDIATE = 'INTERMEDIATE', '중급'
        ADVANCED = 'ADVANCED', '고급'
        ALL = 'ALL', '모두 환영'

    class TargetAudience(models.TextChoices):
        KOREAN = 'KOREAN', '한국인 중심'
        FOREIGNER = 'FOREIGNER', '외국인 중심'
        MIXED = 'MIXED', '혼합'

    title = models.CharField('제목', max_length=200)
    description = models.TextField('설명')
    region = models.CharField('지역', max_length=20, choices=Region.choices)
    location_name = models.CharField('장소명', max_length=200)
    location_address = models.CharField('주소', max_length=500)
    language = models.CharField('사용 언어', max_length=50)
    language_ratio = models.CharField('언어 비율', max_length=100, blank=True)
    difficulty = models.CharField(
        '모임 난이도',
        max_length=20,
        choices=Difficulty.choices,
        default=Difficulty.ALL,
    )
    target_audience = models.CharField(
        '참가 대상',
        max_length=20,
        choices=TargetAudience.choices,
        default=TargetAudience.MIXED,
    )
    meeting_date = models.DateTimeField('모임 일시')
    capacity = models.PositiveIntegerField('최대 인원', default=10)
    fee = models.PositiveIntegerField('참가비 (원)', default=0)
    supplies = models.TextField('준비물', blank=True)
    cancellation_policy = models.TextField('취소 정책', blank=True)

    # 관계 필드
    host = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='hosted_meetings',
        verbose_name='주최자'
    )
    participants = models.ManyToManyField(
        settings.AUTH_USER_MODEL,
        through='MeetingParticipant',
        related_name='joined_meetings',
        blank=True,
        verbose_name='참가자'
    )

    kakao_link = models.URLField('카카오톡 오픈채팅 링크', blank=True)
    image = models.ImageField(
        '모임 이미지',
        upload_to='meeting_images/%Y/%m/%d/',
        blank=True,
        null=True
    )

    class Meta:
        db_table = 'meetings'
        verbose_name = '모임'
        verbose_name_plural = '모임들'
        ordering = ['meeting_date']

    def __str__(self):
        return self.title

    @property
    def is_full(self):
        """정원 초과 여부"""
        return self.participants.count() >= self.capacity

    @property
    def available_spots(self):
        """남은 자리 수"""
        return max(0, self.capacity - self.participants.count())

    @property
    def participant_count(self):
        """현재 참가자 수"""
        return self.participants.count()

    def save(self, *args, **kwargs):
        # 주소에서 지역 자동 추출
        if self.location_address and not self.region:
            first_word = self.location_address.strip().split()[0]
            for choice in self.Region.choices:
                if first_word.startswith(choice[0]):
                    self.region = choice[0]
                    break
        super().save(*args, **kwargs)


class MeetingParticipant(models.Model):
    """
    모임 참가자 중간 테이블
    Spring의 공백 구분 문자열 방식 대체 (정규화)
    """
    meeting = models.ForeignKey(Meeting, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    joined_at = models.DateTimeField('참가일', auto_now_add=True)

    class Meta:
        db_table = 'meeting_participants'
        unique_together = ['meeting', 'user']
        verbose_name = '모임 참가자'
        verbose_name_plural = '모임 참가자들'

    def __str__(self):
        return f'{self.user.name} - {self.meeting.title}'
