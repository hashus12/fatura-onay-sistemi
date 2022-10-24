*&---------------------------------------------------------------------*
*&  Include           ZFAT_FATISLEM_PBO
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

  CLEAR: gt_onay,
         gt_onay2.
  PERFORM get_fatura_data_alv1.
  PERFORM get_fatura_data_alv2.
  PERFORM get_fatura_data_alv3.
  PERFORM display_alv.
  PERFORM get_pdf_data. "Get PDF
  PERFORM display_pdf.

ENDMODULE.
