*&---------------------------------------------------------------------*
*&  Include           ZFAT_SATFATGIR_FRM
*&---------------------------------------------------------------------*
FORM display_alv .
  IF  go_cont IS INITIAL.
    CREATE OBJECT go_cont
      EXPORTING
        container_name              = 'CC_ALV'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent          = go_cont
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_event_receiver.

    CALL METHOD go_alv->set_table_for_first_display
      CHANGING
        it_outtab                     = gt_jpers
        it_fieldcatalog               = gt_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL METHOD go_alv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    ENDIF.
  ENDIF.

  CALL METHOD go_alv->set_frontend_layout( is_layout = gs_layout ).
  CALL METHOD go_alv->refresh_table_display.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZFAT_YONETICI_S'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_layout .
  CLEAR: gs_layout.
  gs_layout-cwidth_opt = abap_true.
  gs_layout-zebra = abap_true.
  gs_layout-no_toolbar = abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save .
  IF gs_fatura IS NOT INITIAL.

    DATA: lv_top_tutar TYPE zfat_toptutar_de.
    CLEAR : lv_top_tutar.
    LOOP AT gt_fatura_kalem INTO gs_fatura_kalem.
      lv_top_tutar = gs_fatura_kalem-tutar + lv_top_tutar.
    ENDLOOP.
    gs_fatura-fatura_tutar = lv_top_tutar.

    CLEAR: gs_jpers.
    CLEAR: gt_jpers_tmp.
    LOOP AT gt_jpers INTO gs_jpers.
      IF gs_jpers-limit >= gs_fatura-fatura_tutar.
        APPEND gs_jpers TO gt_jpers_tmp.
      ENDIF.
    ENDLOOP.

    gs_fatura-onay_durum = c_statu-gv_onaybek.
    MODIFY zfat_fatura FROM gs_fatura.
    CLEAR gs_jpers.
    LOOP AT gt_jpers_tmp INTO gs_jpers.
      CLEAR gs_onay.
      gs_onay-fatura_no = gs_fatura-fatura_no.
      gs_onay-grup_no = gs_jpers-grup_no.
      gs_onay-sira_no = gs_jpers-sira_no.
      IF gs_jpers-sira_no EQ '100'.
        gs_onay-personel_no = gs_jpers-personel_no.
      ELSE.
        gs_onay-personel_no = gs_jpers-yonetici_no.
      ENDIF.
      gs_onay-onay_durum = c_statu-gv_onaybek.
      IF  gs_jpers-sira_no = '100'.
        gs_onay-onay_durum = c_statu-gv_onaybek.
      ELSE.
        gs_onay-onay_durum = c_statu-gv_onaysira.
      ENDIF.
      MODIFY zfat_onay FROM gs_onay.
    ENDLOOP.

  ELSE.
    MESSAGE 'Fatura bilgileri eksik.' TYPE 'W'.
  ENDIF.
  IF  gs_fatura_kalem IS NOT INITIAL.
    CLEAR: gs_save_fatura_kalem,
           gt_save_fatura_kalem.
    DATA: lv_sira TYPE i.
    CLEAR lv_sira.
    SELECT  * FROM zfat_fatkalem INTO CORRESPONDING FIELDS OF TABLE gt_save_fatura_kalem2 .
    IF gt_save_fatura_kalem2 IS NOT INITIAL.
      DESCRIBE TABLE gt_save_fatura_kalem2 LINES lv_sira.
      READ TABLE gt_save_fatura_kalem2  INTO gs_save_fatura_kalem INDEX lv_sira.
      lv_sira = gs_save_fatura_kalem-sira_no.
    ELSE.
      lv_sira = 0.
    ENDIF.
    LOOP AT gt_fatura_kalem INTO gs_fatura_kalem.
      CLEAR gs_save_fatura_kalem.
      lv_sira = lv_sira + 1.
      gs_save_fatura_kalem-fatura_no = gs_fatura-fatura_no.
      gs_save_fatura_kalem-sira_no = lv_sira.
      gs_save_fatura_kalem-urun = gs_fatura_kalem-urun.
      gs_save_fatura_kalem-miktar = gs_fatura_kalem-miktar.
      gs_save_fatura_kalem-birim_fiyat = gs_fatura_kalem-birim_fiyat.
      gs_save_fatura_kalem-vergi = gs_fatura_kalem-vergi.
      gs_save_fatura_kalem-tutar = gs_fatura_kalem-tutar.
      MODIFY zfat_fatkalem FROM gs_save_fatura_kalem.
    ENDLOOP.
    IF sy-subrc EQ 0.
      MESSAGE 'Fatura kaydedildi ve onaya gönderildi.' TYPE 'S'.
    ELSE.
      MESSAGE 'Fatura kaydedilemedi' TYPE 'W'.
    ENDIF.
  ELSE.
    MESSAGE 'Faturanın kalemleri eksik.' TYPE 'W'.
  ENDIF.

  """"""""""""""""""""""""""""""""""""""""
*  IF gs_fatura IS NOT INITIAL.
*
*    DATA: lv_top_tutar TYPE zfat_toptutar_de.
*    CLEAR : lv_top_tutar.
*    LOOP AT gt_fatura_kalem INTO gs_fatura_kalem.
*      lv_top_tutar = gs_fatura_kalem-tutar + lv_top_tutar.
*    ENDLOOP.
*    gs_fatura-fatura_tutar = lv_top_tutar.
*
*    MODIFY zfat_fatura FROM gs_fatura.
*    CLEAR gs_jpers_tmp.
*    LOOP AT gt_jpers_tmp INTO gs_jpers_tmp.
*      CLEAR gs_onay.
*      gs_onay-fatura_no = gs_fatura-fatura_no.
*      gs_onay-fatura_persno = gs_fatura-fatura_persno.
*      gs_onay-onay_durum = 'ONAY BEKLIYOR'.
*      gs_onay-yonetici_no = gs_jpers_tmp-yonetici_no.
*      MODIFY zfat_onay FROM gs_onay.
*    ENDLOOP.
*
*  ELSE.
*    MESSAGE 'Fatura bilgileri eksik.' TYPE 'W'.
*  ENDIF.
*  IF  gs_fatura_kalem IS NOT INITIAL.
*    CLEAR: gs_save_fatura_kalem,
*           gt_save_fatura_kalem.
*    LOOP AT gt_fatura_kalem INTO gs_fatura_kalem.
*      gs_save_fatura_kalem-fatura_no = gs_fatura-fatura_no.
*      gs_save_fatura_kalem-urun = gs_fatura_kalem-urun.
*      gs_save_fatura_kalem-miktar = gs_fatura_kalem-miktar.
*      gs_save_fatura_kalem-birim_fiyat = gs_fatura_kalem-birim_fiyat.
*      gs_save_fatura_kalem-vergi = gs_fatura_kalem-vergi.
*      gs_save_fatura_kalem-tutar = gs_fatura_kalem-tutar.
*      APPEND gs_save_fatura_kalem TO gt_save_fatura_kalem.
*    ENDLOOP.
*    MODIFY zfat_fatkalem FROM TABLE gt_save_fatura_kalem.
*    IF sy-subrc EQ 0.
*      MESSAGE 'Fatura kaydedildi ve onaya gönderildi.' TYPE 'S'.
*    ELSE.
*      MESSAGE 'Fatura kaydedilemedi' TYPE 'W'.
*    ENDIF.
*  ELSE.
*    MESSAGE 'Faturanın kalemleri eksik.' TYPE 'W'.
*  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  SET SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  GET_PERS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_pers_data .

  CLEAR: gt_jpers_tmp.
  SELECT *
  FROM zfat_pers       AS p
  JOIN zfat_onay   AS o
  ON p~personel_no EQ o~personel_no
  INTO CORRESPONDING FIELDS OF TABLE gt_jpers_tmp.

  CLEAR: gt_jpers_tmp.
  SELECT *
  FROM zfat_pers       AS p
  JOIN zfat_yonetici   AS y
  ON p~personel_no EQ y~yonetici_no
  INTO CORRESPONDING FIELDS OF TABLE gt_jpers.
*  WHERE y~personel_no = '1000000002'.


  SELECT *
  FROM zfat_pers       AS p
  LEFT JOIN zfat_yonetici   AS y
  ON p~personel_no EQ y~personel_no
  INTO CORRESPONDING FIELDS OF TABLE gt_jpers2
WHERE p~personel_no = gs_fatura-personel_no.

  DATA: grupno TYPE zfat_grupno_de,
        sirano TYPE zfat_sirano_de.
  DATA: lv_grupno TYPE zfat_grupno_de.
  CLEAR: grupno,
        sirano.

  CLEAR: gs_jpers,
         gt_jpers_tmp.
  LOOP AT gt_jpers INTO gs_jpers WHERE personel_no = gs_fatura-personel_no.
    APPEND gs_jpers TO gt_jpers_tmp.
  ENDLOOP.


  DATA : lv_count TYPE i.

  lv_count = lines( gt_jpers_tmp ).
  IF lv_count = 1.
    READ TABLE gt_jpers_tmp ASSIGNING <gfs_jpers_tmp> INDEX 1.
    <gfs_jpers_tmp>-grup_no = '10'.
    <gfs_jpers_tmp>-sira_no = '100'.
  ENDIF.

  CLEAR: gs_jpers_tmp,
         gs_jpers.
  LOOP AT gt_jpers_tmp INTO gs_jpers_tmp.
    LOOP AT gt_jpers INTO gs_jpers.
      IF gs_jpers-personel_no = gs_jpers_tmp-yonetici_no.
        READ TABLE gt_jpers_tmp ASSIGNING <gfs_jpers_tmp> WITH KEY yonetici_no = gs_jpers_tmp-yonetici_no.
        grupno = grupno + 10.
        <gfs_jpers_tmp>-grup_no = grupno.
        gs_jpers-grup_no = gs_jpers-grup_no + grupno.
        gs_jpers_tmp = gs_jpers.
        APPEND gs_jpers TO gt_jpers_tmp.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  CLEAR: gs_jpers.
  IF gt_jpers_tmp IS INITIAL.
    READ TABLE gt_jpers2 INTO gs_jpers INDEX 1.
    gs_jpers-personel_no = gs_fatura-personel_no.
    gs_jpers-grup_no = '10'.
    gs_jpers-sira_no = '100'.
    APPEND gs_jpers TO gt_jpers_tmp.
  ENDIF.

  SORT gt_jpers_tmp BY grup_no ASCENDING .
  CLEAR :grupno,
        gs_jpers,
        gt_jpers,
        gs_jpers_tmp.
  DATA: gruptemp TYPE zfat_grupno_de.
  gruptemp = '10'.
  sirano = '100'.
  LOOP AT gt_jpers_tmp INTO gs_jpers_tmp.

    IF gs_jpers_tmp-grup_no EQ gruptemp.
      sirano = sirano + '100'.
      READ TABLE gt_jpers_tmp ASSIGNING <gfs_jpers_tmp> WITH KEY yonetici_no = gs_jpers_tmp-yonetici_no.
      <gfs_jpers_tmp>-sira_no = sirano.

    ELSEIF gs_jpers_tmp-grup_no < gruptemp.
      READ TABLE gt_jpers_tmp ASSIGNING <gfs_jpers_tmp> WITH KEY yonetici_no = gs_jpers_tmp-yonetici_no.
      <gfs_jpers_tmp>-sira_no = sirano.

    ELSEIF gs_jpers_tmp-grup_no > gruptemp.
      sirano = '200'.
      READ TABLE gt_jpers_tmp ASSIGNING <gfs_jpers_tmp> WITH KEY yonetici_no = gs_jpers_tmp-yonetici_no.
      <gfs_jpers_tmp>-sira_no = sirano.
    ENDIF.
    gruptemp = gs_jpers_tmp-grup_no.
  ENDLOOP.

  CLEAR :grupno,
  gs_jpers,
  gt_jpers,
  gs_jpers2,
  gs_jpers_tmp.
  LOOP AT gt_jpers2 INTO gs_jpers2.
    LOOP AT gt_jpers_tmp INTO gs_jpers_tmp.
      IF gs_jpers_tmp-yonetici_no EQ gs_jpers2-yonetici_no.
        gs_jpers2-grup_no = gs_jpers_tmp-grup_no.
        gs_jpers2-sira_no = '100'.
        APPEND gs_jpers2 TO gt_jpers.
      ELSE.
        APPEND gs_jpers_tmp TO gt_jpers.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
  SORT gt_jpers BY grup_no ASCENDING sira_no ASCENDING .
  DELETE ADJACENT DUPLICATES FROM gt_jpers COMPARING personel_ad.
ENDFORM.
