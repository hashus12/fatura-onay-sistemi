*&---------------------------------------------------------------------*
*&  Include           ZFAT_FATISLEM_CLS
*&---------------------------------------------------------------------*

CLASS cl_event_receiver DEFINITION.

  PUBLIC SECTION.
    METHODS handle_hotspot_click             "HOTSPOT_CLICK
        FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
        e_row_id
        e_column_id.

    METHODS handle_toolbar                   "TOOLBAR
        FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
        e_object
        e_interactive.

    METHODS handle_user_command              "USER_COMMAND
        FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        e_ucomm.
ENDCLASS.

CLASS cl_event_receiver IMPLEMENTATION.

  METHOD handle_hotspot_click.
    ok_code = '&HOTSPOT'.
    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code = ok_code.
    CLEAR gs_onay.
    READ TABLE gt_onay INTO gs_onay INDEX e_row_id-index.
    IF sy-subrc EQ 0.
    ENDIF.
  ENDMETHOD.        "handle_hotspot_click

  METHOD handle_toolbar.
    DATA: ls_toolbar TYPE stb_button.

    CLEAR: ls_toolbar.
    ls_toolbar-function = '&ONAY'.
    ls_toolbar-text = 'Onayla'.
    ls_toolbar-icon = '@2K@'.
    ls_toolbar-quickinfo = 'Onayla'.
    ls_toolbar-disabled = abap_false.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR: ls_toolbar.
    ls_toolbar-function = '&REDDET'.
    ls_toolbar-text = 'Reddet'.
    ls_toolbar-icon = '@2O@'.
    ls_toolbar-quickinfo = 'Reddet'.
    ls_toolbar-disabled = abap_false.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.        "handle_toolbar

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN '&ONAY'.
        PERFORM onay.
      WHEN '&REDDET'.
        PERFORM reddet.
    ENDCASE.
    CALL METHOD go_alv2->refresh_table_display.
  ENDMETHOD.        "handle_user_command
ENDCLASS.
