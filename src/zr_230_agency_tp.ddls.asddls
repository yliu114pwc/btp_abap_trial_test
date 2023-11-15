@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'agency'
@Search.searchable: true
@AbapCatalog.extensibility: {
  extensible: true,
  elementSuffix: 'ZAG',
  allowNewDatasources: false,
  dataSources: ['_extension'],
  quota: {
    maximumFields: 500,
    maximumBytes: 5000
  },
  allowNewCompositions: true
}
define root view entity zr_230_agency_tp
  as select from zi_230_agency
  association [1] to ze_230_agency as _extension on $projection.agency_id = _extension.agency_id
{
      @ObjectModel.text.element: ['name']
  key agency_id,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      name,
      street,
      postal_code,
      @Search.defaultSearchElement: true
      city,
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_Country', element: 'Country' } }]
      country_code,
      phone_number,
      email_address,
      web_address,
      attachment,
      mime_type,
      filename,
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
      /* Associations */
      _country
}
