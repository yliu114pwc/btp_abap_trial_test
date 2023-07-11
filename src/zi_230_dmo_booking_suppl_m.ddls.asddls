@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking supplement'
define view entity zi_230_dmo_booking_suppl_m
  as select from /dmo/booksuppl_m
  association        to parent zi_230_dmo_booking_m as _booking         on  $projection.travel_id  = _booking.travel_id
                                                                        and $projection.booking_id = _booking.booking_id
  association [1..1] to zi_230_dmo_travel_m         as _travel          on  $projection.travel_id = _travel.travel_id
  association [1..1] to /DMO/I_Supplement           as _product         on  $projection.supplement_id = _product.SupplementID
  association [1..*] to /DMO/I_SupplementText       as _supplement_text on  $projection.supplement_id = _supplement_text.SupplementID
{
  key travel_id,
  key booking_id,
  key booking_supplement_id,
      supplement_id,
      price,
      currency_code,
      last_changed_at,

      _booking,
      _travel,
      _product,
      _supplement_text
}
