# Generated by Django 5.1.1 on 2024-12-02 05:06

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("crawling", "0001_initial"),
    ]

    operations = [
        migrations.AddField(
            model_name="otcbondtrending",
            name="bond_name",
            field=models.CharField(default=None, max_length=200),
            preserve_default=False,
        ),
    ]
