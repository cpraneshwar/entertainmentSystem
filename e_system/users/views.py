from django.shortcuts import render
from rest_framework.views import APIView
from users.serializers import SignupSerializer
from users.models import Profile
from drf_yasg.utils import swagger_auto_schema

# Create your views here.
class SignUp(APIView):
    @swagger_auto_schema(request_body=SignupSerializer)
    def post(self, request):
        serializer = SignupSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            user = serializer.save()
            profile = Profile()
            profile.user = user
            profile.save()

