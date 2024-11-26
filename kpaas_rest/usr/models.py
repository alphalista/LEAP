from django.db import models

# Create your models here.

class Users(models.Model):
    user_id = models.CharField(max_length=100, primary_key=True)
    nickname = models.CharField(max_length=100,  blank=True, null=True)

    class Meta:
        db_table = 'users'
        managed = False