# Generated by Django 5.1.1 on 2024-11-01 13:58

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("crawling", "0004_otc_bond_adddate"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="otc_bond",
            name="addDate",
        ),
    ]
