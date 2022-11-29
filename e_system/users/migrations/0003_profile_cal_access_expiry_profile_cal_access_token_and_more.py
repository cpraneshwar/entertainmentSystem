# Generated by Django 4.1.2 on 2022-11-29 04:25

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0002_alter_profile_tier'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='cal_access_expiry',
            field=models.DateField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='profile',
            name='cal_access_token',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='profile',
            name='cal_connected',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='profile',
            name='cal_refresh_token',
            field=models.TextField(blank=True, null=True),
        ),
    ]