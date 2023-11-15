CLASS zcl_230_dmo_travel_uq DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES :
      if_rap_query_provider .

protected section.
private section.
ENDCLASS.



CLASS ZCL_230_DMO_TRAVEL_UQ IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).

      DATA(lv_sql_filter) = io_request->get_filter( )->get_as_sql_string( ).

      DATA(sort_elements) = io_request->get_sort_elements( ).
      DATA(lt_sort_criteria) = VALUE string_table( FOR sort_element IN sort_elements
                                                 ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                                        THEN ` descending`
                                                                                        ELSE ` ascending` ) ) ).
      DATA(lv_sort_string)  = COND #( WHEN lt_sort_criteria IS INITIAL THEN `primary key`
                                      ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

      DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
      DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
      DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_page_size ).

      DATA lt_travel_response TYPE STANDARD TABLE OF zi_230_dmo_travel_uq.
      SELECT * FROM /dmo/travel
               WHERE (lv_sql_filter)
               ORDER BY (lv_sort_string)
               INTO CORRESPONDING FIELDS OF TABLE @lt_travel_response
               OFFSET @lv_offset UP TO @lv_max_rows ROWS.

      io_response->set_data( lt_travel_response ).

    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      SELECT COUNT( * ) FROM /dmo/travel
                        INTO @DATA(lv_travel_count).
      io_response->set_total_number_of_records( lv_travel_count ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
