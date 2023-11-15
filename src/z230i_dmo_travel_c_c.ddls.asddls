@EndUserText.label: 'Travel'
@ObjectModel.query.implementedBy:'ABAP:Z230CL_DMO_TRAVEL_CQ' 
define custom entity z230i_dmo_travel_c_c
{
  key travel_id                 : abap.numc( 8 );
      agency_id                 : abap.numc( 8 );
      agency_id_text            : abap.char( 25 );
      customer_id               : abap.numc( 8 );
      customer_id_text          : abap.char( 25 );
      flight_date               : rap_cp_odata_v2_edm_datetime;
      @Semantics.amount.currencyCode: 'currency_code'
      total_price               : abap.curr( 15, 2 );
      currency_code             : abap.cuky;

      discount_pct              : abap.dec( 3, 1 );
      @Semantics.amount.currencyCode: 'currency_code'
      discount_abs              : abap.dec( 16, 3 );
      @Semantics.amount.currencyCode: 'currency_code'
      total_price_with_discount : abap.dec(17,2);
      calculated_etag           : abap.string( 0 );
}
