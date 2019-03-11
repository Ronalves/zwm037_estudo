
*&---------------------------------------------------------------------*
*& Include ZMMI_CONF_TOP                            - PoolMóds.        ZMMI_CRIA_CONFE
*&---------------------------------------------------------------------*
PROGRAM zmmi_cria_confe.

**********
***Tipos**
**********
TYPES:BEGIN OF ty_cursor_descr,
        field(50)    TYPE c,
        tc_area(100) TYPE c,
        tcline       TYPE i,
        value        TYPE string,
        off          TYPE i,
        repid        TYPE sy-repid,
        dynnr        TYPE sy-dynnr,
      END OF ty_cursor_descr.

TYPES:BEGIN OF yg_matnr_pisto,
        matnr TYPE char18,
      END OF yg_matnr_pisto.

TYPES:yg_etiqueta(26)    TYPE c,
      yg_ztwm_receb_conf TYPE STANDARD TABLE OF ztwm_receb_conf,
      yg_sumarizado      TYPE STANDARD TABLE OF ztwm_sumarizado.

************
***Tabelas**
************
DATA:tg_ztwm_receb_conf  TYPE yg_ztwm_receb_conf,
     tg_ztwm_receb_conf3 TYPE yg_ztwm_receb_conf,
     tg_ztwm_receb_conf2 TYPE yg_ztwm_receb_conf,
     tg_sumarizado     	 TYPE yg_sumarizado,
     tg_quant_novo_doc   TYPE yg_sumarizado,
     tg_docs_gerados     TYPE TABLE OF ztwm_receb_matdo.

*************************
***Objetos de tela 0002**
*************************
DATA:message_f  TYPE string,
     message_f2 TYPE string,
     message_g  TYPE string.

*************************
***Objetos de tela 0004**
*************************
DATA:po_field       TYPE ztwm_receb_conf-ebeln,
     field_etiqueta TYPE yg_etiqueta,
     matnr_n        TYPE string,
     descricao      TYPE string,
     qtd_l(16)      TYPE c,
     block_qtd(1)   TYPE c,
     qtdconf        TYPE char16,
     qtdconf_2      TYPE char16,
     qtd_entrada    TYPE char16,
     item_ped(5)    TYPE c.

*************************
***Objetos de tela 0005**
*************************
DATA:message_h TYPE string,
     message_i TYPE string.

*************************
***Objetos de tela 0006**
*************************
DATA:message_j TYPE string,
     message_l TYPE string,
     message_m TYPE string,
     message_n TYPE string.

*************************
***Objetos de tela 0007**
*************************
DATA:message_j1 TYPE string,
     message_j2 TYPE string,
     message_j3 TYPE string,
     message_j4 TYPE string.

*************************
***Objetos de tela 0008**
*************************
DATA:doc1 TYPE string,
     doc2 TYPE string,
     doc3 TYPE string,
     doc4 TYPE string.

************
***Objetos**
************
DATA: og_principal TYPE REF TO zcl_cria_confe.

*************
**Variáveis**
*************
DATA: field_etiqueta2   TYPE yg_etiqueta,
      vg_material       TYPE matnr,
      vg_material_aux   TYPE matnr,
      vg_ebeln          TYPE ekko-ebeln,
      vg_ebeln_aux      TYPE ekko-ebeln,
      vg_quantidade     TYPE zdocqtd,
      vg_quantidade_aux TYPE zdocqtd,
      vg_ebelp          TYPE ebelp,
      vg_quant_tot      TYPE menge_d,
      p_msgid           TYPE t100-arbgb,
      p_msgno           TYPE t100-msgnr,
      p_msgv1           TYPE sprot_u-var1,
      p_msgv2           TYPE sprot_u-var2,
      p_msgv3           TYPE sprot_u-var3,
      p_msgv4           TYPE sprot_u-var4,
      p_tela            TYPE sy-dynnr,
      vg_limite_error   TYPE abap_bool,
      vg_first          TYPE abap_bool,
      vg_erro           TYPE abap_bool,
      vg_material_found TYPE abap_bool.
