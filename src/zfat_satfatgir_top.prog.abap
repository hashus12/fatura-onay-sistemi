*&---------------------------------------------------------------------*
*&  Include           ZFAT_SATFATGIR_TOP
*&---------------------------------------------------------------------*


TABLES: zfat_fatura.
TABLES: zfat_fatkalem.
TABLES: zfat_onay.

DATA: ok_code LIKE sy-ucomm.
DATA: save_ok LIKE ok_code.

DATA: go_alv  TYPE REF TO cl_gui_alv_grid,
      go_cont TYPE REF TO cl_gui_custom_container.

DATA: gs_cell_color TYPE lvc_s_scol.

CLASS cl_event_receiver DEFINITION DEFERRED.
DATA: go_event_receiver TYPE REF TO cl_event_receiver.

TYPES: BEGIN OF gty_fatura,
         mandt        TYPE  mandt,
         fatura_no    TYPE zfat_faturano_de,
         personel_no  TYPE zfat_persno_de,
         satici_no    TYPE zfat_satno_de,
         fatura_tarih TYPE zfat_faturatar_de,
         fatura_tutar TYPE zfat_toptutar_de,
         onay_durum  TYPE zfat_onaydurum_de,
       END OF gty_fatura.

TYPES: BEGIN OF gty_fatura_kalem,
         mark,
         fatura_no   TYPE  zfat_faturano_de,
         urun        TYPE zfat_urun_de,
         miktar      TYPE	zfat_miktar_de,
         birim_fiyat TYPE  zfat_birimfiyat_de,
         vergi       TYPE zfat_vergi_de,
         tutar       TYPE zfat_tutar_de,
       END OF gty_fatura_kalem.

TYPES: BEGIN OF gty_save_fatura_kalem,
         mandt       TYPE mandt,
         sira_no     TYPE zfat_sirano_de,
         fatura_no   TYPE  zfat_faturano_de,
         urun        TYPE zfat_urun_de,
         miktar      TYPE  zfat_miktar_de,
         birim_fiyat TYPE  zfat_birimfiyat_de,
         vergi       TYPE zfat_vergi_de,
         tutar       TYPE zfat_tutar_de,
       END OF gty_save_fatura_kalem.

TYPES: BEGIN OF gty_jpers,
         personel_no  TYPE zfat_persno_de,
         grup_no      TYPE zfat_grupno_de,
         sira_no      TYPE zfat_sirano_de,
         personel_ad  TYPE zfat_persad_de,
         yonetici_no  TYPE zfat_yoneticino_de,
         yonetici_tur TYPE zfat_yonturu_de,
         limit        TYPE zfat_limit_de,
       END OF gty_jpers.

TYPES: BEGIN OF gty_onay,
         mandt       TYPE  mandt,
         fatura_no   TYPE zfat_faturano_de,
         grup_no     TYPE zfat_grupno_de,
         sira_no     TYPE zfat_sirano_de,
         personel_no TYPE zfat_persno_de,
         onay_durum  TYPE zfat_onaydurum_de,
         aciklama    TYPE zfat_aciklama_de,
       END OF gty_onay.

CONSTANTS:
BEGIN OF c_statu,
  gv_onaybek       TYPE zfat_onaydurum_de VALUE '10',
  gv_onaysira      TYPE zfat_onaydurum_de VALUE '20',
  gv_onayredonceki TYPE zfat_onaydurum_de VALUE '30',
  gv_onayred       TYPE zfat_onaydurum_de VALUE '40',
  gv_onaylandi     TYPE zfat_onaydurum_de VALUE '50',
END OF c_statu.

DATA:
  gs_onay               TYPE gty_onay,
  gt_fatura             TYPE TABLE OF gty_fatura,
  gt_fatura_kalem       TYPE TABLE OF gty_fatura_kalem,
  gt_jpers              TYPE TABLE OF gty_jpers,
  gt_jpers_tmp          TYPE TABLE OF gty_jpers,
  gt_jpers2             TYPE TABLE OF gty_jpers,
  gt_save_fatura_kalem  TYPE TABLE OF gty_save_fatura_kalem,
  gt_save_fatura_kalem2 TYPE TABLE OF gty_save_fatura_kalem,
  gs_save_fatura_kalem  TYPE gty_save_fatura_kalem,
  gs_jpers              TYPE gty_jpers,
  gs_jpers_tmp          TYPE gty_jpers,
  gs_jpers2             TYPE gty_jpers,
  gs_fatura             TYPE gty_fatura,
  gs_fatura_kalem       TYPE gty_fatura_kalem.

DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat.

DATA: gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS: <gfs_fcat>      TYPE lvc_t_fcat,
               <gfs_jpers>     TYPE gty_jpers,
               <gfs_jpers_tmp> TYPE gty_jpers.



*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC1' ITSELF
CONTROLS: tc1 TYPE TABLEVIEW USING SCREEN 0200.

*&SPWIZARD: LINES OF TABLECONTROL 'TC1'
DATA: g_tc1_lines LIKE sy-loopc.
