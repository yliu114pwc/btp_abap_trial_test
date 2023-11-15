CLASS y230cl_dmo_travel_cp_aux DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS :
      get_client_proxy
        RETURNING
          VALUE(ro_client_proxy) TYPE REF TO /iwbep/if_cp_client_proxy.

ENDCLASS.



CLASS Y230CL_DMO_TRAVEL_CP_AUX IMPLEMENTATION.


  METHOD get_client_proxy.

    " Getting the destination of foreign system
    TRY.
        " Getting the destination of foreign system
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
            i_name           = 'E2T_OP'
            i_authn_mode     = if_a4c_cp_service=>service_specific
        ).

        " Create http client
        " Details depend on your connection settings
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        " Error handling
      CATCH cx_http_dest_provider_error INTO DATA(lx_http_dest_provider_error).

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).

    ENDTRY..

    " Instantiation of client proxy
    TRY.
        ro_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
            iv_service_definition_name = 'Z230_DMO_TRAVEL_C_A'
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/Y230_DMO_TRAVEL_O2' ).

      CATCH cx_web_http_client_error INTO lx_web_http_client_error.

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
