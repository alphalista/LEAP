from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.
class Users(AbstractUser):
    user_id = models.CharField(max_length=100, primary_key=True)
    nickname = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        db_table = 'users'
