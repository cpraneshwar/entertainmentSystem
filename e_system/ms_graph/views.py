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
from ms_graph  import config
import requests
from datetime import datetime, timedelta
from ms_graph.utils import notify_user


# Create your views here.


class GetGraphAuthUrl(APIView):
    permission_classes = (IsAuthenticated, )
    def get(self, request):
        graph_auth_api = f"https://login.microsoftonline.com/common/oauth2/" +\
            f"v2.0/authorize?client_id={config.clientId}&"\
                f"response_type=code&redirect_uri={config.redirectUri}&response_mode=form_post&scope=offline_access"+\
                        f"%20calendars.read%20user.read&state={request.user.id}"
        return Response({"OauthUrl": graph_auth_api}, status=status.HTTP_200_OK)


class GraphRedirectUri(APIView):
    def post(self, request):
        graph_token_api = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
        post_data = {
            "client_id": config.clientId,
            "scope": config.graphUserScopes,
            "grant_type": "authorization_code",
            "client_secret": config.clientSecret,
            "redirect_uri": config.accessRedirectUri,
            "code": request.data["code"],
        }
        resp = requests.post(graph_token_api, data=post_data).json()
        profile = Profile.objects.get(user__id=int(request.data["state"][0]))
        profile.cal_access_token = resp["access_token"]
        profile.cal_refresh_token = resp["refresh_token"]
        profile.cal_connected = True
        profile.cal_access_expiry = datetime.now() + timedelta(minutes=50)
        profile.save()
        return Response(status=status.HTTP_200_OK)


class DemoNotify(APIView):
    def post(self, request):
        profiles = Profile.objects.all()
        for profile in profiles:
            notify_user(profile)
        return Response(status=status.HTTP_200_OK)
