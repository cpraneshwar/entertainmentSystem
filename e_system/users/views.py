from django.shortcuts import render
from rest_framework.views import APIView
from users.serializers import SignupSerializer, ProfileSerializer
from users.models import Profile
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated
from rewards.models import Tier
from rest_framework.response import Response
from rest_framework import status


# Create your views here.
class SignUp(APIView):
    @swagger_auto_schema(request_body=SignupSerializer)
    def post(self, request):
        serializer = SignupSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            user = serializer.save()
            profile = Profile()
            profile.user = user
            profile.tier = Tier.objects.get(id=1)
            profile.save()
        return Response(status=status.HTTP_201_CREATED)

class UserSelfProfile(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request):
        try:
            profile = Profile.objects.get(user=request.user)
        except ObjectDoesNotExist:
            raise ObjectDoesNotExist
        serializer = ProfileSerializer(profile, many=False)
        return Response(serializer.data)
