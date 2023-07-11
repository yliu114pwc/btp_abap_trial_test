CLASS lhc_booking_supplement DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculate_total_price FOR DETERMINE ON MODIFY
      IMPORTING keys FOR booking_supplement~calculate_total_price.

ENDCLASS.

CLASS lhc_booking_supplement IMPLEMENTATION.

  METHOD calculate_total_price.

    DATA: travel_ids TYPE STANDARD TABLE OF /dmo/i_travel_m WITH UNIQUE HASHED KEY key COMPONENTS travel_id.

    travel_ids = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING travel_id = travel_id ).

    MODIFY ENTITIES OF zi_230_dmo_travel_m IN LOCAL MODE
      ENTITY Travel
        EXECUTE recalc_total_price
        FROM CORRESPONDING #( travel_ids ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
