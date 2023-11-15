/********** GENERATED on 11/08/2023 at 14:18:51 by CB9980003938**************/
 @OData.entitySet.name: 'y230c_dmo_travel' 
 @OData.entityType.name: 'y230c_dmo_travelType' 
 define root abstract entity ZY230C_DMO_TRAVEL { 
 key travel_id : abap.numc( 8 ) ; 
 @Odata.property.valueControl: 'agency_id_vc' 
 agency_id : abap.numc( 8 ) ; 
 agency_id_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'agency_id_text_vc' 
 agency_id_text : abap.char( 25 ) ; 
 agency_id_text_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'customer_id_vc' 
 customer_id : abap.numc( 8 ) ; 
 customer_id_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'customer_id_text_vc' 
 customer_id_text : abap.char( 25 ) ; 
 customer_id_text_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'flight_date_vc' 
 flight_date : RAP_CP_ODATA_V2_EDM_DATETIME ; 
 flight_date_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'total_price_vc' 
 @Semantics.amount.currencyCode: 'currency_code' 
 total_price : abap.curr( 15, 3 ) ; 
 total_price_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'currency_code_vc' 
 @Semantics.currencyCode: true 
 currency_code : abap.cuky ; 
 currency_code_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 ETAG__ETAG : abap.string( 0 ) ; 
 
 } 
