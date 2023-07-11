CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_booking_sup FOR NUMBERING
      IMPORTING entities FOR CREATE booking\_booking_supplement.

    METHODS validate_status FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validate_status.

    METHODS calculate_total_price FOR DETERMINE ON MODIFY
      IMPORTING keys FOR booking~calculate_total_price.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_booking_sup.

    DATA max_booking_suppl_id TYPE /dmo/booking_supplement_id .

    READ ENTITIES OF zi_230_dmo_travel_m IN LOCAL MODE
      ENTITY booking BY \_booking_supplement
        FROM CORRESPONDING #( entities )
        LINK DATA(booking_supplements).

    " Loop over all unique tky (TravelID + BookingID)
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.

      " Get highest bookingsupplement_id from bookings belonging to booking
      max_booking_suppl_id = REDUCE #( INIT max = CONV /dmo/booking_supplement_id( '0' )
                                       FOR  booksuppl IN booking_supplements USING KEY entity
                                                                             WHERE (     source-travel_id  = <booking_group>-travel_id
                                                                                     AND source-booking_id = <booking_group>-booking_id )
                                       NEXT max = COND /dmo/booking_supplement_id( WHEN   booksuppl-target-booking_supplement_id > max
                                                                          THEN booksuppl-target-booking_supplement_id
                                                                          ELSE max )
                                     ).
      " Get highest assigned bookingsupplement_id from incoming entities
      max_booking_suppl_id = REDUCE #( INIT max = max_booking_suppl_id
                                       FOR  entity IN entities USING KEY entity
                                                               WHERE (     travel_id  = <booking_group>-travel_id
                                                                       AND booking_id = <booking_group>-booking_id )
                                       FOR  target IN entity-%target
                                       NEXT max = COND /dmo/booking_supplement_id( WHEN   target-booking_supplement_id > max
                                                                                     THEN target-booking_supplement_id
                                                                                     ELSE max )
                                     ).


      " Loop over all entries in entities with the same TravelID and BookingID
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>) USING KEY entity WHERE travel_id  = <booking_group>-travel_id
                                                                            AND booking_id = <booking_group>-booking_id.

        " Assign new booking_supplement-ids
        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<booksuppl_wo_numbers>).
          APPEND CORRESPONDING #( <booksuppl_wo_numbers> ) TO mapped-booking_supplement ASSIGNING FIELD-SYMBOL(<mapped_booksuppl>).
          IF <booksuppl_wo_numbers>-booking_supplement_id IS INITIAL.
            max_booking_suppl_id += 1 .
            <mapped_booksuppl>-booking_supplement_id = max_booking_suppl_id .
          ENDIF.
        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD validate_status.

    READ ENTITIES OF zi_230_dmo_travel_m IN LOCAL MODE
      ENTITY booking
        FIELDS ( booking_status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    LOOP AT bookings INTO DATA(booking).
      CASE booking-booking_status.
        WHEN 'N'.  " New
        WHEN 'X'.  " Canceled
        WHEN 'B'.  " Booked

        WHEN OTHERS.
          APPEND VALUE #( %tky = booking-%tky ) TO failed-booking.

          APPEND VALUE #( %tky = booking-%tky
                          %msg = NEW /dmo/cm_flight_messages(
                                     textid = /dmo/cm_flight_messages=>status_invalid
                                     status = booking-booking_status
                                     severity = if_abap_behv_message=>severity-error )
                          %element-booking_status = if_abap_behv=>mk-on
                          %path = VALUE #(  travel-travel_id    = booking-travel_id )
                        ) TO reported-booking.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

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
