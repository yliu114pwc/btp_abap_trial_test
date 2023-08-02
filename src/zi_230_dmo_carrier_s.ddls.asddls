@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'carrier'
define view entity zi_230_dmo_carrier_s
  as select from /dmo/carrier
  association to parent zi_230_dmo_carriers_lock_s as _carrier_singleton on $projection.carrier_singleton_id = _carrier_singleton.carrier_singleton_id
{
  key 1 as carrier_singleton_id,
  key carrier_id,
      name,
      currency_code,
      @Semantics.user.createdBy: true
      local_created_by,
      @Semantics.systemDateTime.createdAt: true
      local_created_at,
      @Semantics.user.lastChangedBy: true
      local_last_changed_by,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,
      _carrier_singleton
}
