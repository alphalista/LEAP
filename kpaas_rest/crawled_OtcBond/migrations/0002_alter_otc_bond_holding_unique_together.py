# Generated by Django 5.1.1 on 2024-11-11 02:09

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('crawled_OtcBond', '0001_initial'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='otc_bond_holding',
            unique_together={('user_id', 'bond_code', 'price_per_10')},
        ),
    ]
