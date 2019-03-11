*----------------------------------------------------------------------*
***INCLUDE ZMMI_CRIA_CONFE_USER_COMMANI03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0004  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0004 INPUT.

  CASE sy-ucomm.

    WHEN 'ENTER'.

      og_principal->trata_barcode(
      EXPORTING
        etiqueta   = field_etiqueta2
      IMPORTING
        material   =  vg_material_aux
        ebeln      =  vg_ebeln_aux
        quantidade =  vg_quantidade_aux
        ).

      DATA(vl_resultado) = og_principal->confere_ordem(
           EXPORTING
             vg_ebeln = vg_ebeln_aux    " Nº do documento de compras
             po_field = po_field        " Nº do documento de compras
         ).

      IF vl_resultado IS NOT INITIAL.
        CLEAR:message_h,message_i,field_etiqueta2.
        message_h = TEXT-004.
        message_i = |{ TEXT-005 } { po_field }|.
        CALL SCREEN 0005.
      ELSE.
        vg_material   = vg_material_aux.
        vg_ebeln      = vg_ebeln_aux.
        vg_quantidade = vg_quantidade_aux.

        CLEAR: vl_resultado,vg_material_aux,vg_ebeln_aux,vg_quantidade_aux.
        vl_resultado = og_principal->checa_quantidade(
                       tg_ztwm_receb_conf = tg_ztwm_receb_conf
                       vg_ebelp           = vg_ebelp
        ).
        IF vl_resultado IS NOT INITIAL.

          block_qtd = abap_true.

          message_j = TEXT-006.
          message_l = TEXT-007.
          message_m = TEXT-008.
          message_n = TEXT-009.

          CALL SCREEN 0006.
        ELSE.

          CALL METHOD og_principal->preenche_tela
            EXPORTING
              vg_material        = vg_material
              vg_ebeln           = vg_ebeln
              tg_ztwm_receb_conf = tg_ztwm_receb_conf
              vg_quantidade      = vg_quantidade
            IMPORTING
              vg_quant_tot       = vg_quant_tot
            CHANGING
              qtdconf_2          = qtdconf_2
              qtd_entrada        = qtd_entrada
              item_ped           = item_ped
              vg_erro            = vg_erro
              tg_sumarizado      = tg_sumarizado
              field_etiqueta     = field_etiqueta
              matnr_n            = matnr_n
              descricao          = descricao
              qtd_l              = qtd_l
              qtdconf            = qtdconf
              po_field           = po_field
              vg_ebelp           = vg_ebelp
              vg_material_found  = vg_material_found.

          IF vg_erro IS NOT INITIAL.
            CLEAR:message_h,message_i,vg_erro.
            message_h = TEXT-014.
            message_i = TEXT-015.
            CALL SCREEN 0005.
          ENDIF.

          IF vg_material_found IS NOT INITIAL.
            CLEAR:message_h,message_i,vg_material_found.
            message_h = TEXT-016.
            message_i = TEXT-017.
            CALL SCREEN 0005.
          ENDIF.
        ENDIF.
      ENDIF.

      CLEAR field_etiqueta2.

    WHEN 'SAIR' OR 'VOLTAR' OR 'CANCELAR'.

      og_principal->clear_all(
        CHANGING
          qtd_entrada        = qtd_entrada
          tg_sumarizado      = tg_sumarizado
          tg_ztwm_receb_conf = tg_ztwm_receb_conf
          field_etiqueta2    = field_etiqueta2    " Campo de caracteres de comprimento 26
          po_field           = po_field    " Nº do documento de compras
          matnr_n            = matnr_n
          descricao          = descricao
          qtd_l              = qtd_l    " Campo de comprimento 16
          qtdconf            = qtdconf   " Campo de comprimento 16
      ).

      LEAVE TO SCREEN 0.

    WHEN 'BACK_T'.

      og_principal->registro_previo(
        EXPORTING
          i_ebelp            = vg_ebelp  " Nº item do documento de compra
          tg_ztwm_receb_conf = tg_ztwm_receb_conf
        CHANGING
          qtd_entrada        = qtd_entrada
          tg_sumarizado      = tg_sumarizado
          matnr_n            = matnr_n
          descricao          = descricao
          qtd_l              = qtd_l
          qtdconf            = qtdconf
          po_field           = po_field
          vg_ebelp           = vg_ebelp
      ).

      CONDENSE qtdconf.
    WHEN 'GO_F'.

      og_principal->registro_seguinte(
      EXPORTING
        i_ebelp            = vg_ebelp  " Nº item do documento de compra
        tg_ztwm_receb_conf = tg_ztwm_receb_conf
      CHANGING
        qtd_entrada        = qtd_entrada
        field_etiqueta2   = field_etiqueta2
        tg_sumarizado      = tg_sumarizado
        matnr_n            = matnr_n
        descricao          = descricao
        qtd_l              = qtd_l
        qtdconf            = qtdconf
        po_field           = po_field
        vg_ebelp           = vg_ebelp
        ).

      CONDENSE qtdconf.

    WHEN 'BACKA'.

      og_principal->clear_all(
      CHANGING
        qtd_entrada        = qtd_entrada
        tg_sumarizado      = tg_sumarizado
        tg_ztwm_receb_conf = tg_ztwm_receb_conf
        field_etiqueta2    = field_etiqueta2    " Campo de caracteres de comprimento 26
        po_field           = po_field    " Nº do documento de compras
        matnr_n            = matnr_n
        descricao          = descricao
        qtd_l              = qtd_l    " Campo de comprimento 16
        qtdconf            = qtdconf   " Campo de comprimento 16
        ).

      CLEAR field_etiqueta.
      LEAVE TO SCREEN '0001'.

    WHEN 'PROCESS'.

      CALL METHOD og_principal->check_ordem_recebida(
        EXPORTING
          i_ordem            = vg_ebeln  " Nº do documento de compras
        IMPORTING
          tl_ztwm_receb_conf = tg_ztwm_receb_conf ). " Recebe Conf.

      MODIFY ztwm_receb_conf FROM TABLE tg_ztwm_receb_conf[].

      IF matnr_n IS NOT INITIAL.
        CLEAR vg_material.
        vg_material = matnr_n.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = vg_material
          IMPORTING
            output = vg_material.

      ENDIF.
      og_principal->executa_bapi_2(
        EXPORTING
          tg_ztwm_receb_conf = tg_ztwm_receb_conf
          material           = vg_material " Nº do material
          vg_ebelp           = vg_ebelp    " Nº item do documento de compra
          po_ebeln           = po_field    " Nº do documento de compras
          vg_quantidade      = vg_quantidade
          i_qtd_l            = vg_quant_tot
        IMPORTING
          vg_limite_error    = vg_limite_error
          tg_bapireturn      = DATA(tg_bapireturn)
          p_msgid            = p_msgid
          p_msgno            = p_msgno
          p_msgv1            = p_msgv1
          p_msgv2            = p_msgv2
          p_msgv3            = p_msgv3
          p_msgv4            = p_msgv4
         CHANGING
            tg_sumarizado   = tg_sumarizado
            tg_docs_gerados = tg_docs_gerados
      ).

      PERFORM f_exibir_msg.
*      SORT tg_docs_gerados BY mblnr.
*      READ TABLE tg_docs_gerados INTO DATA(el_docs_gerados) INDEX 1.
*      IF sy-subrc = 0.
*        doc1 = el_docs_gerados-mblnr.
*      ENDIF.
*
*      READ TABLE tg_docs_gerados INTO el_docs_gerados INDEX 2.
*      IF sy-subrc = 0.
*        doc2 = el_docs_gerados-mblnr.
*      ENDIF.
*
*      READ TABLE tg_docs_gerados INTO el_docs_gerados INDEX 3.
*      IF sy-subrc = 0.
*        doc3 = el_docs_gerados-mblnr.
*      ENDIF.
*
*      READ TABLE tg_docs_gerados INTO el_docs_gerados INDEX 4.
*      IF sy-subrc = 0.
*        doc4 = el_docs_gerados-mblnr.
*      ENDIF.
*
*      CALL SCREEN 0008.
  ENDCASE.

ENDMODULE.
