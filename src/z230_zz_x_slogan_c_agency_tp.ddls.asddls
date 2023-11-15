extend view entity zc_230_agency_tp with
{
  @UI: {
    lineItem:   [ { position: 25, importance: #HIGH },
                  { position: 10, type: #FOR_ACTION, dataAction: 'zz_create_from_template', label: 'Create from Template' } ],
    fieldGroup: [ { position: 25, qualifier: 'General_FG' } ],
    identification: [ { position: 10, type: #FOR_ACTION, dataAction: 'zz_create_from_template', label: 'Create from Template' } ] 
  }
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  agency.zz_slogan_zag
}
