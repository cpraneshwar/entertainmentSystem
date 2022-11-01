from django.shortcuts import render
from rest_framework.views import APIView
from users.serializers import SignupSerializer, ProfileSerializer
from users.models import Profile
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated
from rewards.models import Tier
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import logout
import random
from users.models import Otps
from users.serializers import VerifyProfileSerializer
import datetime
import smtplib


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


class UserLogout(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, format=None):
        logout(request)
        return Response(status=status.HTTP_200_OK)


class SendVerificationOtp(APIView):
    permission_classes = (IsAuthenticated, )
    def post(self, request, format=None):
        otp = random.randint(100000, 999999)
        otp_obj = Otps.objects.create(otp=otp, user=request.user)
        # Send otp to the user
        server=smtplib.SMTP('smtp.gmail.com',587)
        server.starttls()
        server.login('yourid@gmail.com','yourpassword')
        server.sendmail('yourid@gmail.com','reciverid@gmail.com',
                        f"Please use the otp:{otp} for verification in e_system")
        server.close()
        return Response(status=status.HTTP_200_OK)


class VerifyProfile(APIView):
    permission_classes = (IsAuthenticated, )
    def post(self, request, format=None):
        serializer = VerifyProfileSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            try:
                otp_object = Otps.objects.filter(user=request.user, otp=serializer.validated_data["otp"])
                seconds = (datetime.now() - otp_object.ctime).total_seconds()
                if seconds > 300:
                    return  Response({"message": "Otp expired, request for new otp"}, 
                                     status=status.HTTP_400_BAD_REQUEST)
                profile = Profile.objects.get()
                profile.is_verified = True
                profile.save()
            except Exception:
                return  Response({"message": "Invalid Otp"}, status=status.HTTP_400_BAD_REQUEST)
        return Response(status=status.HTTP_200_OK)
