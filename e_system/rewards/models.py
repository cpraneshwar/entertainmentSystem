
from django.db import models

# Create your models here.

class Tier(models.Model):
    name = models.CharField("Name of the Tier", max_length=255)
    multiplier = models.IntegerField("Multiplier points of the project", default=1)
