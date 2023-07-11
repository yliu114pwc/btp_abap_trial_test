@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking'
define view entity zi_230_dmo_booking_m
  as select from /dmo/booking_m
  association        to parent zi_230_dmo_travel_m as _travel         on  $projection.travel_id = _travel.travel_id
  composition [0..*] of zi_230_dmo_booking_suppl_m as _booking_supplement
  association [1..1] to /DMO/I_Customer            as _customer       on  $projection.customer_id = _customer.CustomerID
  association [1..1] to /DMO/I_Carrier             as _carrier        on  $projection.carrier_id = _carrier.AirlineID
  association [1..1] to /DMO/I_Connection          as _connection     on  $projection.carrier_id    = _connection.AirlineID
                                                                      and $projection.connection_id = _connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH   as _booking_status on  $projection.booking_status = _booking_status.BookingStatus
{
  key travel_id,
  key booking_id,
      booking_date,
      customer_id,
      carrier_id,
      connection_id,
      flight_date,
      flight_price,
      currency_code,
      booking_status,
      last_changed_at,

      _travel,
      _booking_supplement,
      _customer,
      _carrier,
      _connection,
      _booking_status
}
