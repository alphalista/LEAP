from django.test import TestCase
from .models import MarketBondCode, ET_Bond_Holding, ET_Bond_Interest, MarketBondIssueInfo, MarketBondInquireAskingPrice, MarketBondInquirePrice
from usr.models import Users
from usr.tests import TestUser
import json

# Create your tests here.

class MarketBondsTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        TestUser.setUpTestData()
        MarketBondCode.objects.create(
            code='KR101501DA57',
            name='국민주택1종채권20-05',
        )

        # MarketBondIssueInfo 데이터 생성
        MarketBondIssueInfo.objects.create(
            code=MarketBondCode.objects.get(code='KR101501DA57'),
            pdno="KR101501DA57",
            prdt_type_cd="302",
            prdt_name="국민주택1종채권20-05",
            prdt_eng_name="KOREA NATIONAL HOUSING BOND (Ⅰ)20-05",
            ivst_heed_prdt_yn="N",
            exts_yn="N",
            bond_clsf_cd="111200",
            bond_clsf_kor_name="국민주택1종채권",
            papr="10000",
            int_mned_dvsn_cd="2",
            rvnu_shap_cd="",
            issu_amt="1311988400000",
            lstg_rmnd="1308438000000",
            int_dfrm_mcnt="12",
            bond_int_dfrm_mthd_cd="02",
            splt_rdpt_rcnt="0",
            prca_dfmt_term_mcnt="0",
            int_anap_dvsn_cd="2",
            bond_rght_dvsn_cd="",
            prdt_pclc_text="",
            prdt_abrv_name="국민주택1종20-05",
            prdt_eng_abrv_name="KNHB (Ⅰ)20-05",
            sprx_psbl_yn="N",
            pbff_pplc_ofrg_mthd_cd="01",
            cmco_cd="",
            issu_istt_cd="GB015",
            issu_istt_name="국민주택1종채권",
            pnia_dfrm_agcy_istt_cd="1314",
            dsct_ec_rt="0.000000",
            srfc_inrt="1.000000",
            expd_rdpt_rt="0.000000",
            expd_asrc_erng_rt="0.000000",
            bond_grte_istt_name="국민주택1종채권",
            int_dfrm_day_type_cd="",
            ksd_int_calc_unit_cd="2",
            int_wunt_uder_prcs_dvsn_cd="1",
            rvnu_dt="20200504",
            issu_dt="20200531",
            lstg_dt="20200504",
            expd_dt="20250531",
            rdpt_dt="",
            sbst_pric="10140",
            rgbf_int_dfrm_dt="",
            nxtm_int_dfrm_dt="20250531",
            frst_int_dfrm_dt="",
            ecis_pric="0",
            rght_stck_std_pdno="",
            ecis_opng_dt="",
            ecis_end_dt="",
            bond_rvnu_mthd_cd="",
            oprt_stfno="BATCH",
            oprt_stff_name="",
            rgbf_int_dfrm_wday="",
            nxtm_int_dfrm_wday="07",
            kis_crdt_grad_text="",
            kbp_crdt_grad_text="",
            nice_crdt_grad_text="",
            fnp_crdt_grad_text="",
            dpsi_psbl_yn="Y",
            pnia_int_calc_unpr="0",
            prcm_idx_bond_yn="N",
            expd_exts_srdp_rcnt="0",
            expd_exts_srdp_rt="0",
            loan_psbl_yn="Y",
            grte_dvsn_cd="4",
            fnrr_rank_dvsn_cd="1",
            krx_lstg_abol_dvsn_cd="Y",
            asst_rqdi_dvsn_cd="",
            opcb_dvsn_cd="",
            crfd_item_yn="N",
            crfd_item_rstc_cclc_dt="",
            bond_nmpr_unit_pric="0.100000",
            ivst_heed_bond_dvsn_name="",
            add_erng_rt="0.000000",
            add_erng_rt_aply_dt="",
            bond_tr_stop_dvsn_cd="N",
            ivst_heed_bond_dvsn_cd="0",
            pclr_cndt_text="",
            hbbd_yn="N",
            cdtl_cptl_scty_type_cd="",
            elec_scty_yn="Y",
            sq1_clop_ecis_opng_dt="",
            frst_erlm_stfno="",
            frst_erlm_dt="",
            frst_erlm_tmd=""
        )
        MarketBondInquireAskingPrice.objects.create(
            code=MarketBondCode.objects.get(code='KR101501DA57'),
            aspr_acpt_hour="151804",
            bond_askp1="10373.50",
            bond_askp2="10374.10",
            bond_askp3="10374.40",
            bond_askp4="10374.60",
            bond_askp5="10374.80",
            bond_bidp1="10320.90",
            bond_bidp2="10320.80",
            bond_bidp3="10320.20",
            bond_bidp4="10320.10",
            bond_bidp5="10319.50",
            askp_rsqn1="37400",
            askp_rsqn2="4540",
            askp_rsqn3="1927",
            askp_rsqn4="53",
            askp_rsqn5="80",
            bidp_rsqn1="50000",
            bidp_rsqn2="470595",
            bidp_rsqn3="88190",
            bidp_rsqn4="5375",
            bidp_rsqn5="8530",
            total_askp_rsqn="44000",
            total_bidp_rsqn="672311",
            ntby_aspr_rsqn="628311",
            seln_ernn_rate1="2.668",
            seln_ernn_rate2="2.656",
            seln_ernn_rate3="2.650",
            seln_ernn_rate4="2.646",
            seln_ernn_rate5="2.642",
            shnu_ernn_rate1="3.715",
            shnu_ernn_rate2="3.717",
            shnu_ernn_rate3="3.729",
            shnu_ernn_rate4="3.731",
            shnu_ernn_rate5="3.743"
        )
        MarketBondInquirePrice.objects.create(
            code=MarketBondCode.objects.get(code='KR101501DA57'),
            stnd_iscd="KR101501DA57",
            hts_kor_isnm="국민주택1종20-05",
            bond_prpr="10328.00",
            prdy_vrss_sign="",
            bond_prdy_vrss="0.00",
            prdy_ctrt="0.00",
            acml_vol="0",
            bond_prdy_clpr="10328.00",
            bond_oprc="0.00",
            bond_hgpr="0.00",
            bond_lwpr="0.00",
            ernn_rate="0.000",
            oprc_ert="0.000",
            hgpr_ert="0.000",
            lwpr_ert="0.000",
            bond_mxpr="13463.70",
            bond_llam="7249.70"
        )

    def test_holding(self):
        headers = TestUser.Authorization_header
        # post test
        data = {
            'bond_code': 'KR101501DA57',
            'price_per_10': '10233',
            'quantity': '10',
            'expire_date': '2024-11-11',
            'purchase_date': '2024-10-02'
        }
        response = self.client.post('/api/marketbond/holding/', content_type='application/json', data=json.dumps(data), **headers)
        self.assertEqual(response.status_code, 201)
        # get test
        response = self.client.get('/api/marketbond/holding/', **headers)
        self.assertEqual(response.status_code, 200)
        print('holding data:', response.json())
        # delete test
        ins = MarketBondCode.objects.get(code='KR101501DA57')
        id = ET_Bond_Holding.objects.get(bond_code=ins).id
        response = self.client.delete(f'/api/marketbond/holding/{id}/', content_type='application/json', **headers)
        self.assertEqual(response.status_code, 204)

    def test_interest(self):
        headers = TestUser.Authorization_header
        data = {
            'bond_code': 'KR101501DA57'
        }
        response = self.client.post('/api/marketbond/interest/', content_type='application/json', data=json.dumps(data), **headers)
        self.assertEqual(response.status_code, 201)
        response = self.client.get('/api/marketbond/interest/', **headers)
        self.assertEqual(response.status_code, 200)
        # print('interest data:', response.json())
        response = self.client.delete('/api/marketbond/interest/KR101501DA57/', content_type='application/json', **headers)
        self.assertEqual(response.status_code, 204)

