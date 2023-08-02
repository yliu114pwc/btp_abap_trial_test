@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'carrier singleton root view'
define root view entity zi_230_dmo_carriers_lock_s
  as select from    I_Language
    left outer join /dmo/carrier as carr on 0 = 0
  composition [0..*] of zi_230_dmo_carrier_s as _airline
{
  key 1                          as carrier_singleton_id,
      max (carr.last_changed_at) as last_changed_at,

      _airline
}
where
  I_Language.Language = $session.system_language
