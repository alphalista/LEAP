import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='OTC_Bond',
            fields=[
                ('issu_istt_name', models.CharField(max_length=100)),
                ('code', models.CharField(max_length=100, primary_key=True, serialize=False)),
                ('prdt_name', models.CharField(max_length=100)),
                ('nice_crdt_grad_text', models.CharField(max_length=100)),
                ('issu_dt', models.CharField(max_length=100)),
                ('expd_dt', models.CharField(max_length=100)),
                ('YTM', models.CharField(max_length=100)),
                ('YTM_after_tax', models.CharField(max_length=100)),
                ('price_per_10', models.CharField(max_length=100)),
                ('prdt_type_cd', models.CharField(max_length=100)),
                ('bond_int_dfrm_mthd_cd', models.CharField(max_length=100)),
                ('int_pay_cycle', models.CharField(max_length=100)),
                ('interest_percentage', models.CharField(max_length=100)),
                ('nxtm_int_dfrm_dt', models.CharField(max_length=100)),
                ('expt_income', models.CharField(max_length=100)),
                ('duration', models.CharField(max_length=100)),
                ('add_date', models.DateField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name='OTC_Bond_Expired',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('bond_code', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='expired_bonds', to='crawled_OtcBond.otc_bond')),
                ('user_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='expired_bonds', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'OTC_Bond_Expired',
            },
        ),
        migrations.CreateModel(
            name='OtcBondPreDataDays',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('add_date', models.DateField(auto_now_add=True)),
                ('duration', models.CharField(max_length=100)),
                ('price', models.CharField(max_length=100)),
                ('bond_code', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='pre_data_set', to='crawled_OtcBond.otc_bond')),
            ],
            options={
                'db_table': 'OtcBondPreData',
            },
        ),
        migrations.CreateModel(
            name='OtcBondPreDataMonths',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('add_date', models.DateField(auto_now_add=True)),
                ('duration', models.CharField(max_length=100)),
                ('price', models.CharField(max_length=100)),
                ('bond_code', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='pre_data_months_set', to='crawled_OtcBond.otc_bond')),
            ],
            options={
                'db_table': 'OtcBondPreDataMonths',
            },
        ),
        migrations.CreateModel(
            name='OtcBondPreDataWeeks',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('add_date', models.DateField(auto_now_add=True)),
                ('duration', models.CharField(max_length=100)),
                ('price', models.CharField(max_length=100)),
                ('bond_code', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='pre_data_weeks_set', to='crawled_OtcBond.otc_bond')),
            ],
            options={
                'db_table': 'OtcBondPreDataWeeks',
            },
        ),
        migrations.CreateModel(
            name='OTC_Bond_Holding',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('price_per_10', models.CharField(max_length=100)),
                ('quantity', models.CharField(max_length=100)),
                ('purchase_date', models.CharField(max_length=100)),
                ('expire_date', models.DateField()),
                ('bond_code', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='holding_bonds', to='crawled_OtcBond.otc_bond')),
                ('user_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='holding_bonds', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'OTC_Bond_Holding',
                'unique_together': {('user_id', 'bond_code')},
            },
        ),
        migrations.CreateModel(
            name='OTC_Bond_Interest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('bond_code', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='crawled_OtcBond.otc_bond')),
                ('user_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'unique_together': {('user_id', 'bond_code')},
            },
        ),
    ]
