"Name: \PR:SAPLSHI01\FO:HANDLE_MENU_REQUEST\SE:END\EI
ENHANCEMENT 0 ZIMGPATH.
      call method g_tree_data->menu->add_function
        exporting
          fcode = 'ZZSHOWPATH'
          text  = 'Show activity path'.
ENDENHANCEMENT.
