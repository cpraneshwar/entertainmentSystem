

from django.core.management.base import BaseCommand

from time import sleep
from django.core import management
from users.models import Profile
import requests
from ms_graph import config
from datetime import datetime, timedelta
from ms_graph.utils import notify_user


SCHEDULE_GRAPH_API = "https://graph.microsoft.com/v1.0/me/calendar/getschedule"
USER_GRAPH_API = "https://graph.microsoft.com/v1.0/me"

def graph_call(api, access_token, data={}, method="GET"):
    headers = {
            "Authorization": access_token,
            "Content-Type": "application/json"
    }
    # make graph call
    if method == "GET":
        resp = requests.get(api, headers=headers)
    elif method == "POST":
        resp =requests.post(api, data=data, headers=headers)
    return resp

def refresh_access_token(profile):
    graph_token_api = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
    post_data = {
            "client_id": config.clientId,
            "scope": config.graphUserScopes,
            "grant_type": "refresh_token",
            "client_secret": config.clientSecret,
            "redirect_uri": config.accessRedirectUri,
            "refresh_token": profile.cal_refresh_token,
        }
    # refresh_access_token
    resp = requests.post(graph_token_api, data=post_data).json()
    profile = Profile.objects.get(user__id=int(request.data["state"][0]))
    profile.cal_access_token = resp["access_token"]
    profile.cal_refresh_token = resp["refresh_token"]
    profile.cal_connected = False
    profile.cal_access_expiry = datetime.now() + timedelta(minutes=50)
    profile.save()


def get_user_mail(profile):
    resp = graph_call(USER_GRAPH_API, profile.cal_access_token)
    return resp.json()['mail']

def is_user_free(profile):
    if profile.cal_access_expiry > datetime.now():
        refresh_access_token(profile)
    mail = get_user_mail(profile)
    dt = datetime.now()
    end_dt = datetime.now() + timedelta(minutes=30)
    post_data = {
    "schedules": [mail],

    "startTime": {
         "dateTime": str(dt.strftime("%y-%m-%d")) +"T" + dt.strftime("%H:%M:%S"),
         "timeZone": "UTC"
    },
    "endTime": {
         "dateTime": str(end_dt.strftime("%y-%m-%d")) +"T" + end_dt.strftime("%H:%M:%S"),
         "timeZone": "UTC"
    }
    }
    resp = graph_call(SCHEDULE_GRAPH_API, profile.cal_access_token, data=post_data, method="POST")
    resp = resp.json()
    busy = int(resp['value']['availabilityView'])
    if busy:
        return False
    return True


class Command(BaseCommand):
    help = 'Purges audit logs and jobs'

    def handle(self, *args, **options):
        
        sleep_time = 15 *60
        while True:
            profiles = Profile.objects.filter(cal_connected=True)
            for profile in profiles():
                if is_user_free(profile):
                    notify_user(profile)
            sleep(sleep_time)

        return
