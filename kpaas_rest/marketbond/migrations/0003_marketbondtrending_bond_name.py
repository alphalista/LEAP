# Generated by Django 5.1.1 on 2024-12-02 06:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('marketbond', '0002_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='marketbondtrending',
            name='bond_name',
            field=models.CharField(default=None, max_length=200),
            preserve_default=False,
        ),
    ]