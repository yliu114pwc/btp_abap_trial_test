@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'agency'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_230_agency
  as select from z230_agency
  association [0..1] to I_Country as _country on $projection.country_code = _country.Country
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
      dummy_field,
      zz_slogan_zag,

      _country
}
