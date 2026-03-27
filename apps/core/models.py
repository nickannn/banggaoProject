from django.db import models


class TimeStampedModel(models.Model):
    """생성일/수정일 자동 관리 추상 모델"""
    created_at = models.DateTimeField('생성일', auto_now_add=True)
    updated_at = models.DateTimeField('수정일', auto_now=True)

    class Meta:
        abstract = True
