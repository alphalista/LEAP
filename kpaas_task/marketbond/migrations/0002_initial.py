# Generated by Django 5.1.1 on 2024-12-12 03:57

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("marketbond", "0001_initial"),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name="et_bond_expired",
            name="user_id",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.AddField(
            model_name="et_bond_holding",
            name="user_id",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.AddField(
            model_name="et_bond_interest",
            name="user_id",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.AddConstraint(
            model_name="marketbondcode",
            constraint=models.UniqueConstraint(
                fields=("code",), name="unique_code_field"
            ),
        ),
        migrations.AddField(
            model_name="marketbondcmb",
            name="code",
            field=models.OneToOneField(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="et_bond_interest",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="et_bond_holding",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="et_bond_expired",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondhowmanyinterest",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondinquireaskingprice",
            name="code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondcmb",
            name="inquire_asking_price_data",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondinquireaskingprice",
            ),
        ),
        migrations.AddField(
            model_name="marketbondinquireccnl",
            name="code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondinquiredailyitemchartprice",
            name="code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondinquiredailyprice",
            name="code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondinquireprice",
            name="code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondcmb",
            name="inquire_price_data",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondinquireprice",
            ),
        ),
        migrations.AddField(
            model_name="marketbondissueinfo",
            name="code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondcmb",
            name="issue_info_data",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondissueinfo",
            ),
        ),
        migrations.AddField(
            model_name="marketbondpredatadays",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondpredatamonths",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondpredataweeks",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondsearchinfo",
            name="code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AddField(
            model_name="marketbondtrending",
            name="bond_code",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                to="marketbond.marketbondcode",
            ),
        ),
        migrations.AlterUniqueTogether(
            name="et_bond_interest",
            unique_together={("user_id", "bond_code")},
        ),
        migrations.AlterUniqueTogether(
            name="et_bond_holding",
            unique_together={("user_id", "bond_code", "price_per_10")},
        ),
        migrations.AddConstraint(
            model_name="marketbondinquireaskingprice",
            constraint=models.UniqueConstraint(
                fields=("aspr_acpt_hour", "code"), name="unique_asking_price"
            ),
        ),
        migrations.AddConstraint(
            model_name="marketbondinquiredailyitemchartprice",
            constraint=models.UniqueConstraint(
                fields=("stck_bsop_date", "code"), name="unique_daily_item_chart_price"
            ),
        ),
        migrations.AddConstraint(
            model_name="marketbondinquiredailyprice",
            constraint=models.UniqueConstraint(
                fields=("code", "stck_bsop_date"), name="unique_daily_price"
            ),
        ),
        migrations.AddConstraint(
            model_name="marketbondinquireprice",
            constraint=models.UniqueConstraint(fields=("code",), name="unique_price"),
        ),
    ]