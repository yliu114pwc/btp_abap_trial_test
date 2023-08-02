@EndUserText.label: 'carrier'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity zc_230_dmo_carrier_s
  as projection on zi_230_dmo_carrier_s
{
      @Consumption.hidden: true
  key carrier_singleton_id,
  key carrier_id,
      name,
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }, useForValidation: true }]
      currency_code,
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,
      /* Associations */
      _carrier_singleton : redirected to parent zc_230_dmo_carriers_lock_s
}
