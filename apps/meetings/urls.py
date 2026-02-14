from django.urls import path
from . import views

app_name = 'meetings'

urlpatterns = [
    path('', views.MeetingListView.as_view(), name='list'),
    path('api/list/', views.MeetingAPIListView.as_view(), name='api_list'),
    path('create/', views.MeetingCreateView.as_view(), name='create'),
    path('<int:pk>/', views.MeetingDetailView.as_view(), name='detail'),
    path('<int:pk>/edit/', views.MeetingUpdateView.as_view(), name='edit'),
    path('<int:pk>/delete/', views.MeetingDeleteView.as_view(), name='delete'),
    path('<int:pk>/join/', views.MeetingJoinView.as_view(), name='join'),
    path('<int:pk>/cancel/', views.MeetingCancelView.as_view(), name='cancel'),
]
