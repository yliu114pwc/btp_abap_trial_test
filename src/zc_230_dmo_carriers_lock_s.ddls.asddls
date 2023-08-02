@EndUserText.label: 'carrier singleton root view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity zc_230_dmo_carriers_lock_s
  provider contract transactional_query
  as projection on zi_230_dmo_carriers_lock_s
{
  key carrier_singleton_id,
      @Consumption.hidden: true
      last_changed_at,
      /* Associations */
      _airline : redirected to composition child zc_230_dmo_carrier_s
}
