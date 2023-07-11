@EndUserText.label: 'booking supplement processor'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity zc_230_dmo_suppl_processor_m
  as projection on zi_230_dmo_booking_suppl_m
{
      @Search.defaultSearchElement: true
  key travel_id,

      @Search.defaultSearchElement: true
  key booking_id,

  key booking_supplement_id,

      @Consumption.valueHelpDefinition: [
          {  entity: {name: '/DMO/I_Supplement_StdVH', element: 'SupplementID' },
             additionalBinding: [ { localElement: 'price',        element: 'Price',        usage: #RESULT },
                                  { localElement: 'currency_code', element: 'CurrencyCode', usage: #RESULT }],
             useForValidation: true }
        ]
      @ObjectModel.text.element: ['supplement_description']
      supplement_id,
      _supplement_text.Description as supplement_description : localized,

      price,

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      currency_code,

      last_changed_at,
      /* Associations */
      _booking : redirected to parent zc_230_dmo_booking_processor_m,
      _product,
      _supplement_text,
      _travel  : redirected to zc_230_dmo_travel_processor_m
}
