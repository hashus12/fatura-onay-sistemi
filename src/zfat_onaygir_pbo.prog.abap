*&---------------------------------------------------------------------*
*&  Include           ZFAT_ONAYGIR_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  TYPES:BEGIN OF ty_s_exclude,
          ucomm TYPE sy-ucomm,
        END OF ty_s_exclude.

  DATA: lt_exclude TYPE TABLE OF ty_s_exclude.
  DATA: ls_exclude TYPE ty_s_exclude.

  SET TITLEBAR '0100'.

  SET PF-STATUS '0100' EXCLUDING lt_exclude.
  CLEAR ok_code.

  CLEAR gt_onay.
  PERFORM get_fatura_data.
  PERFORM display_alv.

ENDMODULE.
