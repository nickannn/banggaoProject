from django.contrib import admin
from .models import Meeting, MeetingParticipant


class MeetingParticipantInline(admin.TabularInline):
    model = MeetingParticipant
    extra = 0
    readonly_fields = ['joined_at']


@admin.register(Meeting)
class MeetingAdmin(admin.ModelAdmin):
    list_display = [
        'title', 'host', 'region', 'difficulty', 'target_audience',
        'meeting_date', 'capacity', 'fee', 'participant_count', 'created_at'
    ]
    list_filter = ['region', 'difficulty', 'target_audience', 'language', 'meeting_date']
    search_fields = ['title', 'description', 'host__name', 'host__email', 'supplies', 'cancellation_policy']
    ordering = ['-meeting_date']
    inlines = [MeetingParticipantInline]

    def participant_count(self, obj):
        return obj.participants.count()
    participant_count.short_description = '참가자 수'


@admin.register(MeetingParticipant)
class MeetingParticipantAdmin(admin.ModelAdmin):
    list_display = ['meeting', 'user', 'joined_at']
    list_filter = ['joined_at']
    search_fields = ['meeting__title', 'user__name', 'user__email']
