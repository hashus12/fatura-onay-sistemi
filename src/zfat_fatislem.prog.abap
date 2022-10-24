*&---------------------------------------------------------------------*
*& Report  ZFAT_ONAYGIR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zfat_fatislem.

INCLUDE zfat_fatislem_top.
INCLUDE zfat_fatislem_cls.
INCLUDE zfat_fatislem_pbo.
INCLUDE zfat_fatislem_pai.
INCLUDE zfat_fatislem_frm.

INITIALIZATION.

  gv_kullanicipersno = '1000000002'.

START-OF-SELECTION.

  PERFORM set_fcat.
  PERFORM set_layout.

  CALL SCREEN 0100.
