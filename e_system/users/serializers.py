from rest_framework import serializers
from django.contrib.auth.password_validation import validate_password
from rest_framework.validators import UniqueValidator
from django.contrib.auth.models import User
from users.models import Profile


class SignupSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(
            required=True,
            validators=[UniqueValidator(queryset=User.objects.all())]
            )
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, required=True)
    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'password2')
        #extra_kwargs = {
            #'last_name': {'required': True},
            #'first_name': {'required': True}
        #}

    def validate(self, attrs):
        if User.objects.filter(email=attrs['email']):
            raise serializers.ValidationError({"email": f"{attrs['email']} is already used!"})

        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Passwords didn't match."})

        return attrs

    def create(self, validated_data):
        user = User.objects.create(
            username=validated_data['username'], email=validated_data['email'],
        )

        user.set_password(validated_data['password'])
        user.save()

        return user


class ProfileSerializer(serializers.ModelSerializer):
    id = serializers.CharField(source='user.id')
    username = serializers.CharField(source='user.username')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    email = serializers.EmailField(source='user.email')
    tier = serializers.CharField(source='tier.name')

    class Meta:
        model = Profile
        fields = ('id', 'username', 'first_name', 'last_name', 'email', 'tier', 'is_verified','reward_points')


