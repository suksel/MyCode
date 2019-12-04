*****************************************************************************
* Version 1 - Reading data from Yahoo                                       *
*                                               Steve Ludlow - Dec 2018     *
* Needs fixing - setup for both Windows and Linux folders                   *
* Yahoo changed location again....                                          *
*****************************************************************************
;

 /* Temporary File used to input into URL */
filename in temp; 
 /* Output File used to create CSV - could get creative and use input values? */
filename out 'c:\temp\boe.csv';

 /* Sets up string to be passed to URL */
 /* Dates - seem a little strange - perhaps didnt like the Jan1 1960? */
data _null_; 
file in; 
input; 
put _infile_;
datalines4;
%5EFTSE?P=FTSE?period1=1542472804&period=1545064804&interval=1d&events=history&crumb=jGRD9olbLZ1N
;;;;
run;

 /* Simple HTTP call with string above passed to Proxy Server 
    Note proxy server and proxyport */
proc http url="https://query1.finance.yahoo.com/v7/finance/download/"
  in=in 
  out=out 
  method="post"
  proxyhost="inetgw.fyi.sas.com"
  proxyport=80
;
run;