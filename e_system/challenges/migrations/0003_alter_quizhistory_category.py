# Generated by Django 4.1.2 on 2022-11-26 20:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('challenges', '0002_rename_quizzhistory_quizhistory'),
    ]

    operations = [
        migrations.AlterField(
            model_name='quizhistory',
            name='category',
            field=models.IntegerField(choices=[(11, 'Movies'), (23, 'History'), (17, 'Science'), (10, 'Books'), (27, 'Animals'), (9, 'General Knowledge')]),
        ),
    ]
