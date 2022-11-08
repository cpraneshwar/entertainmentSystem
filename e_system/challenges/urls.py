from django.urls import path
from challenges.views import AddQuizHistory, QuizHistoryList

urlpatterns = [
    path('add_quiz_history/', AddQuizHistory.as_view()),
    path('quiz_history/', QuizHistoryList.as_view())
]
