from django.urls import path
from users.views import SignUp, UserSelfProfile

urlpatterns = [
    path('signup/', SignUp.as_view()),
    path('self/', UserSelfProfile.as_view())
]
