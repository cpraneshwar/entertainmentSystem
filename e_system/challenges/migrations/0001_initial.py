# Generated by Django 4.1.2 on 2022-11-08 17:46

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='QuizzHistory',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('totalQuestions', models.IntegerField(default=0)),
                ('totalCorrectAns', models.IntegerField(default=0)),
                ('difficulty', models.IntegerField(choices=[(0, 'EASY'), (1, 'MEDIUM'), (2, 'HARD')], default=0)),
                ('timestamp', models.DateTimeField(auto_now_add=True)),
                ('category', models.CharField(max_length=255)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
