from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.
class Users(AbstractUser):
    user_id = models.CharField(max_length=100, primary_key=True)
    nickname = models.CharField(max_length=100, blank=True, null=True)
    password = models.CharField(max_length=128, default='')  # 기본값 제공
    username = models.CharField(max_length=150, default='', unique=False)

    USERNAME_FIELD = 'user_id'
    class Meta:
        db_table = 'users'
