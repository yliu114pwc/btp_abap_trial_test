CLASS lhc_agency DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    CONSTANTS:
      validate_dialling_code    TYPE string VALUE 'VALIDATE_DIALLING_CODE' ##NO_TEXT.

    TYPES: BEGIN OF t_countries,
             number TYPE /dmo/phone_number,
             code   TYPE land1,
           END OF t_countries.

    CLASS-DATA: countries TYPE STANDARD TABLE OF t_countries WITH KEY number.
    CLASS-METHODS: class_constructor.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR agency RESULT result.

    METHODS zz_create_from_template FOR MODIFY
      IMPORTING keys FOR ACTION agency~zz_create_from_template.

    METHODS zz_determine_country_code FOR DETERMINE ON MODIFY
      IMPORTING keys FOR agency~zz_determine_country_code.

    METHODS zz_determine_dialling_code FOR DETERMINE ON MODIFY
      IMPORTING keys FOR agency~zz_determine_dialling_code.

    METHODS zz_validate_dialling_code FOR VALIDATE ON SAVE
      IMPORTING keys FOR agency~zz_validate_dialling_code.

ENDCLASS.

CLASS lhc_agency IMPLEMENTATION.

  METHOD class_constructor.

    countries = VALUE #( ( number = '+1'   code = 'US' )
                         ( number = '+49'  code = 'DE' )
                         ( number = '+39'  code = 'IT' )
                         ( number = '+43'  code = 'AT' )
                         ( number = '+44'  code = 'GB' )
                         ( number = '+81'  code = 'JP' )
                         ( number = '+33'  code = 'FR' )
                         ( number = '+358' code = 'FI' )
                         ( number = '+385' code = 'HR' ) ).

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD zz_create_from_template.

    READ ENTITIES OF zi_230_agency_tp IN LOCAL MODE
      ENTITY agency
        FIELDS ( country_code postal_code city street ) WITH CORRESPONDING #( keys )
      RESULT DATA(agencies)
      FAILED failed.

    DATA: agencies_to_create TYPE TABLE FOR CREATE zi_230_agency_tp.
    LOOP AT agencies INTO DATA(agency).
      APPEND CORRESPONDING #( agency EXCEPT agency_id ) TO agencies_to_create ASSIGNING FIELD-SYMBOL(<agency_to_create>).
      <agency_to_create>-%cid = keys[ KEY id  %tky = agency-%tky ]-%cid.
*      <agency_to_create>-%is_draft = if_abap_behv=>mk-on.
    ENDLOOP.

    MODIFY ENTITIES OF zi_230_agency_tp IN LOCAL MODE
      ENTITY agency
        CREATE FIELDS ( country_code postal_code city street ) WITH agencies_to_create
      MAPPED mapped.

  ENDMETHOD.

  METHOD zz_determine_country_code.

    READ ENTITIES OF zi_230_agency_tp IN LOCAL MODE
        ENTITY agency
          FIELDS ( phone_number country_code ) WITH CORRESPONDING #( keys )
        RESULT DATA(agencies).

    DELETE agencies WHERE country_code IS NOT INITIAL.
    DATA: agencies_to_update TYPE TABLE FOR UPDATE zi_230_agency_tp.

    LOOP AT countries INTO DATA(country).
      DATA(country_with_00) = country-number.
      REPLACE FIRST OCCURRENCE OF '+' IN country_with_00 WITH '00'.
      LOOP AT agencies INTO DATA(agency)
        WHERE phone_number CP country-number  && '*'
          OR  phone_number CP country_with_00 && '*'.
        APPEND VALUE #( %tky        = agency-%tky
                        country_code = country-code ) TO agencies_to_update.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zi_230_agency_tp IN LOCAL MODE
      ENTITY agency
        UPDATE FIELDS ( country_code ) WITH agencies_to_update
      REPORTED DATA(reported_modify).

  ENDMETHOD.

  METHOD zz_determine_dialling_code.

    READ ENTITIES OF zi_230_agency_tp IN LOCAL MODE
        ENTITY agency
          FIELDS ( phone_number country_code ) WITH CORRESPONDING #( keys )
        RESULT DATA(agencies).

    DELETE agencies WHERE phone_number IS NOT INITIAL.
    DATA: agencies_to_update TYPE TABLE FOR UPDATE zi_230_agency_tp.

    LOOP AT agencies INTO DATA(agency).
      DATA(phone_number) = VALUE #( countries[ code = agency-country_code ]-number OPTIONAL ) .
      IF phone_number IS NOT INITIAL.
        APPEND VALUE #( %tky = agency-%tky
                        phone_number = phone_number ) TO agencies_to_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zi_230_agency_tp IN LOCAL MODE
      ENTITY agency
        UPDATE FIELDS ( phone_number ) WITH agencies_to_update
      REPORTED DATA(reported_modify).

  ENDMETHOD.

  METHOD zz_validate_dialling_code.

    READ ENTITIES OF zi_230_agency_tp IN LOCAL MODE
      ENTITY agency
       FIELDS ( phone_number country_code ) WITH CORRESPONDING #( keys )
      RESULT DATA(agencies).

    LOOP AT agencies INTO DATA(agency).
      APPEND VALUE #( %tky        = agency-%tky
                      %state_area = validate_dialling_code ) TO reported-agency.

      IF agency-phone_number IS INITIAL.
        CONTINUE.
      ENDIF.

      IF agency-phone_number(2) = '00'.
        REPLACE FIRST OCCURRENCE OF '00' IN agency-phone_number WITH '+'.
      ENDIF.

      IF agency-phone_number(1) <> '+'.

        APPEND VALUE #( %tky        = agency-%tky
                        %state_area = validate_dialling_code
                        %msg        = NEW /dmo/zz_cx_agency_country( textid      = /dmo/zz_cx_agency_country=>number_invalid
                                                             phonenumber = agency-phone_number )
                        %element-phone_number = if_abap_behv=>mk-on )
                        TO reported-agency.

      ELSEIF NOT line_exists( countries[ number = agency-phone_number(2) code = agency-country_code ] )
      AND NOT line_exists( countries[ number = agency-phone_number(3) code = agency-country_code ] )
      AND NOT line_exists( countries[ number = agency-phone_number(4) code = agency-country_code ] ).
        APPEND VALUE #( %tky        = agency-%tky
                        %state_area = validate_dialling_code
                        %msg        = NEW /dmo/zz_cx_agency_country( textid      = /dmo/zz_cx_agency_country=>combination_invalid )
                        %element-phone_number = if_abap_behv=>mk-on )
                        TO reported-agency.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
