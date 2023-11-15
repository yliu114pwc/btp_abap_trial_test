@EndUserText.label: 'agency'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.extensibility: {
  extensible: true,
  dataSources: ['agency'],
  elementSuffix: 'ZAG',
  quota: {
    maximumFields: 500,
    maximumBytes: 5000
  }, allowNewCompositions: true
}
define root view entity zi_230_agency_tp
  provider contract transactional_interface
  as projection on zr_230_agency_tp as agency
{
  key agency_id,
      name,
      street,
      postal_code,
      city,
      country_code,
      phone_number,
      email_address,
      web_address,
      attachment,
      mime_type,
      filename,
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,
      /* Associations */
      _country
}
