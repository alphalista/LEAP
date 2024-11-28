from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Users(models.Model):
    user_id = models.CharField(max_length=100, primary_key=True)
    email = models.CharField(max_length=100, blank=True, null=True)
    nickname = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        db_table = 'users'
        managed = False

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100, blank=True, null=True)
