 /* Create some test data with Negative values */
data negative;
 a=1;
 b=-1;
 c=0;
 output;
 a=-1;
 b=1;
 c=2;
 output;
 a=3;
 b=1;
 c=-1;
 output;
 run;
 proc print;
 run;
 
 /* Convert test data to 0 */
 /* https://blogs.sas.com/content/sastraining/2017/06/27/how-to-perform-an-operation-on-all-numeric-or-all-character-variables-in-a-sas-data-set/ */ 
 data modified;
  set negative;
  array Nums  {*}  _numeric_;
  do i=1 to dim(Nums);
  if Nums[i] lt 0 then Nums[i}=0;
  end;
  drop i;
 run;
 
 proc print;
 run;