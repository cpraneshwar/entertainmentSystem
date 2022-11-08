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
from rest_framework.filters import SearchFilter, OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.permissions import IsAuthenticated
# Create your views here.


class AddQuizHistory(APIView):
    permission_classes = (IsAuthenticated, )

    @swagger_auto_schema(request_body=AddQuizSerializer)
    def post(self, request):
        serializer = AddQuizSerializer(data=request.data)
        if serializer.is_valid():
            with transaction.atomic():
                Qh = QuizHistory()
                Qh.user = request.user
                Qh.totalQuestions = serializer.validated_data['totalQuestions']
                Qh.totalCorrectAns = serializer.validated_data['totalCorrectAns']
                Qh.difficulty = serializer.validated_data['difficulty']
                if Qh.totalCorrectAns >  Qh.totalQuestions:
                    return Response({"error": "totalCorrectAns can't be morethan totalQuestions"})
                Qh.save()
                profile = Profile.objects.get(user=request.user)
                reward_points = Qh.totalCorrectAns * DTYPE_SCORE_MULTI[Qh.difficulty]
                profile.reward_points = profile.reward_points + reward_points
                profile.save()
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        return Response(status=status.HTTP_201_CREATED)


class QuizHistoryList(generics.ListAPIView):
    permission_classes = (IsAuthenticated,)
    filter_backends = (DjangoFilterBackend,)
    #ordering_fields = ('timestamp')
    serializer_class = QuizHistorySerializer

    def get_queryset(self):
        return QuizHistory.objects.filter(user=self.request.user)
