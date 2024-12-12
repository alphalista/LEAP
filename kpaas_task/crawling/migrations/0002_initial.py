# Generated by Django 5.1.1 on 2024-12-12 03:57

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("crawling", "0001_initial"),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name="otc_bond_expired",
            name="user_id",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.AddField(
            model_name="otc_bond_holding",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="crawling.otc_bond"
            ),
        ),
        migrations.AddField(
            model_name="otc_bond_holding",
            name="user_id",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.AddField(
            model_name="otc_bond_interest",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="crawling.otc_bond"
            ),
        ),
        migrations.AddField(
            model_name="otc_bond_interest",
            name="user_id",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.AddField(
            model_name="otcbondpredatadays",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="crawling.otc_bond"
            ),
        ),
        migrations.AddField(
            model_name="otcbondpredatamonths",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="crawling.otc_bond"
            ),
        ),
        migrations.AddField(
            model_name="otcbondpredataweeks",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="crawling.otc_bond"
            ),
        ),
        migrations.AddField(
            model_name="otcbondtrending",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="crawling.otc_bond"
            ),
        ),
        migrations.AlterUniqueTogether(
            name="otc_bond_interest",
            unique_together={("user_id", "bond_code")},
        ),
    ]
