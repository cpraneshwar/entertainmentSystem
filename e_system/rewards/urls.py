from django.urls import path
from rewards.views import WithdrawPoints

urlpatterns = [
path('rewards/withdraw_points', WithdrawPoints),
]
