from django.db import models
from django.contrib.auth.models import User
from rewards.models import Tier

# Create your models here.

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    reward_points = models.IntegerField("Reward Points", default=0)
    tier = models.ForeignKey(Tier, on_delete=models.PROTECT)
    is_verified = models.BooleanField(default=False)
