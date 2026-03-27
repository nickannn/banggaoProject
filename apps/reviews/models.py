from django.db import models
from django.conf import settings
from apps.core.models import TimeStampedModel


class Review(TimeStampedModel):
    """
    리뷰 모델
    Spring ReviewVo 모델 매핑:
    - revNum -> id (auto)
    - revName -> author (FK) + author_name (비회원)
    - revContext -> content
    - regDate -> created_at
    """
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='reviews',
        verbose_name='작성자'
    )
    author_name = models.CharField('작성자명 (비회원)', max_length=50, blank=True)
    content = models.TextField('내용')

    class Meta:
        db_table = 'reviews'
        verbose_name = '리뷰'
        verbose_name_plural = '리뷰들'
        ordering = ['-created_at']

    def __str__(self):
        return f'Review by {self.get_author_name()}'

    def get_author_name(self):
        """작성자명 반환"""
        if self.author:
            return self.author.name
        return self.author_name or '익명'
