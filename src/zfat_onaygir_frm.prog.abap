*&---------------------------------------------------------------------*
*&  Include           ZFAT_ONAYGIR_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
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

    PERFORM set_dropdown.

    CALL METHOD go_alv->set_table_for_first_display
      CHANGING
        it_outtab                     = gt_onay
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
      i_structure_name       = 'ZFAT_ONAYGIR_S'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'ONAY_DURUM'.
        <gfs_fcat>-edit = abap_true.
        <gfs_fcat>-drdn_hndl = 1.
      WHEN 'ICON'.
        <gfs_fcat>-scrtext_s = 'Onay'.
        <gfs_fcat>-scrtext_m = 'Onay'.
        <gfs_fcat>-scrtext_l = 'Onay'.
      WHEN 'ACIKLAMA'.
        <gfs_fcat>-edit = abap_true.
    ENDCASE.
  ENDLOOP.

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

  IF  gt_onay IS NOT INITIAL.
    MOVE-CORRESPONDING gt_onay TO gt_onay_kayit.
    MODIFY zfat_onay FROM TABLE gt_onay_kayit.
    IF sy-subrc EQ 0.
      MESSAGE 'Kaydedildi.' TYPE 'S'.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check .
  SELECT SINGLE *
  FROM zfat_pers
  INTO CORRESPONDING FIELDS OF gs_kull_pers
  WHERE kullanici_ad = p_kullad
  AND parola = p_parola.
  IF sy-subrc EQ 0.
  ELSE.
    MESSAGE 'Geçersiz kullanıcı adı veya parola.' TYPE 'I' DISPLAY LIKE 'W'.
    p_kullad = ' '.
    p_parola = ' '.
  ENDIF.
*  SELECT SINGLE *
*    FROM zfat_kullgiris
*    INTO CORRESPONDING FIELDS OF gs_kull_pers
*    WHERE kullanici_ad = p_kullad
*    AND parola = p_parola.
*  IF sy-subrc EQ 0.
*  ELSE.
*    MESSAGE 'Geçersiz kullanıcı adı veya parola.' TYPE 'I' DISPLAY LIKE 'W'.
*    p_kullad = ' '.
*    p_parola = ' '.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FATURA_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fatura_data.
  CLEAR: gt_onay_durum,
         gs_onay_durum.
  IF p_onaycb EQ abap_true.
    gs_onay_durum-onay_durum = 'ONAYLANDI'.
    APPEND gs_onay_durum TO gt_onay_durum.
  ENDIF.
  IF p_onbecb EQ abap_true.
    gs_onay_durum-onay_durum = 'ONAY BEKLIYOR'.
    APPEND gs_onay_durum TO gt_onay_durum.
  ENDIF.
  IF p_onrecb EQ abap_true.
    gs_onay_durum-onay_durum = 'RED EDILDI'.
    APPEND gs_onay_durum TO gt_onay_durum.
  ENDIF.

  CLEAR: gt_jpers_tmp.
  SELECT *
  FROM zfat_pers       AS p
  JOIN zfat_yonetici   AS y
  ON p~personel_no EQ y~personel_no
  JOIN zfat_yontur     AS yt
  ON y~yonetici_no EQ yt~yonetici_no
  INTO CORRESPONDING FIELDS OF TABLE gt_jpers.

  LOOP AT gt_jpers INTO gs_jpers WHERE yonetici_no = gs_kull_pers-yonetici_no.
    APPEND gs_jpers TO gt_jpers_tmp.
  ENDLOOP.

  LOOP AT gt_jpers_tmp INTO gs_jpers_tmp.
    LOOP AT gt_jpers INTO gs_jpers.
      IF gs_jpers_tmp-personel_ad = gs_jpers-yonetici_adi.
        APPEND gs_jpers TO gt_jpers_tmp.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  SORT gt_jpers_tmp BY personel_ad ASCENDING.

  DELETE ADJACENT DUPLICATES FROM gt_jpers_tmp  COMPARING personel_ad.
  LOOP AT gt_onay_durum INTO gs_onay_durum.
    LOOP AT gt_jpers_tmp INTO gs_jpers_tmp.
      SELECT *
      FROM zfat_fatura  AS f
      JOIN zfat_satici AS s
      ON s~satici_no EQ f~fatura_saticino
      JOIN zfat_pers   AS p
      ON f~fatura_persno EQ p~personel_no
      JOIN zfat_onay AS o
      ON o~fatura_no EQ f~fatura_no
      APPENDING CORRESPONDING FIELDS OF TABLE gt_onay
      WHERE fatura_persno = gs_jpers_tmp-personel_no
       AND f~fatura_no IN s_fatno
       AND fatura_saticino IN s_satno
       AND fatura_tarih  IN s_tarih
       AND o~onay_durum  EQ gs_onay_durum-onay_durum
       AND o~yonetici_no EQ gs_kull_pers-yonetici_no.
    ENDLOOP.
  ENDLOOP.

  "limit e göre
  CLEAR: gs_jpers_tmp.
  READ TABLE gt_jpers_tmp INTO gs_jpers_tmp WITH KEY yonetici_no = gs_kull_pers-yonetici_no.
  DELETE gt_onay WHERE fatura_tutar > gs_jpers_tmp-limit.

  "onaya göre icon
  LOOP AT gt_onay ASSIGNING <gfs_onay>.
    CASE <gfs_onay>-onay_durum.
      WHEN 'ONAYLANDI'.
        <gfs_onay>-icon = '@01@'.
      WHEN 'ONAY BEKLIYOR'.
        <gfs_onay>-icon = '@5D@'.
      WHEN 'RED EDILDI'.
        <gfs_onay>-icon = '@02@'.
    ENDCASE.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DROPDOWN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_dropdown .
  DATA: lt_dropdown TYPE lvc_t_drop,
        ls_dropdown TYPE lvc_s_drop.

  CLEAR: ls_dropdown.
  ls_dropdown-handle = 1.
  ls_dropdown-value = 'ONAYLANDI'.
  APPEND ls_dropdown TO lt_dropdown.

  CLEAR: ls_dropdown.
  ls_dropdown-handle = 1.
  ls_dropdown-value = 'ONAY BEKLIYOR'.
  APPEND ls_dropdown TO lt_dropdown.

  CLEAR: ls_dropdown.
  ls_dropdown-handle = 1.
  ls_dropdown-value = 'RED EDILDI'.
  APPEND ls_dropdown TO lt_dropdown.

  go_alv->set_drop_down_table(
    EXPORTING
      it_drop_down = lt_dropdown ).
ENDFORM.
