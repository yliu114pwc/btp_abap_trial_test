@EndUserText.label: 'bp'
@ObjectModel.query.implementedBy:'ABAP:ZCL_230_DMO_BP' 
define custom entity zi_230_dmo_bp
{
  key BusinessPartner : abap.char( 10 );
      StreetName      : abap.string;
      CityName        : abap.string;
      PostalCode      : abap.string;
      PlanMode        : abap.char( 1 );
}
