CLASS z230cl_dmo_travel_cq DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES :
      if_rap_query_provider .

ENDCLASS.



CLASS Z230CL_DMO_TRAVEL_CQ IMPLEMENTATION.


  METHOD if_rap_query_provider~select.


  try.

    """Instantiate Client Proxy
    DATA(lo_client_proxy) = y230cl_dmo_travel_cp_aux=>get_client_proxy( ).

  CATCH cx_root.

  ENDTRY.

    TRY.
        """Create Read Request
        DATA(lo_read_request) = lo_client_proxy->create_resource_for_entity_set( 'Y230C_DMO_TRAVEL' )->create_request_for_read( ).

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    ENDTRY.

    """Request Count
    IF io_request->is_total_numb_of_rec_requested( ).
      lo_read_request->request_count( ).
    ENDIF.

    """Request Data
    IF io_request->is_data_requested( ).
      """Request Paging
      DATA(ls_paging) = io_request->get_paging( ).
      IF ls_paging->get_offset( ) >= 0.
        lo_read_request->set_skip( ls_paging->get_offset( ) ).
      ENDIF.
      IF ls_paging->get_page_size( ) <> if_rap_query_paging=>page_size_unlimited.
        lo_read_request->set_top( ls_paging->get_page_size( ) ).
      ENDIF.
    ENDIF.

    """Execute the Request
    DATA(lo_response) = lo_read_request->execute( ).

    """Set Count
    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lo_response->get_count( ) ).
    ENDIF.

    """Set Data
    IF io_request->is_data_requested( ).
      DATA: lt_travel    TYPE STANDARD TABLE OF zy230c_dmo_travel,
            lt_travel_ce TYPE STANDARD TABLE OF z230i_dmo_travel_c_c,
            lt_traveladd TYPE STANDARD TABLE OF z230dmotraveladd.

      lo_response->get_business_data( IMPORTING et_business_data = lt_travel ).

      IF lt_travel IS NOT INITIAL.
        lt_travel_ce = CORRESPONDING #( lt_travel ).
        SELECT * FROM z230dmotraveladd FOR ALL ENTRIES IN @lt_travel_ce WHERE travel_id = @lt_travel_ce-travel_id INTO TABLE @lt_traveladd.

        LOOP AT lt_travel_ce ASSIGNING FIELD-SYMBOL(<fs_travel_ce>).
          IF line_exists( lt_traveladd[ travel_id = <fs_travel_ce>-travel_id ] ).
            <fs_travel_ce>-discount_pct              = lt_traveladd[ travel_id = <fs_travel_ce>-travel_id ]-discount_pct.
            <fs_travel_ce>-discount_abs              = lt_traveladd[ travel_id = <fs_travel_ce>-travel_id ]-discount_abs.
            <fs_travel_ce>-total_price_with_discount = <fs_travel_ce>-total_price * ( 1 - <fs_travel_ce>-discount_pct / 100 ) - <fs_travel_ce>-discount_abs.
            <fs_travel_ce>-calculated_etag           = lt_traveladd[ travel_id = <fs_travel_ce>-travel_id ]-last_changed_at.
          ELSE.
            <fs_travel_ce>-total_price_with_discount = <fs_travel_ce>-total_price.
          ENDIF.
        ENDLOOP.
      ENDIF.

      io_response->set_data( lt_travel_ce ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
