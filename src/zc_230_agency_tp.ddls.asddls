@EndUserText.label: 'agency'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.extensibility: {
  extensible: true,
  dataSources: ['agency'],
  elementSuffix: 'ZAG',
  quota: {
    maximumFields: 500,
    maximumBytes: 5000
  }, 
  allowNewCompositions: true
}
@Metadata.allowExtensions: true
define root view entity zc_230_agency_tp
  provider contract transactional_query
  as projection on zr_230_agency_tp as agency
{
  key agency_id,
      name,
      street,
      postal_code,
      city,
      @ObjectModel.text.element: ['country_name']
      country_code,
      _country._Text.CountryName as country_name : localized,
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
      last_changed_at
}
