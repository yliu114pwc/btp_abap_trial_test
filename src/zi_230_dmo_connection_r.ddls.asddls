@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'connection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_230_dmo_connection_r
  as select from /dmo/connection
  association [0..*] to zi_230_dmo_flight_r as _flight  on  $projection.carrier_id    = _flight.carrier_id
                                                        and $projection.connection_id = _flight.connection_id
  association [0..1] to zi_230_dmo_carrier  as _airline on  $projection.carrier_id = _airline.carrier_id
{
  key carrier_id,
  key connection_id,
      airport_from_id,
      airport_to_id,
      departure_time,
      arrival_time,
      distance,
      distance_unit,

      _flight,
      _airline
}
