from django.urls import path
from rewards.views import WithdrawPoints

urlpatterns = [
path('withdraw_points', WithdrawPoints.as_view()),
]
