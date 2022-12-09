from django.urls import path
from users.views import SignUp, UserSelfProfile, SetDeviceId

urlpatterns = [
    path('signup/', SignUp.as_view()),
    path('self/', UserSelfProfile.as_view()),
    path('set_device_id/', SetDeviceId.as_view())
]
