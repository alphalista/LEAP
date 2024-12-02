from django.db import models
from django.db.models import UniqueConstraint


# Create your models here.
# Duplicated model from kpaas_rest


class MarketBondCode(models.Model):
    code = models.CharField(max_length=100)
    name = models.CharField(max_length=100)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['code'], name='unique_code_field')
        ]

# 장내채권 발행정보
class MarketBondIssueInfo(models.Model):
    code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    pdno = models.CharField(max_length=12, verbose_name="상품번호")
    prdt_type_cd = models.CharField(max_length=3, verbose_name="상품유형코드")
    prdt_name = models.CharField(max_length=60, verbose_name="상품명")
    prdt_eng_name = models.CharField(max_length=60, verbose_name="상품영문명")
    ivst_heed_prdt_yn = models.CharField(max_length=1, verbose_name="투자유의상품여부")
    exts_yn = models.CharField(max_length=1, verbose_name="연장여부")
    bond_clsf_cd = models.CharField(max_length=6, verbose_name="채권분류코드")
    bond_clsf_kor_name = models.CharField(max_length=60, verbose_name="채권분류한글명")
    papr = models.CharField(max_length=19, verbose_name="액면가")
    int_mned_dvsn_cd = models.CharField(max_length=1, verbose_name="이자월말구분코드")
    rvnu_shap_cd = models.CharField(max_length=1, verbose_name="매출형태코드")
    issu_amt = models.CharField(max_length=19, verbose_name="발행금액")
    lstg_rmnd = models.CharField(max_length=19, verbose_name="상장잔액")
    int_dfrm_mcnt = models.CharField(max_length=6, verbose_name="이자지급개월수")
    bond_int_dfrm_mthd_cd = models.CharField(
        max_length=2, verbose_name="채권이자지급방법코드"
    )
    splt_rdpt_rcnt = models.CharField(max_length=6, verbose_name="분할상환횟수")
    prca_dfmt_term_mcnt = models.CharField(
        max_length=6, verbose_name="원금거치기간개월수"
    )
    int_anap_dvsn_cd = models.CharField(max_length=1, verbose_name="이자선후급구분코드")
    bond_rght_dvsn_cd = models.CharField(max_length=2, verbose_name="채권권리구분코드")
    prdt_pclc_text = models.CharField(max_length=500, verbose_name="상품특성내용")
    prdt_abrv_name = models.CharField(max_length=60, verbose_name="상품약어명")
    prdt_eng_abrv_name = models.CharField(max_length=60, verbose_name="상품영문약어명")
    sprx_psbl_yn = models.CharField(max_length=1, verbose_name="분리과세가능여부")
    pbff_pplc_ofrg_mthd_cd = models.CharField(
        max_length=2, verbose_name="공모사모모집방법코드"
    )
    cmco_cd = models.CharField(max_length=4, verbose_name="주간사코드")
    issu_istt_cd = models.CharField(max_length=5, verbose_name="발행기관코드")
    issu_istt_name = models.CharField(max_length=60, verbose_name="발행기관명")
    pnia_dfrm_agcy_istt_cd = models.CharField(
        max_length=4, verbose_name="원리금지급대행기관코드"
    )
    dsct_ec_rt = models.CharField(max_length=238, verbose_name="할인할증율")
    srfc_inrt = models.CharField(max_length=238, verbose_name="표면이율")
    expd_rdpt_rt = models.CharField(max_length=238, verbose_name="만기상환율")
    expd_asrc_erng_rt = models.CharField(max_length=238, verbose_name="만기보장수익율")
    bond_grte_istt_name = models.CharField(max_length=60, verbose_name="채권보증기관명")
    int_dfrm_day_type_cd = models.CharField(
        max_length=2, verbose_name="이자지급일유형코드"
    )
    ksd_int_calc_unit_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원이자계산단위코드"
    )
    int_wunt_uder_prcs_dvsn_cd = models.CharField(
        max_length=1, verbose_name="이자원화단위미만처리구분코드"
    )
    rvnu_dt = models.CharField(max_length=8, verbose_name="매출일자")
    issu_dt = models.CharField(max_length=8, verbose_name="발행일자")
    lstg_dt = models.CharField(max_length=8, verbose_name="상장일자")
    expd_dt = models.CharField(max_length=8, verbose_name="만기일자")
    rdpt_dt = models.CharField(max_length=8, verbose_name="상환일자")
    sbst_pric = models.CharField(max_length=19, verbose_name="대용가격")
    rgbf_int_dfrm_dt = models.CharField(max_length=8, verbose_name="직전이자지급일자")
    nxtm_int_dfrm_dt = models.CharField(max_length=8, verbose_name="차기이자지급일자")
    frst_int_dfrm_dt = models.CharField(max_length=8, verbose_name="최초이자지급일자")
    ecis_pric = models.CharField(max_length=19, verbose_name="행사가격")
    rght_stck_std_pdno = models.CharField(
        max_length=12, verbose_name="권리주식표준상품번호"
    )
    ecis_opng_dt = models.CharField(max_length=8, verbose_name="행사개시일자")
    ecis_end_dt = models.CharField(max_length=8, verbose_name="행사종료일자")
    bond_rvnu_mthd_cd = models.CharField(max_length=2, verbose_name="채권매출방법코드")
    oprt_stfno = models.CharField(max_length=6, verbose_name="조작직원번호")
    oprt_stff_name = models.CharField(max_length=60, verbose_name="조작직원명")
    rgbf_int_dfrm_wday = models.CharField(max_length=2, verbose_name="직전이자지급요일")
    nxtm_int_dfrm_wday = models.CharField(max_length=2, verbose_name="차기이자지급요일")
    kis_crdt_grad_text = models.CharField(
        max_length=500, verbose_name="한국신용평가신용등급내용"
    )
    kbp_crdt_grad_text = models.CharField(
        max_length=500, verbose_name="한국채권평가신용등급내용"
    )
    nice_crdt_grad_text = models.CharField(
        max_length=500, verbose_name="한국신용정보신용등급내용"
    )
    fnp_crdt_grad_text = models.CharField(
        max_length=500, verbose_name="에프앤자산평가신용등급내용"
    )
    dpsi_psbl_yn = models.CharField(max_length=1, verbose_name="예탁가능여부")
    pnia_int_calc_unpr = models.CharField(
        max_length=234, verbose_name="원리금이자계산단가"
    )
    prcm_idx_bond_yn = models.CharField(max_length=1, verbose_name="물가지수채권여부")
    expd_exts_srdp_rcnt = models.CharField(
        max_length=10, verbose_name="만기연장분할상환횟수"
    )
    expd_exts_srdp_rt = models.CharField(
        max_length=2212, verbose_name="만기연장분할상환율"
    )
    loan_psbl_yn = models.CharField(max_length=1, verbose_name="대출가능여부")
    grte_dvsn_cd = models.CharField(max_length=1, verbose_name="보증구분코드")
    fnrr_rank_dvsn_cd = models.CharField(max_length=1, verbose_name="선후순위구분코드")
    krx_lstg_abol_dvsn_cd = models.CharField(
        max_length=1, verbose_name="한국거래소상장폐지구분코드"
    )
    asst_rqdi_dvsn_cd = models.CharField(
        max_length=2, verbose_name="자산유동화구분코드"
    )
    opcb_dvsn_cd = models.CharField(max_length=1, verbose_name="옵션부사채구분코드")
    crfd_item_yn = models.CharField(max_length=1, verbose_name="크라우드펀딩종목여부")
    crfd_item_rstc_cclc_dt = models.CharField(
        max_length=8, verbose_name="크라우드펀딩종목제한해지일자"
    )
    bond_nmpr_unit_pric = models.CharField(
        max_length=202, verbose_name="채권호가단위가격"
    )
    ivst_heed_bond_dvsn_name = models.CharField(
        max_length=60, verbose_name="투자유의채권구분명"
    )
    add_erng_rt = models.CharField(max_length=238, verbose_name="추가수익율")
    add_erng_rt_aply_dt = models.CharField(
        max_length=8, verbose_name="추가수익율적용일자"
    )
    bond_tr_stop_dvsn_cd = models.CharField(
        max_length=1, verbose_name="채권거래정지구분코드"
    )
    ivst_heed_bond_dvsn_cd = models.CharField(
        max_length=1, verbose_name="투자유의채권구분코드"
    )
    pclr_cndt_text = models.CharField(max_length=500, verbose_name="특이조건내용")
    hbbd_yn = models.CharField(max_length=1, verbose_name="하이브리드채권여부")
    cdtl_cptl_scty_type_cd = models.CharField(
        max_length=1, verbose_name="조건부자본증권유형코드"
    )
    elec_scty_yn = models.CharField(max_length=1, verbose_name="전자증권여부")
    sq1_clop_ecis_opng_dt = models.CharField(
        max_length=8, verbose_name="1차콜옵션행사개시일자"
    )
    frst_erlm_stfno = models.CharField(max_length=6, verbose_name="최초등록직원번호")
    frst_erlm_dt = models.CharField(max_length=8, verbose_name="최초등록일자")
    frst_erlm_tmd = models.CharField(max_length=6, verbose_name="최초등록시각")


# 장내채권 기본조회
class MarketBondSearchInfo(models.Model):
    code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    pdno = models.CharField(max_length=12, verbose_name="상품번호")
    prdt_type_cd = models.CharField(max_length=3, verbose_name="상품유형코드")
    ksd_bond_item_name = models.CharField(
        max_length=100, verbose_name="증권예탁결제원채권종목명"
    )
    ksd_bond_item_eng_name = models.CharField(
        max_length=100, verbose_name="증권예탁결제원채권종목영문명"
    )
    ksd_bond_lstg_type_cd = models.CharField(
        max_length=2, verbose_name="증권예탁결제원채권상장유형코드"
    )
    ksd_ofrg_dvsn_cd = models.CharField(
        max_length=2, verbose_name="증권예탁결제원모집구분코드"
    )
    ksd_bond_int_dfrm_dvsn_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원채권이자지급구분"
    )
    issu_dt = models.CharField(max_length=8, verbose_name="발행일자")
    rdpt_dt = models.CharField(max_length=8, verbose_name="상환일자")
    rvnu_dt = models.CharField(max_length=8, verbose_name="매출일자")
    iso_crcy_cd = models.CharField(max_length=3, verbose_name="통화코드")
    mdwy_rdpt_dt = models.CharField(max_length=8, verbose_name="중도상환일자")
    ksd_rcvg_bond_dsct_rt = models.CharField(
        max_length=2212, verbose_name="증권예탁결제원수신채권할인율"
    )
    ksd_rcvg_bond_srfc_inrt = models.CharField(
        max_length=2012, verbose_name="증권예탁결제원수신채권표면이율"
    )
    bond_expd_rdpt_rt = models.CharField(max_length=2212, verbose_name="채권만기상환율")
    ksd_prca_rdpt_mthd_cd = models.CharField(
        max_length=2, verbose_name="증권예탁결제원원금상환방법코드"
    )
    int_caltm_mcnt = models.CharField(max_length=10, verbose_name="이자계산기간개월수")
    ksd_int_calc_unit_cd = models.CharField(
        max_length=1,
        verbose_name="증권예탁결제원이자계산단위코드",
        choices=[("1", "발행금액"), ("2", "만원"), ("3", "십만원"), ("4", "백만원")],
    )
    uval_cut_dvsn_cd = models.CharField(max_length=1, verbose_name="절상절사구분코드")
    uval_cut_dcpt_dgit = models.CharField(
        max_length=10, verbose_name="절상절사소수점자릿수"
    )
    ksd_dydv_caltm_aply_dvsn_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원일할계산기간적용"
    )
    dydv_calc_dcnt = models.CharField(max_length=5, verbose_name="일할계산일수")
    bond_expd_asrc_erng_rt = models.CharField(
        max_length=2212, verbose_name="채권만기보장수익율"
    )
    padf_plac_hdof_name = models.CharField(
        max_length=60, verbose_name="원리금지급장소본점명"
    )
    lstg_dt = models.CharField(max_length=8, verbose_name="상장일자")
    lstg_abol_dt = models.CharField(max_length=8, verbose_name="상장폐지일자")
    ksd_bond_issu_mthd_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원채권발행방법코드"
    )
    laps_indf_yn = models.CharField(max_length=1, verbose_name="경과이자지급여부")
    ksd_lhdy_pnia_dfrm_mthd_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원공휴일원리금지급"
    )
    frst_int_dfrm_dt = models.CharField(max_length=8, verbose_name="최초이자지급일자")
    ksd_prcm_lnkg_gvbd_yn = models.CharField(
        max_length=1, verbose_name="증권예탁결제원물가연동국고채여"
    )
    dpsi_end_dt = models.CharField(max_length=8, verbose_name="예탁종료일자")
    dpsi_strt_dt = models.CharField(max_length=8, verbose_name="예탁시작일자")
    dpsi_psbl_yn = models.CharField(max_length=1, verbose_name="예탁가능여부")
    atyp_rdpt_bond_erlm_yn = models.CharField(
        max_length=1, verbose_name="비정형상환채권등록여부"
    )
    dshn_occr_yn = models.CharField(max_length=1, verbose_name="부도발생여부")
    expd_exts_yn = models.CharField(max_length=1, verbose_name="만기연장여부")
    pclr_ptcr_text = models.CharField(max_length=500, verbose_name="특이사항내용")
    dpsi_psbl_excp_stat_cd = models.CharField(
        max_length=2, verbose_name="예탁가능예외상태코드"
    )
    expd_exts_srdp_rcnt = models.CharField(
        max_length=10, verbose_name="만기연장분할상환횟수"
    )
    expd_exts_srdp_rt = models.CharField(
        max_length=2212, verbose_name="만기연장분할상환율"
    )
    expd_rdpt_rt = models.CharField(max_length=238, verbose_name="만기상환율")
    expd_asrc_erng_rt = models.CharField(max_length=238, verbose_name="만기보장수익율")
    bond_int_dfrm_mthd_cd = models.CharField(
        max_length=2,
        verbose_name="채권이자지급방법코드",
        choices=[
            ("01", "할인채"),
            ("02", "복리채"),
            ("03", "이표채.확정금리"),
            ("04", "이표채.금리연동"),
            ("05", "이표채.변동금리"),
            ("06", "단리채"),
            ("07", "분할채"),
            ("09", "복5단2"),
            ("19", "기타.고정금리"),
            ("29", "기타.변동금리"),
        ],
    )
    int_dfrm_day_type_cd = models.CharField(
        max_length=2,
        verbose_name="이자지급일유형코드",
        choices=[("01", "발행일"), ("02", "만기일"), ("03", "특정일")],
    )
    prca_dfmt_term_mcnt = models.CharField(
        max_length=6, verbose_name="원금거치기간개월수"
    )
    splt_rdpt_rcnt = models.CharField(max_length=6, verbose_name="분할상환횟수")
    rgbf_int_dfrm_dt = models.CharField(max_length=8, verbose_name="직전이자지급일자")
    nxtm_int_dfrm_dt = models.CharField(max_length=8, verbose_name="차기이자지급일자")
    sprx_psbl_yn = models.CharField(max_length=1, verbose_name="분리과세가능여부")
    ictx_rt_dvsn_cd = models.CharField(max_length=2, verbose_name="소득세율구분코드")
    bond_clsf_cd = models.CharField(max_length=6, verbose_name="채권분류코드")
    bond_clsf_kor_name = models.CharField(max_length=60, verbose_name="채권분류한글명")
    int_mned_dvsn_cd = models.CharField(
        max_length=1,
        verbose_name="이자월말구분코드",
        choices=[("0", "확인불가"), ("1", "일자기준"), ("2", "말일기준")],
    )
    pnia_int_calc_unpr = models.CharField(
        max_length=234, verbose_name="원리금이자계산단가"
    )
    frn_intr = models.CharField(max_length=1512, verbose_name="FRN금리")
    aply_day_prcm_idx_lnkg_cefc = models.CharField(
        max_length=151, verbose_name="적용일물가지수연동계수"
    )
    ksd_expd_dydv_calc_bass_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원만기일할계산기준"
    )
    expd_dydv_calc_dcnt = models.CharField(
        max_length=9, verbose_name="만기일할계산일수"
    )
    ksd_cbbw_dvsn_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원신종사채구분코드"
    )
    crfd_item_yn = models.CharField(max_length=1, verbose_name="크라우드펀딩종목여부")
    pnia_bank_ofdy_dfrm_mthd_cd = models.CharField(
        max_length=1, verbose_name="원리금은행휴무일지급방법코드"
    )
    qib_yn = models.CharField(max_length=1, verbose_name="QIB여부")
    qib_cclc_dt = models.CharField(max_length=8, verbose_name="QIB해지일자")
    csbd_yn = models.CharField(max_length=1, verbose_name="영구채여부")
    csbd_cclc_dt = models.CharField(max_length=8, verbose_name="영구채해지일자")
    ksd_opcb_yn = models.CharField(
        max_length=1, verbose_name="증권예탁결제원옵션부사채여부"
    )
    ksd_sodn_yn = models.CharField(
        max_length=1, verbose_name="증권예탁결제원후순위채권여부"
    )
    ksd_rqdi_scty_yn = models.CharField(
        max_length=1, verbose_name="증권예탁결제원유동화증권여부"
    )
    elec_scty_yn = models.CharField(max_length=1, verbose_name="전자증권여부")
    rght_ecis_mbdy_dvsn_cd = models.CharField(
        max_length=1, verbose_name="권리행사주체구분코드"
    )
    int_rkng_mthd_dvsn_cd = models.CharField(
        max_length=1, verbose_name="이자산정방법구분코드"
    )
    ofrg_dvsn_cd = models.CharField(max_length=2, verbose_name="모집구분코드")
    ksd_tot_issu_amt = models.CharField(
        max_length=202, verbose_name="증권예탁결제원총발행금액"
    )
    next_indf_chk_ecls_yn = models.CharField(
        max_length=1, verbose_name="다음이자지급체크제외여부"
    )
    ksd_bond_intr_dvsn_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원채권금리구분코드"
    )
    ksd_inrt_aply_dvsn_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원이율적용구분코드"
    )
    krx_issu_istt_cd = models.CharField(max_length=5, verbose_name="KRX발행기관코드")
    ksd_indf_frqc_uder_calc_cd = models.CharField(
        max_length=1, verbose_name="증권예탁결제원이자지급주기미만"
    )
    ksd_indf_frqc_uder_calc_dcnt = models.CharField(
        max_length=5, verbose_name="증권예탁결제원이자지급주기미만"
    )
    tlg_rcvg_dtl_dtime = models.CharField(
        max_length=10, verbose_name="전문수신상세일시"
    )


# 장내채권현재가(호가)
class MarketBondInquireAskingPrice(models.Model):
    code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    aspr_acpt_hour = models.CharField(max_length=6, verbose_name="호가 접수 시간")
    bond_askp1 = models.CharField(max_length=112, verbose_name="채권 매도호가1")
    bond_askp2 = models.CharField(max_length=112, verbose_name="채권 매도호가2")
    bond_askp3 = models.CharField(max_length=112, verbose_name="채권 매도호가3")
    bond_askp4 = models.CharField(max_length=112, verbose_name="채권 매도호가4")
    bond_askp5 = models.CharField(max_length=112, verbose_name="채권 매도호가5")
    bond_bidp1 = models.CharField(max_length=112, verbose_name="채권 매수호가1")
    bond_bidp2 = models.CharField(max_length=112, verbose_name="채권 매수호가2")
    bond_bidp3 = models.CharField(max_length=112, verbose_name="채권 매수호가3")
    bond_bidp4 = models.CharField(max_length=112, verbose_name="채권 매수호가4")
    bond_bidp5 = models.CharField(max_length=112, verbose_name="채권 매수호가5")
    askp_rsqn1 = models.CharField(max_length=12, verbose_name="매도호가 잔량1")
    askp_rsqn2 = models.CharField(max_length=12, verbose_name="매도호가 잔량2")
    askp_rsqn3 = models.CharField(max_length=12, verbose_name="매도호가 잔량3")
    askp_rsqn4 = models.CharField(max_length=12, verbose_name="매도호가 잔량4")
    askp_rsqn5 = models.CharField(max_length=12, verbose_name="매도호가 잔량5")
    bidp_rsqn1 = models.CharField(max_length=12, verbose_name="매수호가 잔량1")
    bidp_rsqn2 = models.CharField(max_length=12, verbose_name="매수호가 잔량2")
    bidp_rsqn3 = models.CharField(max_length=12, verbose_name="매수호가 잔량3")
    bidp_rsqn4 = models.CharField(max_length=12, verbose_name="매수호가 잔량4")
    bidp_rsqn5 = models.CharField(max_length=12, verbose_name="매수호가 잔량5")
    total_askp_rsqn = models.CharField(max_length=12, verbose_name="총 매도호가 잔량")
    total_bidp_rsqn = models.CharField(max_length=12, verbose_name="총 매수호가 잔량")
    ntby_aspr_rsqn = models.CharField(max_length=12, verbose_name="순매수 호가 잔량")
    seln_ernn_rate1 = models.CharField(max_length=84, verbose_name="매도 수익 비율1")
    seln_ernn_rate2 = models.CharField(max_length=84, verbose_name="매도 수익 비율2")
    seln_ernn_rate3 = models.CharField(max_length=84, verbose_name="매도 수익 비율3")
    seln_ernn_rate4 = models.CharField(max_length=84, verbose_name="매도 수익 비율4")
    seln_ernn_rate5 = models.CharField(max_length=84, verbose_name="매도 수익 비율5")
    shnu_ernn_rate1 = models.CharField(max_length=84, verbose_name="매수2 수익 비율1")
    shnu_ernn_rate2 = models.CharField(max_length=84, verbose_name="매수2 수익 비율2")
    shnu_ernn_rate3 = models.CharField(max_length=84, verbose_name="매수2 수익 비율3")
    shnu_ernn_rate4 = models.CharField(max_length=84, verbose_name="매수2 수익 비율4")
    shnu_ernn_rate5 = models.CharField(max_length=84, verbose_name="매수2 수익 비율5")

    class Meta:
        constraints = [
            UniqueConstraint(
                fields=["aspr_acpt_hour", "code"], name="unique_asking_price"
            )
        ]


# 장내채권 평균단가조회
# 추가(수정)필요
class MarketBondAvgUnit(models.Model):
    pass


# 장내채권 기간별시세(일)
class MarketBondInquireDailyItemChartPrice(models.Model):
    code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    stck_bsop_date = models.CharField(max_length=8, verbose_name="주식영업일자")
    bond_oprc = models.CharField(max_length=112, verbose_name="채권시가2")
    bond_hgpr = models.CharField(max_length=112, verbose_name="채권고가")
    bond_lwpr = models.CharField(max_length=112, verbose_name="채권저가")
    bond_prpr = models.CharField(max_length=112, verbose_name="채권현재가")
    acml_vol = models.CharField(max_length=18, verbose_name="누적거래량")

    class Meta:
        constraints = [
            UniqueConstraint(
                fields=["stck_bsop_date", "code"], name="unique_daily_item_chart_price"
            )
        ]


# 장내채권현재가(시세)
class MarketBondInquirePrice(models.Model):
    code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    stnd_iscd = models.CharField(max_length=12, verbose_name="표준종목코드")
    hts_kor_isnm = models.CharField(max_length=40, verbose_name="HTS한글종목명")
    bond_prpr = models.CharField(max_length=112, verbose_name="채권현재가")
    prdy_vrss_sign = models.CharField(max_length=1, verbose_name="전일대비부호")
    bond_prdy_vrss = models.CharField(max_length=112, verbose_name="채권전일대비")
    prdy_ctrt = models.CharField(max_length=82, verbose_name="전일대비율")
    acml_vol = models.CharField(max_length=18, verbose_name="누적거래량")
    bond_prdy_clpr = models.CharField(max_length=112, verbose_name="채권전일종가")
    bond_oprc = models.CharField(max_length=112, verbose_name="채권시가2")
    bond_hgpr = models.CharField(max_length=112, verbose_name="채권고가")
    bond_lwpr = models.CharField(max_length=112, verbose_name="채권저가")
    ernn_rate = models.CharField(max_length=84, verbose_name="수익비율")
    oprc_ert = models.CharField(max_length=72, verbose_name="시가2수익률")
    hgpr_ert = models.CharField(max_length=72, verbose_name="최고가수익률")
    lwpr_ert = models.CharField(max_length=72, verbose_name="최저가수익률")
    bond_mxpr = models.CharField(max_length=112, verbose_name="채권상한가")
    bond_llam = models.CharField(max_length=112, verbose_name="채권하한가")

    class Meta:
        constraints = [
            UniqueConstraint(fields=["code"], name="unique_price")
        ]


# 장내채권현재가(체결)
class MarketBondInquireCCNL(models.Model):
    code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    stck_cntg_hour = models.CharField(max_length=6, verbose_name="주식 체결 시간")
    bond_prpr = models.CharField(max_length=112, verbose_name="채권 현재가")
    bond_prdy_vrss = models.CharField(max_length=112, verbose_name="채권 전일 대비")
    prdy_vrss_sign = models.CharField(max_length=1, verbose_name="전일 대비 부호")
    prdy_ctrt = models.CharField(max_length=82, verbose_name="전일 대비율")
    cntg_vol = models.CharField(max_length=18, verbose_name="체결 거래량")
    acml_vol = models.CharField(max_length=18, verbose_name="누적 거래량")


# 장내채권현재가(일별)
class MarketBondInquireDailyPrice(models.Model):
    code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    stck_bsop_date = models.CharField(max_length=8, verbose_name="주식영업일자")
    bond_prpr = models.CharField(max_length=112, verbose_name="채권현재가")
    bond_prdy_vrss = models.CharField(max_length=112, verbose_name="채권전일대비")
    prdy_vrss_sign = models.CharField(max_length=1, verbose_name="전일대비부호")
    prdy_ctrt = models.CharField(max_length=82, verbose_name="전일대비율")
    acml_vol = models.CharField(max_length=18, verbose_name="누적거래량")
    bond_oprc = models.CharField(max_length=112, verbose_name="채권시가")
    bond_hgpr = models.CharField(max_length=112, verbose_name="채권고가")
    bond_lwpr = models.CharField(max_length=112, verbose_name="채권저가")

    class Meta:
        constraints = [
            UniqueConstraint(fields=["code", "stck_bsop_date"], name="unique_daily_price")
        ]

class MarketBondCmb(models.Model):
    # You can adjust these fields based on the actual fields you need from the other models
    code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    issue_info_data = models.ForeignKey(MarketBondIssueInfo, on_delete=models.CASCADE)
    inquire_price_data = models.ForeignKey(MarketBondInquirePrice, on_delete=models.CASCADE)
    inquire_asking_price_data = models.ForeignKey(MarketBondInquireAskingPrice, on_delete=models.CASCADE)

class MarketBondPreDataDays(models.Model):
    bond_code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)
    class Meta:
        db_table = "MarketBondPreDataDays"

class MarketBondPreDataWeeks(models.Model):
    bond_code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)
    class Meta:
        db_table = "MarketBondPreDataWeeks"

class MarketBondPreDataMonths(models.Model):
    bond_code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)

    class Meta:
        db_table = "MarketBondPreDataMonths"

class MarketBondHowManyInterest(models.Model):
    bond_code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    interest = models.IntegerField()
    danger_degree = models.CharField(max_length=100)
    # 프로젝트 명이 같기 때문에 테이블 명 따로 선언하지 않아도 됨

class MarketBondTrending(models.Model):
    bond_code = models.ForeignKey(MarketBondCode, on_delete=models.CASCADE)
    bond_name = models.CharField(max_length=200)
    YTM = models.CharField(max_length=100)
    add_date = models.DateField(auto_now_add=True)
