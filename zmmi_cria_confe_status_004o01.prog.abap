*----------------------------------------------------------------------*
***INCLUDE ZMMI_CRIA_CONFE_STATUS_0004O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0004 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0004 OUTPUT.
  DATA:vg_material2     TYPE matnr.
  SET PF-STATUS 'MENU1'.
* SET TITLEBAR 'xxx'.

  CALL METHOD og_principal->check_ordem_recebida(
    EXPORTING
      vg_out             = abap_true
      i_ordem            = vg_ebeln  " Nº do documento de compras
    IMPORTING
      tl_ztwm_receb_conf = tg_ztwm_receb_conf2 " Recebe Conf.
                           ).
  IF matnr_n IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = matnr_n
      IMPORTING
        output = vg_material2.

    CALL METHOD og_principal->preenche_tela
      EXPORTING
        vg_material        = vg_material2
        vg_ebeln           = vg_ebeln
        tg_ztwm_receb_conf = tg_ztwm_receb_conf2
        vg_no              = abap_true
      IMPORTING
        vg_quant_tot       = vg_quant_tot
      CHANGING
         qtdconf_2          = qtdconf_2
        qtd_entrada        = qtd_entrada
        item_ped           = item_ped
        field_etiqueta     = field_etiqueta
        matnr_n            = matnr_n
        descricao          = descricao
        qtd_l              = qtd_l
        qtdconf            = qtdconf
        po_field           = po_field
        vg_ebelp           = vg_ebelp.

    CONDENSE qtdconf.
  ENDIF.

ENDMODULE.
