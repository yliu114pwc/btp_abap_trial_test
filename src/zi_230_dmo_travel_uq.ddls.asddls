@EndUserText.label: 'travel - unmanaged query'
@ObjectModel.query.implementedBy:'ABAP:ZCL_230_DMO_TRAVEL_UQ' 
define custom entity zi_230_dmo_travel_uq
{
  key travel_id       : abap.numc( 8 );
      agency_id       : abap.numc( 6 );
      customer_id     : abap.numc( 6 );
      begin_date      : abap.dats;
      end_date        : abap.dats;
      booking_fee     : abap.dec( 17, 3 );
      total_price     : abap.dec( 17, 3 );
      currency_code   : abap.cuky;
      status          : abap.char( 1 );
}
