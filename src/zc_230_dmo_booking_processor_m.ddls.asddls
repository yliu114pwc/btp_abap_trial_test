@EndUserText.label: 'booking processor'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity zc_230_dmo_booking_processor_m
  as projection on zi_230_dmo_booking_m
{
      @Search.defaultSearchElement: true
  key travel_id,

      @Search.defaultSearchElement: true
  key booking_id,

      booking_date,

      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Customer_StdVH', element: 'CustomerID' }, useForValidation: true}]
      @ObjectModel.text.element: ['customer_name']
      @Search.defaultSearchElement: true
      customer_id,
      _customer.LastName         as customer_name,

      @Consumption.valueHelpDefinition: [
          { entity: {name: '/DMO/I_Flight_StdVH', element: 'AirlineID'},
            additionalBinding: [ { localElement: 'flight_date',   element: 'FlightDate',   usage: #RESULT},
                                 { localElement: 'connection_id', element: 'ConnectionID', usage: #RESULT},
                                 { localElement: 'flight_price',  element: 'Price',        usage: #RESULT},
                                 { localElement: 'currency_code', element: 'CurrencyCode', usage: #RESULT } ],
            useForValidation: true }
        ]
      @ObjectModel.text.element: ['carrier_name']
      carrier_id,
      _carrier.Name              as carrier_name,

      @Consumption.valueHelpDefinition: [
          { entity: {name: '/DMO/I_Flight_StdVH', element: 'ConnectionID'},
            additionalBinding: [ { localElement: 'flight_date',   element: 'FlightDate',   usage: #RESULT},
                                 { localElement: 'carrier_id',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
                                 { localElement: 'flight_price',  element: 'Price',        usage: #RESULT},
                                 { localElement: 'currency_code', element: 'CurrencyCode', usage: #RESULT } ],
            useForValidation: true }
        ]
      connection_id,

      @Consumption.valueHelpDefinition: [
          { entity: {name: '/DMO/I_Flight_StdVH', element: 'FlightDate'},
            additionalBinding: [ { localElement: 'carrier_id',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
                                 { localElement: 'connection_id', element: 'ConnectionID', usage: #FILTER_AND_RESULT},
                                 { localElement: 'flight_price',  element: 'Price',        usage: #RESULT},
                                 { localElement: 'currency_code', element: 'CurrencyCode', usage: #RESULT } ],
            useForValidation: true }
        ]
      flight_date,

      @Semantics.amount.currencyCode: 'currency_code'
      flight_price,

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      currency_code,

      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Booking_Status_VH', element: 'BookingStatus' }}]
      @ObjectModel.text.element: ['booking_status_text']
      booking_status,

      @UI.hidden: true
      _booking_status._Text.Text as booking_status_text : localized,

      @UI.hidden: true
      last_changed_at,
      /* Associations */
      _booking_status,
      _booking_supplement : redirected to composition child zc_230_dmo_suppl_processor_m,
      _carrier,
      _connection,
      _customer,
      _travel             : redirected to parent zc_230_dmo_travel_processor_m
}
