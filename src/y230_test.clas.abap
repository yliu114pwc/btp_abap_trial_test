CLASS y230_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

ENDCLASS.



CLASS Y230_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    SELECT FROM   /dmo/agency
*           FIELDS *
*           INTO TABLE @DATA(lt_agency).
*
*    CHECK lt_agency IS NOT INITIAL.
*
*    DATA lt_z230_agency TYPE STANDARD TABLE OF z230_agency WITH EMPTY KEY.
*
*    lt_z230_agency = CORRESPONDING #( lt_agency ).
*
*    MODIFY z230_agency FROM TABLE @lt_z230_agency.

    DATA(lo_client_proxy) = y230cl_dmo_travel_cp_aux=>get_client_proxy( ).

    TRY.
        """Create Read Request
        DATA(lo_read_request) = lo_client_proxy->create_resource_for_entity_set( 'Y230C_DMO_TRAVEL' )->create_request_for_read( ).

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
