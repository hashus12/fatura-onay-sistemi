*&---------------------------------------------------------------------*
*&  Include           ZFAT_ONAYGIR_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS icon.

TABLES: zfat_fatura.
TABLES: zfat_onay.
TABLES: zfat_pers.

DATA: ok_code LIKE sy-ucomm.
DATA: save_ok LIKE ok_code.

DATA: go_alv  TYPE REF TO cl_gui_alv_grid,
      go_cont TYPE REF TO cl_gui_custom_container.

CLASS cl_event_receiver DEFINITION DEFERRED.
DATA: go_event_receiver TYPE REF TO cl_event_receiver.

SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE text-003.
PARAMETERS: p_kullad TYPE zfat_pers-kullanici_ad   DEFAULT '' MODIF ID gr2,
            p_parola TYPE zfat_pers-parola   DEFAULT '' MODIF ID gr2.
SELECTION-SCREEN END OF BLOCK b03.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-001.
SELECT-OPTIONS : s_fatno FOR zfat_fatura-fatura_no MODIF ID gr1,
                 s_satno FOR zfat_fatura-satici_no MODIF ID gr1,
                 s_tarih FOR zfat_fatura-fatura_tarih MODIF ID gr1.
SELECTION-SCREEN END OF BLOCK b01.
SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE text-002.
PARAMETERS: p_tumucb AS CHECKBOX DEFAULT abap_true MODIF ID gr3 USER-COMMAND 1,
            p_onaycb AS CHECKBOX MODIF ID gr1,
            p_onbecb AS CHECKBOX MODIF ID gr1,
            p_onrecb AS CHECKBOX MODIF ID gr1.
SELECTION-SCREEN END OF BLOCK b02.

TYPES: BEGIN OF gty_kullpers,
         mandt        TYPE mandt,
         yonetici_no  TYPE zfat_yoneticino_de,
         kullanici_ad TYPE zfat_kullad_de,
         parola       TYPE zfat_parola_de,
       END OF gty_kullpers.

TYPES: BEGIN OF gty_onay_tablo,
         mandt        TYPE mandt,
         icon         TYPE icon_d,
         personel_no  TYPE zfat_persno_de,
         personel_ad  TYPE zfat_persad_de,
         yonetici_no  TYPE zfat_yoneticino_de,
         fatura_no    TYPE zfat_faturano_de,
         satici_no    TYPE zfat_satno_de,
         satici_ad    TYPE zfat_satad_de,
         fatura_tarih TYPE zfat_faturatar_de,
         fatura_tutar TYPE zfat_toptutar_de,
         aciklama     TYPE zfat_aciklama_de,
         onay_durum   TYPE zfat_onaydurum_de,
       END OF gty_onay_tablo.

TYPES: BEGIN OF gty_onay_kayit,
         mandt       TYPE mandt,
         fatura_no   TYPE zfat_faturano_de,
         personel_no TYPE zfat_persno_de,
         yonetici_no TYPE zfat_yoneticino_de,
         aciklama    TYPE zfat_aciklama_de,
         onay_durum  TYPE zfat_onaydurum_de,
       END OF gty_onay_kayit.

TYPES: BEGIN OF gty_jpers,
         personel_no  TYPE zfat_persno_de,
         personel_ad  TYPE zfat_persad_de,
         yonetici_no  TYPE zfat_yoneticino_de,
         yonetici_adi TYPE zfat_zyonetici_de,
         yonetici_tur TYPE zfat_yonturu_de,
         limit        TYPE zfat_limit_de,
       END OF gty_jpers.

TYPES: BEGIN OF gty_onay_durum,
         onay_durum TYPE zfat_onaydurum_de,
       END OF gty_onay_durum.
DATA: gt_onay_durum TYPE TABLE OF gty_onay_durum,
      gs_onay_durum TYPE  gty_onay_durum.

DATA:
  gt_onay_kayit TYPE TABLE OF gty_onay_kayit,
  gs_onay_kayit TYPE gty_onay_kayit,
  gt_kull_pers  TYPE TABLE OF gty_kullpers,
  gs_kull_pers  TYPE gty_kullpers,
  gt_onay       TYPE TABLE OF gty_onay_tablo,
  gs_onay       TYPE gty_onay_tablo,
  gt_jpers      TYPE TABLE OF gty_jpers,
  gs_jpers      TYPE  gty_jpers,
  gt_jpers_tmp  TYPE TABLE OF gty_jpers,
  gs_jpers_tmp  TYPE  gty_jpers.

DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat.

DATA: gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS: <gfs_fcat> TYPE lvc_s_fcat,
               <gfs_onay> TYPE gty_onay_tablo.
