@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'flight'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_230_dmo_flight_r
  as select from /dmo/flight
  association [0..1] to zi_230_dmo_carrier as _airline on $projection.carrier_id = _airline.carrier_id
{
  key carrier_id,
  key connection_id,
  key flight_date,
      @Semantics.amount.currencyCode: 'currency_code'
      price,
      currency_code,
      plane_type_id,
      seats_max,
      seats_occupied,

      _airline
}
