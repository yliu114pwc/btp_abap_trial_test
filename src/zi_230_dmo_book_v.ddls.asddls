@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zi_230_dmo_book_v
  as select from /dmo/booking_m
{
  key travel_id,
  key booking_id,
      booking_date,
      @Consumption.valueHelpDefinition: [{entity: { name: '/DMO/I_Customer_StdVH', element: 'CustomerID' }}]
      customer_id,
      @Consumption.valueHelpDefinition: [{ 
            entity: {name: '/DMO/I_Flight_StdVH', element: 'AirlineID'},
            additionalBinding: [ { localElement: 'flight_date',   element: 'FlightDate',   usage: #RESULT},
                                 { localElement: 'connection_id', element: 'ConnectionID', usage: #RESULT},
                                 { localElement: 'currency_code', element: 'CurrencyCode', usage: #RESULT }] 
      }]
      carrier_id,
      @Consumption.valueHelpDefinition: [{ 
            entity: {name: '/DMO/I_Flight_StdVH', element: 'ConnectionID'},
            additionalBinding: [ { localElement: 'flight_date',   element: 'FlightDate',   usage: #RESULT},
                                 { localElement: 'carrier_id',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
                                 { localElement: 'currency_code', element: 'CurrencyCode', usage: #RESULT }]
      }]
      connection_id,
      flight_date,
      flight_price,
      currency_code,
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Booking_Status_VH', element: 'BookingStatus' }}]
      booking_status,
      last_changed_at
}
