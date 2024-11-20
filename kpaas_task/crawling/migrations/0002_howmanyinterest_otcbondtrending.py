# Generated by Django 5.1.1 on 2024-11-19 00:59

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("crawling", "0001_initial"),
    ]

    operations = [
        migrations.CreateModel(
            name="HowManyInterest",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("interest", models.IntegerField()),
                ("danger_degree", models.CharField(max_length=100)),
                (
                    "bond_code",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="crawling.otc_bond",
                    ),
                ),
            ],
            options={
                "db_table": "HowManyInterest",
            },
        ),
        migrations.CreateModel(
            name="OtcBondTrending",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("YTM", models.CharField(max_length=100)),
                ("add_date", models.DateField(auto_now_add=True)),
                (
                    "bond_code",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="crawling.otc_bond",
                    ),
                ),
            ],
            options={
                "db_table": "OtcBondTrending",
            },
        ),
    ]
