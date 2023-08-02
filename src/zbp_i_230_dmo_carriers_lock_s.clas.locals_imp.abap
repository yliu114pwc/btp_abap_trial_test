CLASS lhc_carrier DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR carrier RESULT result.

    METHODS validate_currency_code FOR VALIDATE ON SAVE
      IMPORTING keys FOR carrier~validate_currency_code.

    METHODS validate_name FOR VALIDATE ON SAVE
      IMPORTING keys FOR carrier~validate_name.

ENDCLASS.

CLASS lhc_carrier IMPLEMENTATION.

  METHOD get_instance_features.

    DATA: airline_ids TYPE SORTED TABLE OF /dmo/carrier WITH UNIQUE KEY carrier_id.

    READ ENTITIES OF zi_230_dmo_carriers_lock_s IN LOCAL MODE
      ENTITY carrier
        FIELDS ( carrier_id )
        WITH CORRESPONDING #( keys )
      RESULT DATA(carrier)
      FAILED failed.

    airline_ids = CORRESPONDING #( carrier DISCARDING DUPLICATES MAPPING carrier_id = carrier_id EXCEPT * ).

    IF airline_ids IS NOT INITIAL.
      SELECT DISTINCT carrier_id
      FROM /dmo/connection
        FOR ALL ENTRIES IN @airline_ids
        WHERE carrier_id = @airline_ids-carrier_id
        INTO TABLE @DATA(connections_db).
    ENDIF.

    LOOP AT carrier ASSIGNING FIELD-SYMBOL(<carrier>).
      " Delete is not allowed if any Connection exists
      IF line_exists( connections_db[ carrier_id = <carrier>-carrier_id ] ).
        APPEND VALUE #( %tky    = <carrier>-%tky
                        %delete = if_abap_behv=>fc-o-disabled ) TO result.
        APPEND VALUE #( %tky                         = <carrier>-%tky
                        %msg                         = NEW /dmo/cx_carriers_s(
                                                           textid        = /dmo/cx_carriers_s=>airline_still_used
                                                           severity      = if_abap_behv_message=>severity-information
                                                           airline_id    = <carrier>-carrier_id )
                        %delete                      = if_abap_behv=>mk-on
                        %path-carriers_lock_singleton = CORRESPONDING #( <carrier> )
                      ) TO reported-carrier.
      ELSE.
        APPEND VALUE #( %tky    = <carrier>-%tky
                        %delete = if_abap_behv=>fc-o-enabled ) TO result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validate_currency_code.

    DATA: currency_codes TYPE SORTED TABLE OF i_currency WITH UNIQUE KEY currency.

    READ ENTITIES OF zi_230_dmo_carriers_lock_s IN LOCAL MODE
      ENTITY carrier
        FIELDS ( carrier_singleton_id currency_code )
        WITH CORRESPONDING #( keys )
      RESULT DATA(carrier).

    currency_codes = CORRESPONDING #( carrier DISCARDING DUPLICATES MAPPING currency = currency_code EXCEPT * ).

    IF currency_codes IS NOT INITIAL.
      SELECT FROM i_currency FIELDS currency
        FOR ALL ENTRIES IN @currency_codes
        WHERE currency = @currency_codes-currency
        INTO TABLE @DATA(currency_codes_db).
    ENDIF.

    " Raise message for not existing Currency Codes
    LOOP AT carrier ASSIGNING FIELD-SYMBOL(<carrier>).

      APPEND VALUE #( %tky        = <carrier>-%tky
                      %state_area = 'VALIDATE_CURRENCY_CODE'
                    ) TO reported-carrier.

      IF <carrier>-currency_code IS INITIAL.
        APPEND VALUE #( %tky                             = <carrier>-%tky ) TO failed-carrier.
        APPEND VALUE #( %tky                             = <carrier>-%tky
                        %msg                             = NEW /dmo/cx_carriers_s(
                                                               textid     = /dmo/cx_carriers_s=>currency_code_required
                                                               severity   = if_abap_behv_message=>severity-error
                                                               airline_id = <carrier>-carrier_id )
                        %element-currency_code           = if_abap_behv=>mk-on
                        %state_area                      = 'VALIDATE_CURRENCY_CODE'
                        %path-carriers_lock_singleton    = CORRESPONDING #( <carrier> )
                      ) TO reported-carrier.

      ELSEIF NOT line_exists( currency_codes_db[ currency = <carrier>-currency_code ] ).
        APPEND VALUE #( %tky                             = <carrier>-%tky ) TO failed-carrier.
        APPEND VALUE #( %tky                             = <carrier>-%tky
                        %msg                             = NEW /dmo/cx_carriers_s(
                                                               textid        = /dmo/cx_carriers_s=>invalid_currency_code
                                                               severity      = if_abap_behv_message=>severity-error
                                                               currency_code = <carrier>-currency_code )
                        %element-currency_code           = if_abap_behv=>mk-on
                        %state_area                      = 'VALIDATE_CURRENCY_CODE'
                        %path-carriers_lock_singleton    = CORRESPONDING #( <carrier> )
                      ) TO reported-carrier.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validate_name.

    READ ENTITIES OF zi_230_dmo_carriers_lock_s IN LOCAL MODE
      ENTITY carrier
        FIELDS ( carrier_singleton_id name )
        WITH CORRESPONDING #( keys )
      RESULT DATA(carrier).

    " Raise message for empty Airline Name
    LOOP AT carrier ASSIGNING FIELD-SYMBOL(<carrier>).

      APPEND VALUE #( %tky        = <carrier>-%tky
                      %state_area = 'VALIDATE_NAME'
                    ) TO reported-carrier.

      IF <carrier>-name IS INITIAL.
        APPEND VALUE #( %tky                          = <carrier>-%tky ) TO failed-carrier.
        APPEND VALUE #( %tky                          = <carrier>-%tky
                        %msg                          = NEW /dmo/cx_carriers_s(
                                                            textid     = /dmo/cx_carriers_s=>name_required
                                                            severity   = if_abap_behv_message=>severity-error
                                                            airline_id = <carrier>-carrier_id )
                        %element-name                 = if_abap_behv=>mk-on
                        %state_area                   = 'VALIDATE_NAME'
                        %path-carriers_lock_singleton = CORRESPONDING #( <carrier> )
                      ) TO reported-carrier.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_carriers_lock_singleton DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR carriers_lock_singleton RESULT result.

ENDCLASS.

CLASS lhc_carriers_lock_singleton IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_230_dmo_carriers_lock_s DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_230_dmo_carriers_lock_s IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
