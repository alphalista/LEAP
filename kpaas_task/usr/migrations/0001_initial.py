# Generated by Django 5.1.1 on 2024-11-24 14:40

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Users",
            fields=[
                (
                    "user_id",
                    models.CharField(max_length=100, primary_key=True, serialize=False),
                ),
                ("nickname", models.CharField(blank=True, max_length=100, null=True)),
            ],
            options={
                "db_table": "users",
                "managed": False,
            },
        ),
    ]
