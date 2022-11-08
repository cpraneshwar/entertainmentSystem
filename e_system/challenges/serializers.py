from rest_framework import serializers
from challenges.models import QuizHistory
from challenges.models import DIFFICULTY_TYPES

class AddQuizSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuizHistory
        fields = ('totalQuestions',  'totalCorrectAns', 'difficulty', 'category')



class QuizHistorySerializer(serializers.ModelSerializer):
    difficulty = serializers.SerializerMethodField(method_name="get_difficulty_type")
    user_email = serializers.SerializerMethodField(method_name="get_user_email")
    class Meta:
        model = QuizHistory
        fields = ('user_email', 'totalQuestions',  'totalCorrectAns', 'difficulty', 'category', 'timestamp')

    def get_difficulty_type(self, instance):
        return dict(DIFFICULTY_TYPES)[instance.difficulty]

    def get_user_email(self, instance):
        return instance.user.email
