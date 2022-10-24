*&---------------------------------------------------------------------*
*&  Include           ZFAT_FATISLEM_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS icon.

TABLES: zfat_fatura.
TABLES: zfat_onay.

DATA: ok_code LIKE sy-ucomm.
DATA: save_ok LIKE ok_code.

DATA: go_alv  TYPE REF TO cl_gui_alv_grid,
      go_alv2 TYPE REF TO cl_gui_alv_grid,
      go_alv3 TYPE REF TO cl_gui_alv_grid,
      go_cust TYPE REF TO cl_gui_custom_container.

DATA: go_splitter  TYPE REF TO cl_gui_splitter_container,
      go_splitter2 TYPE REF TO cl_gui_splitter_container,
      go_splitter3 TYPE REF TO cl_gui_splitter_container,
      go_gui1      TYPE REF TO cl_gui_container,
      go_gui2      TYPE REF TO cl_gui_container,
      go_gui3      TYPE REF TO cl_gui_container,
      go_gui4      TYPE REF TO cl_gui_container,
      go_gui5      TYPE REF TO cl_gui_container.

CLASS cl_event_receiver DEFINITION DEFERRED.
DATA: go_event_receiver TYPE REF TO cl_event_receiver.

TYPES: BEGIN OF gty_onay_tablo,
         mandt        TYPE mandt,
         icon         TYPE icon_d,
         personel_no  TYPE zfat_persno_de,
         personel_ad  TYPE zfat_persad_de,
         fatura_no    TYPE zfat_faturano_de,
         satici_no    TYPE zfat_satno_de,
         satici_ad    TYPE zfat_satad_de,
         fatura_tarih TYPE zfat_faturatar_de,
         fatura_tutar TYPE zfat_toptutar_de,
         ddtext       TYPE val_text,
         onay_durum   TYPE zfat_onaydurum_de,
         aciklama     TYPE zfat_aciklama_de,
       END OF gty_onay_tablo.

TYPES: BEGIN OF gty_onay_tablo2,
         mandt       TYPE mandt,
         fatura_no   TYPE zfat_faturano_de,
         grup_no     TYPE zfat_grupno_de,
         sira_no     TYPE zfat_sirano_de,

         personel_no TYPE zfat_persno_de,

         personel_ad TYPE zfat_persad_de,
         ddtext      TYPE val_text,
         onay_durum  TYPE zfat_onaydurum_de,
         aciklama    TYPE zfat_aciklama_de,
       END OF gty_onay_tablo2.

TYPES: BEGIN OF gty_save_onay_tablo,
         mandt       TYPE  mandt,
         fatura_no   TYPE zfat_faturano_de,
         grup_no     TYPE zfat_grupno_de,
         sira_no     TYPE zfat_sirano_de,
         personel_no TYPE zfat_persno_de,
         onay_durum  TYPE zfat_onaydurum_de,
         aciklama    TYPE zfat_aciklama_de,
       END OF gty_save_onay_tablo.

TYPES: BEGIN OF gty_onay_kayit,
         mandt       TYPE mandt,
         fatura_no   TYPE zfat_faturano_de,
         personel_no TYPE zfat_persno_de,
         yonetici_no TYPE zfat_yoneticino_de,
         onay_durum  TYPE zfat_onaydurum_de,
         aciklama    TYPE zfat_aciklama_de,
       END OF gty_onay_kayit.

TYPES: BEGIN OF gty_jpers,
         personel_no  TYPE zfat_persno_de,
         personel_ad  TYPE zfat_persad_de,
         yonetici_no  TYPE zfat_yoneticino_de,
         yonetici_adi TYPE zfat_zyonetici_de,
         yonetici_tur TYPE zfat_yonturu_de,
         limit        TYPE zfat_limit_de,
       END OF gty_jpers.

TYPES: BEGIN OF gty_fatura,
         mandt        TYPE  mandt,
         fatura_no    TYPE zfat_faturano_de,
         personel_no  TYPE zfat_persno_de,
         satici_no    TYPE zfat_satno_de,
         fatura_tarih TYPE zfat_faturatar_de,
         fatura_tutar TYPE zfat_toptutar_de,
         onay_durum   TYPE zfat_onaydurum_de,
       END OF gty_fatura.

TYPES: BEGIN OF gty_fatura_kalem,
         mandt       TYPE mandt,
         sira_no     TYPE zfat_sirano_de,
         fatura_no   TYPE  zfat_faturano_de,
         urun        TYPE zfat_urun_de,
         miktar      TYPE  zfat_miktar_de,
         birim_fiyat TYPE  zfat_birimfiyat_de,
         vergi       TYPE zfat_vergi_de,
         tutar       TYPE zfat_tutar_de,
       END OF gty_fatura_kalem.

TYPES: BEGIN OF gty_onay_durum,
         onay_durum TYPE zfat_onaydurum_de,
       END OF gty_onay_durum.

DATA: gt_onay_durum TYPE TABLE OF gty_onay_durum,
      gs_onay_durum TYPE  gty_onay_durum.

DATA: gv_kullanicipersno TYPE zfat_persno_de.

CONSTANTS:
  BEGIN OF c_statu,
    gv_onaybek       TYPE zfat_onaydurum_de VALUE '10',
    gv_onaysira      TYPE zfat_onaydurum_de VALUE '20',
    gv_onayredonceki TYPE zfat_onaydurum_de VALUE '30',
    gv_onayred       TYPE zfat_onaydurum_de VALUE '40',
    gv_onaylandi     TYPE zfat_onaydurum_de VALUE '50',
  END OF c_statu.

DATA: gv_tempgrup TYPE zfat_grupno_de.
DATA: gv_tempsira TYPE zfat_sirano_de.

DATA:
  gt_fatura       TYPE TABLE OF gty_fatura,
  gs_fatura       TYPE gty_fatura,
  gt_fatura_kalem TYPE TABLE OF gty_fatura_kalem,
  gs_fatura_kalem TYPE gty_fatura_kalem,
  gt_onay_kayit   TYPE TABLE OF gty_onay_kayit,
  gs_onay_kayit   TYPE gty_onay_kayit,
  gt_onay         TYPE TABLE OF gty_onay_tablo,
  gt_onay2        TYPE TABLE OF gty_onay_tablo2,
  gt_save_onay    TYPE TABLE OF gty_save_onay_tablo,
  gs_save_onay    TYPE gty_save_onay_tablo,
  gs_onay         TYPE zgty_onay_tablo,
  gs_onay2        TYPE gty_onay_tablo2,
  gt_jpers        TYPE TABLE OF gty_jpers,
  gs_jpers        TYPE  gty_jpers,
  gt_jpers_tmp    TYPE TABLE OF gty_jpers,
  gs_jpers_tmp    TYPE  gty_jpers.

DATA: gt_fcat  TYPE lvc_t_fcat,
      gt_fcat2 TYPE lvc_t_fcat,
      gt_fcat3 TYPE lvc_t_fcat,
      gs_fcat  TYPE lvc_s_fcat.

DATA: gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS: <gfs_fcat>      TYPE lvc_s_fcat,
               <gfs_onay2>     TYPE gty_onay_tablo2,
               <gfs_onay>      TYPE gty_onay_tablo,
               <gfs_save_onay> TYPE gty_save_onay_tablo,
               <gfs_fatura>    TYPE gty_fatura.

DATA: gv_onaybek       TYPE zfat_onaydurum_de,
      gv_onaysira      TYPE zfat_onaydurum_de,
      gv_onaylandi     TYPE zfat_onaydurum_de,
      gv_onayred       TYPE zfat_onaydurum_de,
      gv_onayredonceki TYPE zfat_onaydurum_de.

DATA: gt_satici     TYPE TABLE OF zfat_satici,
      gs_satici     TYPE zfat_satici,
      gt_pers       TYPE TABLE OF zfat_pers,
      gs_pers       TYPE zfat_pers,
      gt_onayalv    TYPE TABLE OF zfat_onay,
      gs_onayalv    TYPE zfat_onay,
      gt_dd07t      TYPE TABLE OF dd07t,
      gs_dd07t      TYPE dd07t.

"""smartform top
DATA:     html_viewer         TYPE REF TO cl_gui_html_viewer.

TYPES :
  ty_it0002          TYPE pa0002,
  ty_it0008          TYPE pa0008,
  ty_control_par     TYPE ssfctrlop,
  ty_output_options  TYPE ssfcompop,
  ty_job_output_info TYPE ssfcrescl,
  ty_otf_data        TYPE itcoo,
  ty_pdf             TYPE tline.

DATA:
  wa_it0002          TYPE ty_it0002,
  wa_it0008          TYPE ty_it0008,
  wa_control_par     TYPE ty_control_par,
  wa_output_options  TYPE ty_output_options,
  wa_job_output_info TYPE ty_job_output_info,
  wa_pdf             TYPE ty_pdf.
DATA:
  it_it0002   TYPE STANDARD TABLE OF ty_it0002,
  it_it0008   TYPE STANDARD TABLE OF ty_it0008,
  it_otf_data TYPE STANDARD TABLE OF ty_otf_data,
  it_pdf      TYPE STANDARD TABLE OF ty_pdf,
  it_data     TYPE STANDARD TABLE OF x255.
DATA:
  gv_fm_name      TYPE  rs38l_fnam,
  gv_url          TYPE char255,
  gv_content      TYPE xstring,
  okcode          TYPE sy-ucomm,
  gv_bin_filesize TYPE i.

FIELD-SYMBOLS <fs_x> TYPE x.
