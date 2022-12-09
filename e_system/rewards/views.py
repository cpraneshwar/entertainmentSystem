from rest_framework.views import APIView
from challenges.serializers import AddQuizSerializer, QuizHistorySerializer
from drf_yasg.utils import swagger_auto_schema
from rest_framework.response import Response
from rest_framework import status
from django.db import transaction
from challenges.models import QuizHistory
from users.models import Profile
from challenges.models import DTYPE_SCORE_MULTI
from rest_framework import generics
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.permissions import IsAuthenticated
from users.serializers import ProfileSerializer
# Create your views here.


class WithdrawPoints(APIView):
    permission_classes = (IsAuthenticated, )


    def post(self, request):
        data = request.data
        points = data['points']
        profile = Profile.objects.get(user=request.user)
        if profile.reward_points < points:
            return Response({"error": "Insuffcient points for exchange"}, status=status.HTTP_400_BAD_REQUEST)
        profile.reward_points -= points
        profile.save()
        serializer = ProfileSerializer(profile, many=False)
        return Response(serializer.data, status=status.HTTP_200_OK)

