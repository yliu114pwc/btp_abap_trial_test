@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'travel'
define root view entity zi_230_dmo_travel_m
  as select from /dmo/travel_m
  composition [0..*] of zi_230_dmo_booking_m     as _booking
  association [0..1] to /DMO/I_Agency            as _agency         on $projection.agency_id = _agency.AgencyID
  association [0..1] to /DMO/I_Customer          as _customer       on $projection.customer_id = _customer.CustomerID
  association [0..1] to I_Currency               as _currency       on $projection.currency_code = _currency.Currency
  association [1..1] to /DMO/I_Overall_Status_VH as _overall_status on $projection.overall_status = _overall_status.OverallStatus
{
  key travel_id,
      agency_id,
      customer_id,
      begin_date,
      end_date,
      booking_fee,
      total_price,
      currency_code,
      description,
      overall_status,
      created_by,
      created_at,
      last_changed_by,
      last_changed_at,

      _booking,
      _agency,
      _customer,
      _currency,
      _overall_status
}
