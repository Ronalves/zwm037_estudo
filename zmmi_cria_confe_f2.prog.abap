*&---------------------------------------------------------------------*
*& Include          ZMMI_CRIA_CONFE_F
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F_EXIBIR_MSG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_exibir_msg .

  DATA: lv_answer TYPE c.
  p_tela = '0999'.
  CALL FUNCTION 'CALL_MESSAGE_SCREEN'
    EXPORTING
      i_msgid          = p_msgid
      i_lang           = sy-langu
      i_msgno          = p_msgno
      i_msgv1          = p_msgv1
      i_msgv2          = p_msgv2
      i_msgv3          = p_msgv3
      i_msgv4          = p_msgv4
*     I_SEPERATE       = ' '
*     I_CONDENSE       = ' '
      i_message_screen = p_tela
*     I_LINE_SIZE      = 0
*     I_LINES          = 0
      i_non_lmob_envt  = 'X'
*     I_MODPL          =
    IMPORTING
      o_answer         = lv_answer
* TABLES
*     T_MSG_TEXT       =
    EXCEPTIONS
      invalid_message1 = 1
      OTHERS           = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR: field_etiqueta,tg_docs_gerados,tg_sumarizado,tg_quant_novo_doc,qtd_entrada.
  LEAVE TO SCREEN 0001.


ENDFORM.
