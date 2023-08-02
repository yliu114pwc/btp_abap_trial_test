@EndUserText.label: 'travel processor'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity zc_230_dmo_travel_processor_m
  provider contract transactional_query
  as projection on zi_230_dmo_travel_m
{
      @Search.defaultSearchElement: true
  key travel_id,
      
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Agency_StdVH', element: 'AgencyID'  }, useForValidation: true }]
      @ObjectModel.text.element: ['agency_name']
      @Search.defaultSearchElement: true
      agency_id,
            
      _agency.Name               as agency_name,
      
      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Customer_StdVH', element: 'CustomerID' }, useForValidation: true}]
      @ObjectModel.text.element: ['customer_name']
      @Search.defaultSearchElement: true
      customer_id,
      _customer.LastName         as customer_name,
      begin_date,
      end_date,

      booking_fee,
      total_price,
      
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      currency_code,
      description,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Overall_Status_VH', element: 'OverallStatus' }}]
      @ObjectModel.text.element: ['overall_status_text']    
      overall_status,
      _overall_status._Text.Text as overall_status_text : localized,
      created_by,
      created_at,
      last_changed_by,
      last_changed_at,
      /* Associations */
      _agency,
      _booking : redirected to composition child zc_230_dmo_booking_processor_m,
      _currency,
      _customer,
      _overall_status
}
