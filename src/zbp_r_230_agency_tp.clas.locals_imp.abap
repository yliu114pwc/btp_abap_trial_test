CLASS lhc_agency DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      state_area_validate_attachment TYPE string VALUE 'VALIDATE_ATTACHMENT' ##NO_TEXT,
      state_area_validate_name       TYPE string VALUE 'VALIDATE_NAME'       ##NO_TEXT,
      state_area_validate_email      TYPE string VALUE 'VALIDATE_EMAIL'      ##NO_TEXT,
      state_area_validate_country    TYPE string VALUE 'VALIDATE_COUNTRY'    ##NO_TEXT.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR agency RESULT result.

    METHODS validate_country_code FOR VALIDATE ON SAVE
      IMPORTING keys FOR agency~validate_country_code.

    METHODS validate_email_address FOR VALIDATE ON SAVE
      IMPORTING keys FOR agency~validate_email_address.

    METHODS validate_name FOR VALIDATE ON SAVE
      IMPORTING keys FOR agency~validate_name.

ENDCLASS.

CLASS lhc_agency IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validate_country_code.

    DATA: countries TYPE SORTED TABLE OF i_country WITH UNIQUE KEY country.

    READ ENTITIES OF zr_230_agency_tp IN LOCAL MODE
      ENTITY agency
        FIELDS ( country_code )
        WITH CORRESPONDING #(  keys )
        RESULT DATA(agencies).

    countries = CORRESPONDING #( agencies DISCARDING DUPLICATES MAPPING country = country_code EXCEPT * ).
    DELETE countries WHERE country IS INITIAL.

    IF countries IS NOT INITIAL.
      SELECT FROM i_country FIELDS country
        FOR ALL ENTRIES IN @countries
        WHERE country = @countries-country
        INTO TABLE @DATA(countries_db).
    ENDIF.

    LOOP AT agencies INTO DATA(agency).
      APPEND VALUE #(
          %tky        = agency-%tky
          %state_area = state_area_validate_country
        ) TO reported-agency.

      IF   agency-country_code IS INITIAL
        OR NOT line_exists( countries_db[ country = agency-country_code ] ).

        APPEND VALUE #(  %tky = agency-%tky ) TO failed-agency.
        APPEND VALUE #(
            %tky                  = agency-%tky
            %state_area           = state_area_validate_country
            %msg                  = NEW /dmo/cx_agency(
                                      textid      = /dmo/cx_agency=>country_code_invalid
                                      countrycode = agency-country_code
                                    )
            %element-country_code = if_abap_behv=>mk-on
          ) TO reported-agency.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validate_email_address.

    READ ENTITIES OF zr_230_agency_tp IN LOCAL MODE
      ENTITY agency
        FIELDS ( email_address )
        WITH CORRESPONDING #( keys )
        RESULT DATA(agencies).

    LOOP AT agencies INTO DATA(agency).

      APPEND VALUE #(
          %tky        = agency-%tky
          %state_area = state_area_validate_email
        ) TO reported-agency.

      " Conversion to string to truncate trailing spaces, so + doesn't match space.
      IF CONV string( agency-email_address ) NP '+*@+*.+*'.

        APPEND VALUE #( %tky = agency-%tky ) TO failed-agency.

        APPEND VALUE #(
            %tky                   = agency-%tky
            %state_area            = state_area_validate_email
            %msg                   = NEW /dmo/cx_agency( /dmo/cx_agency=>email_invalid_format )
            %element-email_address = if_abap_behv=>mk-on
          ) TO reported-agency.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validate_name.

    READ ENTITIES OF zr_230_agency_tp IN LOCAL MODE
      ENTITY agency
        FIELDS ( name )
        WITH CORRESPONDING #( keys )
        RESULT DATA(agencies).

    LOOP AT agencies INTO DATA(agency).
      APPEND VALUE #(
          %tky        = agency-%tky
          %state_area = state_area_validate_name
        ) TO reported-agency.

      IF agency-name IS INITIAL.
        APPEND VALUE #( %tky = agency-%tky ) TO failed-agency.

        APPEND VALUE #(
            %tky          = agency-%tky
            %state_area   = state_area_validate_name
            %msg          = NEW /dmo/cx_agency( /dmo/cx_agency=>name_required )
            %element-name = if_abap_behv=>mk-on
          ) TO reported-agency.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_230_agency_tp DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_230_agency_tp IMPLEMENTATION.

  METHOD adjust_numbers.

    DATA:
      agency_id_max TYPE /dmo/agency_id,
      entity        TYPE STRUCTURE FOR MAPPED LATE zr_230_agency_tp.

    DATA(entities_wo_agencyid) = mapped-agency.
    DELETE entities_wo_agencyid WHERE agency_id IS NOT INITIAL.

    IF entities_wo_agencyid IS INITIAL.
      EXIT.
    ENDIF.

    " Get Numbers
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/AGNCY'
            quantity          = CONV #( lines( entities_wo_agencyid  ) )
          IMPORTING
            number            = DATA(number_range_key)
            returncode        = DATA(number_range_return_code)
            returned_quantity = DATA(number_range_returned_quantity)
        ).
      CATCH cx_number_ranges INTO DATA(lx_number_ranges).
        RAISE SHORTDUMP lx_number_ranges.

    ENDTRY.

    CASE number_range_return_code.
      WHEN '1'.
        " 1 - the returned number is in a critical range (specified under “percentage warning” in the object definition)
        LOOP AT entities_wo_agencyid INTO entity.
          APPEND VALUE #(
              %pid = entity-%pid
              %key = entity-%key
              %msg = NEW /dmo/cx_agency(
                          textid   = /dmo/cx_agency=>number_range_depleted
                          severity = if_abap_behv_message=>severity-warning )
            ) TO reported-agency.
        ENDLOOP.

      WHEN '2' OR '3'.
        " 2 - the last number of the interval was returned
        " 3 - if fewer numbers are available than requested,  the return code is 3
        RAISE SHORTDUMP NEW /dmo/cx_agency( textid   = /dmo/cx_agency=>not_sufficient_numbers
                                            severity = if_abap_behv_message=>severity-warning ).
    ENDCASE.

    " At this point ALL entities get a number!
    ASSERT number_range_returned_quantity = lines( entities_wo_agencyid ).

    agency_id_max = number_range_key - number_range_returned_quantity.

    " Set Agency ID
    LOOP AT mapped-agency ASSIGNING FIELD-SYMBOL(<agency>) ."USING KEY entity" WHERE agencyid IS INITIAL.
      IF <agency>-agency_id IS INITIAL. "If condition necessary?
        agency_id_max += 1.
        <agency>-agency_id = agency_id_max .

        " Read table mapped assign
      ENDIF.
    ENDLOOP.

    ASSERT agency_id_max = number_range_key.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
