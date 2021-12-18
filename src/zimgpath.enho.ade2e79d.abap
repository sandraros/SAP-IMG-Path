"Name: \PR:SAPLSHI01\FO:HANDLE_MENU_SELECT\SE:BEGIN\EI
ENHANCEMENT 0 ZIMGPATH.
    CASE g_fcode.
    WHEN 'ZZSHOWPATH'.

      DATA: BEGIN OF zz,
            lv_nodekey TYPE tv_nodekey ,
            le_item TYPE shi_item,
            le_node TYPE treev_node,
            lv_relatkey TYPE tv_nodekey,
            lv_relatship_ant TYPE int4,
            html TYPE string,
            END OF zz.

      CHECK g_tree_data->tree IS NOT INITIAL.

      READ TABLE g_tree_data->nodes INTO zz-le_node WITH KEY node_key = g_tree_data->node_key  .
      CHECK sy-subrc = 0.

      READ TABLE g_tree_data->items INTO zz-le_item
        WITH KEY
          node_key = g_tree_data->node_key
          item_name = 'TEXT'.
      CHECK sy-subrc = 0.

      zz-html = |<html><body style="width:100%">{ escape( val = zz-le_item-text format = cl_abap_format=>e_html_text ) }|.

      zz-lv_relatkey  = zz-le_node-relatkey.
      zz-lv_relatship_ant = zz-le_node-relatship.

      WHILE zz-lv_relatkey IS NOT INITIAL.

        READ TABLE g_tree_data->nodes INTO zz-le_node WITH KEY node_key = zz-lv_relatkey .
        CHECK sy-subrc = 0.

        READ TABLE g_tree_data->items INTO zz-le_item WITH KEY node_key = zz-le_node-node_key item_name = 'TEXT' .
        CHECK sy-subrc = 0.

        zz-lv_relatkey = zz-le_node-relatkey .

        IF zz-le_item-text IS NOT INITIAL AND zz-lv_relatship_ant = '4'.
          zz-html = zz-le_item-text && ` → ` && zz-html.
        ENDIF.
        zz-lv_relatship_ant = zz-le_node-relatship.
      ENDWHILE.

      zz-html = zz-html && |</body></html>|.

      cl_abap_browser=>show_html(
      EXPORTING
        title       = 'Activity path'
        html_string = zz-html
        check_html  = abap_false
        size        = cl_abap_browser=>small
        format      = cl_abap_browser=>portrait
      ).

    RETURN.

  ENDCASE.
ENDENHANCEMENT.
