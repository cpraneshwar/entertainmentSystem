# Generated by Django 4.1.2 on 2022-11-29 15:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('challenges', '0004_alter_quizhistory_category'),
    ]

    operations = [
        migrations.AlterField(
            model_name='quizhistory',
            name='category',
            field=models.IntegerField(choices=[(23, 'History'), (11, 'Movies'), (9, 'General Knowledge'), (17, 'Science'), (10, 'Books'), (27, 'Animals')]),
        ),
    ]
