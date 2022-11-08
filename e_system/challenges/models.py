from django.db import models
from django.contrib.auth.models import User
# Create your models here.
DIFFICULTY_TYPES = (
    (0, 'EASY'),
    (1, 'MEDIUM'),
    (2, 'HARD'),
)

# Multiplier for difficulty type
DTYPE_SCORE_MULTI = {
0: 5,
1: 10,
2: 20
} 

class QuizHistory(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    totalQuestions = models.IntegerField(default=0)
    totalCorrectAns = models.IntegerField(default=0)
    difficulty = models.IntegerField(default=0, choices=DIFFICULTY_TYPES)
    timestamp = models.DateTimeField(auto_now_add=True)
    category = models.CharField(max_length=255)
