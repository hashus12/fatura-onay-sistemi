*&---------------------------------------------------------------------*
*& Report  ZFAT_ONAYGIR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zfat_onaygir.

INCLUDE zfat_onaygir_top.
INCLUDE zfat_onaygir_cls.
INCLUDE zfat_onaygir_pbo.
INCLUDE zfat_onaygir_pai.
INCLUDE zfat_onaygir_frm.



AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'P_KULLAD'.
        screen-required = 1.
        MODIFY SCREEN.
      WHEN 'P_PAROLA'.
        screen-invisible = 1.
        screen-required = 1.
        MODIFY SCREEN.
      WHEN 'P_ONAYCB'.
        screen-input = 0.
        p_onaycb = abap_true.
        MODIFY SCREEN.
      WHEN 'P_ONBECB'.
        screen-input = 0.
        p_onbecb = abap_true.
        MODIFY SCREEN.
      WHEN 'P_ONRECB'.
        screen-input = 0.
        p_onrecb = abap_true.
        MODIFY SCREEN.
    ENDCASE.
    IF p_tumucb EQ abap_true.
    ELSE.
      IF screen-group1 EQ 'GR1'.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  IF gs_kull_pers IS NOT INITIAL.
    IF SCREEN-group1 EQ 'GR2'.
      SCREEN-active = 0.
      MODIFY SCREEN.
    ENDIF.
    IF SCREEN-group1 EQ 'GR1'.
      SCREEN-active = 1.
      MODIFY SCREEN.
    ENDIF.
  ELSE.
    IF SCREEN-group1 EQ 'GR2'.
      SCREEN-active = 1.
      MODIFY SCREEN.
    ENDIF.
    IF SCREEN-group1 EQ 'GR1'.
      SCREEN-active = 0.
      MODIFY SCREEN.
    ENDIF.
    IF SCREEN-group1 EQ 'GR3'.
      SCREEN-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDIF.
  ENDLOOP.


AT SELECTION-SCREEN.
  PERFORM check.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

AT SELECTION-SCREEN ON EXIT-COMMAND.

START-OF-SELECTION.

  PERFORM set_fcat.
  PERFORM set_layout.

  CALL SCREEN 0100.
