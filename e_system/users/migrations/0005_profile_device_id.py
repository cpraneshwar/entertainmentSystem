# Generated by Django 4.1.2 on 2022-11-29 20:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0004_alter_profile_cal_access_expiry'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='device_id',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]
