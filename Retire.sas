data pension;
  spd='21Jul2027'd;
  days_to_spd=spd-today();
  *years=days_to_spd/365;
  months=intck('month',today(),spd);
  years=intck('year',today(),spd);
  needed=months*5000;
  label spd='State Pension Day'
        years='Years'
        months='Months to SPD'
 
 ;
 format spd date7.;
 run;
 