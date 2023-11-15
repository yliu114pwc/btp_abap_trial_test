@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'agency draft query'
@AbapCatalog.extensibility: {
  extensible: true,
  dataSources: ['agency'],
  elementSuffix: 'ZAG',
  quota: {
    maximumFields: 500,
    maximumBytes: 5000
  }
}
define view entity zr_230_agency_draft
  as select from z230_agency_d as agency
{
  key agency_id,
  key draftuuid,
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
      draftentitycreationdatetime,
      draftentitylastchangedatetime,
      draftadministrativedatauuid,
      draftentityoperationcode,
      hasactiveentity,
      draftfieldchanges
}
