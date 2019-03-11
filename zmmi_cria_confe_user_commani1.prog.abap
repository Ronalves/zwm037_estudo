*----------------------------------------------------------------------*
***INCLUDE ZMMI_CRIA_CONFE_USER_COMMANI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0001 INPUT.

  CASE sy-ucomm.
    WHEN 'ENTER'.

      og_principal->trata_barcode(
      EXPORTING
        etiqueta   = field_etiqueta
      IMPORTING
        material   =  vg_material
        ebeln      =  vg_ebeln
        quantidade =  vg_quantidade
        ).

      IF  og_principal->check_status_pedido( ebeln = vg_ebeln ) = abap_true.

        message_f  = TEXT-010.
        message_f2 = TEXT-013.

        CALL SCREEN '0002'.
        EXIT.

      ENDIF.

      DATA(resultado) = og_principal->check_existe_ordem( i_ordem = vg_ebeln ).
      IF resultado IS NOT INITIAL.

        message_f  = TEXT-001.
        message_f2 = TEXT-002.

        CALL SCREEN '0002'.

      ELSE.
        CLEAR resultado.
        resultado = og_principal->check_ordem_conferida( i_ordem = vg_ebeln ).
        IF resultado IS NOT INITIAL.

          message_g  = TEXT-003.
          CALL SCREEN '0003'.

        ELSE.
          CALL METHOD og_principal->check_ordem_recebida(
            EXPORTING
              i_ordem            = vg_ebeln  " Nº do documento de compras
            IMPORTING
              tl_ztwm_receb_conf = tg_ztwm_receb_conf " Recebe Conf.
                                   ).
          IF tg_ztwm_receb_conf[] IS NOT INITIAL.

            CALL METHOD og_principal->preenche_tela
              EXPORTING
                vg_material        = vg_material
                vg_ebeln           = vg_ebeln
                tg_ztwm_receb_conf = tg_ztwm_receb_conf
                vg_quantidade      = vg_quantidade
                vg_first           = abap_true
              IMPORTING
                vg_quant_tot       = vg_quant_tot
              CHANGING
                qtdconf_2          = qtdconf_2
                qtd_entrada        = qtd_entrada
                item_ped           = item_ped
                tg_sumarizado      = tg_sumarizado
                field_etiqueta     = field_etiqueta
                matnr_n            = matnr_n
                descricao          = descricao
                qtd_l              = qtd_l
                qtdconf            = qtdconf
                po_field           = po_field
                vg_ebelp           = vg_ebelp
                vg_material_found  = vg_material_found.

            IF vg_material_found IS NOT INITIAL.
              CLEAR:message_h,message_i,vg_material_found.
              message_h = TEXT-016.
              message_i = TEXT-017.
              CALL SCREEN 0005.
              EXIT.
            ENDIF.

            SELECT ebeln,
                   ebelp,
                   loekz
            FROM ekpo ##DB_FEATURE_MODE[TABLE_LEN_MAX1]
            INTO TABLE @DATA(tg_ekpo_tmp)
                  FOR ALL ENTRIES IN @tg_ztwm_receb_conf
                  WHERE ebeln = @tg_ztwm_receb_conf-ebeln
                  AND ebelp = @tg_ztwm_receb_conf-ebelp
                  AND loekz <> @space.

            SORT:tg_ekpo_tmp BY ebeln ASCENDING
            ebelp ASCENDING.
            SORT:tg_ztwm_receb_conf BY ebeln ASCENDING
            ebelp ASCENDING.

            LOOP AT tg_ekpo_tmp INTO DATA(el_ekpo_tmp).
              READ TABLE tg_ztwm_receb_conf INTO DATA(el_ztwm_receb_conf) WITH KEY ebeln = el_ekpo_tmp-ebeln
                    ebelp = el_ekpo_tmp-ebelp BINARY SEARCH.
              IF sy-subrc = 0.
                DELETE tg_ztwm_receb_conf INDEX sy-tabix.
              ENDIF.
            ENDLOOP.

            CALL SCREEN '0004'.

          ENDIF.
        ENDIF.
      ENDIF.

    WHEN 'SAIR' OR 'VOLTAR' OR 'F3-SAIR' OR 'CANCELAR'.

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

      LEAVE PROGRAM.

  ENDCASE.
ENDMODULE.
