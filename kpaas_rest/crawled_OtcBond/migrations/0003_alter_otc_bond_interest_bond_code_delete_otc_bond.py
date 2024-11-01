# Generated by Django 5.1.1 on 2024-11-01 14:47

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('crawled_OtcBond', '0002_otc_bond_interest'),
        ('crawling', '0005_remove_otc_bond_adddate'),
    ]

    operations = [
        migrations.AlterField(
            model_name='otc_bond_interest',
            name='bond_code',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='crawling.otc_bond'),
        ),
        migrations.DeleteModel(
            name='OTC_Bond',
        ),
    ]
