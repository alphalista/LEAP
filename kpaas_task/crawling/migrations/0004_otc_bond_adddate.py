# Generated by Django 5.1.1 on 2024-11-01 13:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("crawling", "0003_rename_bond_name_otc_bond_bond_int_dfrm_mthd_cd_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="otc_bond",
            name="addDate",
            field=models.DateField(auto_now=True),
        ),
    ]
