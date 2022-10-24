*&---------------------------------------------------------------------*
*&  Include           ZFAT_FATISLEM_FRM
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

  IF go_cust IS INITIAL.
    CREATE OBJECT go_cust
      EXPORTING
        container_name = 'CC_ALV'.

    CREATE OBJECT go_splitter
      EXPORTING
        parent            = go_cust
        rows              = 1
        columns           = 2
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = go_gui1.

    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 1
        column    = 2
      RECEIVING
        container = go_gui2.

    CREATE OBJECT go_splitter2
      EXPORTING
        parent            = go_gui1
        rows              = 2
        columns           = 1
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL METHOD go_splitter2->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = go_gui1.

    CALL METHOD go_splitter2->get_container
      EXPORTING
        row       = 2
        column    = 1
      RECEIVING
        container = go_gui3.

    CREATE OBJECT go_splitter3
      EXPORTING
        parent            = go_gui3
        rows              = 1
        columns           = 2
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL METHOD go_splitter3->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = go_gui4.

    CALL METHOD go_splitter3->get_container
      EXPORTING
        row       = 1
        column    = 2
      RECEIVING
        container = go_gui5.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_gui1.

    CREATE OBJECT go_alv2
      EXPORTING
        i_parent = go_gui4.

    CREATE OBJECT go_alv3
      EXPORTING
        i_parent = go_gui5.

    CREATE OBJECT go_event_receiver.
    SET HANDLER go_event_receiver->handle_hotspot_click FOR go_alv.
    SET HANDLER go_event_receiver->handle_toolbar FOR go_alv.
    SET HANDLER go_event_receiver->handle_user_command FOR go_alv.


    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = gt_onay
        it_fieldcatalog               = gt_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

    CALL METHOD go_alv2->set_table_for_first_display
      EXPORTING
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = gt_onay2
        it_fieldcatalog               = gt_fcat2
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

    CALL METHOD go_alv3->set_table_for_first_display
      EXPORTING
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = gt_fatura_kalem
        it_fieldcatalog               = gt_fcat3
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

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

    CALL METHOD go_alv2->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL METHOD go_alv3->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSE.
    CALL METHOD go_alv->set_frontend_layout( is_layout = gs_layout ).
    CALL METHOD go_alv2->set_frontend_layout( is_layout = gs_layout ).
    CALL METHOD go_alv3->set_frontend_layout( is_layout = gs_layout ).
    CALL METHOD go_alv->refresh_table_display.
    CALL METHOD go_alv2->refresh_table_display.
    CALL METHOD go_alv3->refresh_table_display.
  ENDIF.

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
      i_structure_name       = 'ZFAT_ONAYLAMA_S'
    CHANGING
      ct_fieldcat            = gt_fcat2
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


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

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZFAT_FATURAKALEM_S'
    CHANGING
      ct_fieldcat            = gt_fcat3
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_fcat2 ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'PERSONEL_NO'.
        <gfs_fcat>-no_out = abap_true.
    ENDCASE.
  ENDLOOP.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'ICON'.
        <gfs_fcat>-scrtext_s = 'Onay'.
        <gfs_fcat>-scrtext_m = 'Onay'.
        <gfs_fcat>-scrtext_l = 'Onay'.
      WHEN 'FATURA_NO'.
        <gfs_fcat>-hotspot = abap_true.
        <gfs_fcat>-col_pos = 1.
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
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FATURA_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fatura_data_alv1.
  DATA : lv_personel_no TYPE zfat_persno_de.

  CLEAR: gt_onay_durum,
         gs_onay_durum.

  SELECT *
  FROM zfat_fatura  AS f
  JOIN zfat_satici AS s
  ON s~satici_no EQ f~satici_no
  JOIN zfat_onay AS o
  ON o~fatura_no EQ f~fatura_no
  JOIN zfat_pers   AS p
  ON p~personel_no EQ f~personel_no
  JOIN dd07t AS d
  ON d~domname EQ 'ZFAT_ONAYDURUM_DO'
  AND o~onay_durum EQ d~domvalue_l
  APPENDING CORRESPONDING FIELDS OF TABLE gt_onay
  WHERE o~personel_no EQ gv_kullanicipersno.

  SORT gt_onay BY fatura_no ASCENDING onay_durum DESCENDING aciklama DESCENDING.

  DELETE ADJACENT DUPLICATES FROM gt_onay  COMPARING fatura_no.

  """"""JOINSIZ ORNEK"""""""
*  SELECT * FROM  zfat_fatura
*  INTO CORRESPONDING FIELDS OF TABLE gt_onay
*  WHERE personel_no EQ gv_kullanicipersno.
*
*  SELECT * FROM  zfat_satici
*  INTO CORRESPONDING FIELDS OF TABLE gt_satici
*  FOR ALL ENTRIES IN gt_onay
*  WHERE satici_no EQ gt_onay-satici_no.
*
*  SELECT * FROM  zfat_pers
*  INTO CORRESPONDING FIELDS OF TABLE gt_pers
*  FOR ALL ENTRIES IN gt_onay
*  WHERE personel_no EQ gt_onay-personel_no.
*
*  SELECT * FROM  zfat_onay
*  INTO CORRESPONDING FIELDS OF TABLE gt_onayalv
*  FOR ALL ENTRIES IN gt_onay
*  WHERE fatura_no EQ gt_onay-fatura_no.
*
*  SELECT ddtext domvalue_l FROM  dd07t
*  INTO CORRESPONDING FIELDS OF TABLE gt_dd07t
*  WHERE domname EQ 'ZFAT_ONAYDURUM_DO'.
*
*  LOOP AT gt_onay ASSIGNING <gfs_onay>.
*    READ TABLE gt_satici INTO gs_satici WITH KEY satici_no = <gfs_onay>-satici_no.
*    <gfs_onay>-satici_ad = gs_satici-satici_ad.
*    READ TABLE gt_pers INTO gs_pers WITH KEY personel_no = <gfs_onay>-personel_no.
*    <gfs_onay>-personel_ad = gs_pers-personel_ad.
*    READ TABLE gt_dd07t INTO gs_dd07t WITH KEY domvalue_l = <gfs_onay>-onay_durum.
*    <gfs_onay>-ddtext = gs_dd07t-ddtext.
*    READ TABLE gt_onayalv INTO gs_onayalv WITH KEY personel_no = <gfs_onay>-personel_no  fatura_no = <gfs_onay>-fatura_no.
*    <gfs_onay>-aciklama = gs_onayalv-aciklama.
*  ENDLOOP.

  "onaya göre icon
  LOOP AT gt_onay ASSIGNING <gfs_onay>.
    CASE <gfs_onay>-onay_durum.
      WHEN c_statu-gv_onaylandi.
        <gfs_onay>-icon = '@01@'.
      WHEN c_statu-gv_onaybek.
        <gfs_onay>-icon = '@5D@'.
      WHEN c_statu-gv_onayred.
        <gfs_onay>-icon = '@02@'.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FATURA_DATA_ALV2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fatura_data_alv2 .

  CLEAR: gt_jpers_tmp,
         gt_onay2.

  SELECT *
  FROM zfat_onay   AS o
  JOIN zfat_pers   AS p
  ON p~personel_no EQ o~personel_no
  JOIN dd07t AS d
  ON d~domname EQ 'ZFAT_ONAYDURUM_DO'
  AND o~onay_durum EQ d~domvalue_l
  INTO CORRESPONDING FIELDS OF TABLE gt_onay2
   WHERE fatura_no EQ gs_onay-fatura_no.

  SORT gt_onay2 ASCENDING BY grup_no ASCENDING sira_no.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FATURA_DATA_ALV3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fatura_data_alv3 .

  CLEAR: gt_fatura_kalem,
         gs_fatura_kalem.
  SELECT *
  FROM zfat_fatkalem
  INTO CORRESPONDING FIELDS OF TABLE gt_fatura_kalem
  WHERE fatura_no EQ gs_onay-fatura_no.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_PDF_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_pdf_data .
  IF gs_onay IS NOT INITIAL.
    CLEAR: gt_fatura_kalem.
    SELECT *
    FROM zfat_fatkalem
    INTO TABLE gt_fatura_kalem
    WHERE fatura_no = gs_onay-fatura_no.
    "Get smartform function module name
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZFAT_SF_0001'
      IMPORTING
        fm_name            = gv_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    "Pass Printer related Parameters to Smartform
    wa_control_par-no_dialog = 'X'.     " It supresses the Printer dialog.
    wa_control_par-getotf    = 'X'.     " Get OTF data
*    wa_control_par-preview    = 'X'.     " Get OTF data
    wa_output_options-tddest = 'LOCL'. " Set printer
    "Call Smartform
    CALL FUNCTION gv_fm_name
      EXPORTING
        control_parameters = wa_control_par
        output_options     = wa_output_options
        it_fatura_kalem    = gt_fatura_kalem
        is_onay            = gs_onay
      IMPORTING
        job_output_info    = wa_job_output_info
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
    ELSE .
      it_otf_data = wa_job_output_info-otfdata.
      "Convert OTF data to PDF
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
        IMPORTING
          bin_filesize          = gv_bin_filesize
        TABLES
          otf                   = it_otf_data
          lines                 = it_pdf
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          err_bad_otf           = 4
          OTHERS                = 5.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_PDF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_pdf .
  LOOP AT it_pdf INTO wa_pdf.
    ASSIGN wa_pdf TO <fs_x> CASTING.
    CONCATENATE gv_content <fs_x> INTO gv_content IN BYTE MODE.
  ENDLOOP.

  "create PDF Viewer object
  CREATE OBJECT html_viewer
    EXPORTING
      parent = go_gui2.
  IF sy-subrc <> 0.
    "NO PDF viewwer
  ENDIF.
  "Convert xstring to binary table to pass to the LOAD_DATA method
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = gv_content
    TABLES
      binary_tab = it_data.
  " Load the HTML
  CALL METHOD html_viewer->load_data(
    EXPORTING
      type                 = 'application'
      subtype              = 'pdf'
    IMPORTING
      assigned_url         = gv_url
    CHANGING
      data_table           = it_data
    EXCEPTIONS
      dp_invalid_parameter = 1
      dp_error_general     = 2
      cntl_error           = 3
      OTHERS               = 4 ).
  IF sy-subrc <> 0.
    WRITE:/ 'ERROR: CONTROL->LOAD_DATA'.
    EXIT.
  ENDIF.
  "Show it
  CALL METHOD html_viewer->show_url( url = gv_url in_place = 'X').
  IF sy-subrc <> 0.
    WRITE:/ 'ERROR: CONTROL->SHOW_DATA'.
    EXIT.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ONAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM onay .
  SELECT SINGLE * FROM zfat_fatura INTO CORRESPONDING FIELDS OF gs_fatura WHERE fatura_no = gs_onay-fatura_no.
  gs_fatura-onay_durum = c_statu-gv_onaylandi.
  MODIFY zfat_fatura FROM gs_fatura.
  CLEAR: gs_save_onay,
  gt_save_onay.
  SELECT * FROM zfat_onay INTO CORRESPONDING FIELDS OF TABLE gt_save_onay WHERE fatura_no = gs_onay-fatura_no.
  LOOP AT gt_save_onay INTO gs_save_onay.
    IF gs_save_onay-personel_no EQ gv_kullanicipersno.
      IF gs_save_onay-onay_durum EQ c_statu-gv_onaybek.
        CLEAR :gv_tempsira.
        gs_save_onay-onay_durum = c_statu-gv_onaylandi.
        gv_tempgrup = gs_save_onay-grup_no.
        gv_tempsira = gs_save_onay-sira_no + '100'.
        MODIFY zfat_onay FROM gs_save_onay.
        IF sy-subrc EQ 0.
        ELSE.
          MESSAGE 'sorun var' TYPE 'I'.
        ENDIF.
      ENDIF.
    ENDIF.
    IF gv_tempgrup EQ gs_save_onay-grup_no AND gv_tempsira EQ gs_save_onay-sira_no.
      gs_save_onay-onay_durum = c_statu-gv_onaybek.
      MODIFY zfat_onay FROM gs_save_onay.
      IF sy-subrc EQ 0.
        MESSAGE 'Onaylandı.' TYPE 'S'.
      ENDIF.
    ENDIF.
  ENDLOOP.
*        MODIFY zfat_onay FROM TABLE gt_save_onay.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REDDET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM reddet .
  SELECT SINGLE * FROM zfat_fatura INTO CORRESPONDING FIELDS OF gs_fatura WHERE fatura_no = gs_onay-fatura_no.
  gs_fatura-onay_durum = c_statu-gv_onayred.
  MODIFY zfat_fatura FROM gs_fatura.

  DATA: text    TYPE catsxt_longtext_itab,
        ls_line LIKE LINE OF text.

  DATA: lv_string TYPE string.

  CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
    EXPORTING
      im_title        = 'Reddetme Sebebini Giriniz.'
*     IM_DISPLAY_MODE = 'Read'
      im_start_column = 0
      im_start_row    = 1
    CHANGING
      ch_text         = text. " it will fill the long text here.

  LOOP AT text INTO ls_line.
    CONCATENATE lv_string ls_line INTO lv_string SEPARATED BY space.
  ENDLOOP.

  WRITE: lv_string.

  CLEAR: gs_save_onay,
  gt_save_onay.
  SELECT * FROM zfat_onay INTO CORRESPONDING FIELDS OF TABLE gt_save_onay.
  LOOP AT gt_save_onay INTO gs_save_onay.
    IF gs_save_onay-personel_no EQ gv_kullanicipersno.
      IF gs_save_onay-onay_durum EQ c_statu-gv_onaybek.
        CLEAR :gv_tempsira.
        gs_save_onay-onay_durum = c_statu-gv_onayred.
        gs_save_onay-aciklama = lv_string.
        gv_tempgrup = gs_save_onay-grup_no.
        gv_tempsira = gs_save_onay-sira_no + '100'.
        MODIFY zfat_onay FROM gs_save_onay.
        IF sy-subrc EQ 0.
          MESSAGE 'Reddedildi.' TYPE 'S'.
        ENDIF.
      ENDIF.
    ENDIF.
    IF gv_tempgrup EQ gs_save_onay-grup_no AND gv_tempsira EQ gs_save_onay-sira_no.
      gs_save_onay-onay_durum = c_statu-gv_onayredonceki.
      MODIFY zfat_onay FROM gs_save_onay.
    ENDIF.
    IF gs_save_onay-onay_durum EQ c_statu-gv_onaysira.
      CLEAR :gv_tempsira.
      gs_save_onay-onay_durum = c_statu-gv_onayredonceki.

      MODIFY zfat_onay FROM gs_save_onay.
    ENDIF.
  ENDLOOP.
ENDFORM.
