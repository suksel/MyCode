/* Location for final OECD table */
libname mylib "c:\data\OECD";

/* Just read an existing table and apply a FORMAt to an existing date field */
data pr_sales;
	set mylib.pr_sales;

	/* Attaches the format to the variable in the data set */
	format date_sas year.;
run;

/* Look at the FORMAT field */
proc contents data=pr_sales;
run;

proc print;
	/* Whatever format you use in the proc overrides what is attached in the DataSet */
	format date_sas yyq.;
run;

/* By default as you have a YEAR format on date_sas the output in a summary will be just the years
Uncomment the format statement and it will then summarise by quarter - look at the NOBS in the output
*/
proc means data=pr_sales;
	var gbr_allshares;
	class date_sas;
	output out=summary;
	*format date_sas yyq.;
run;

/* Add in Todays date */
data time_differences;
	set pr_sales;
	today=today();

	/* Todays date */
	diff=today-date_sas;
	format today date7. /*date_sas yyq. */;

	/* Note the format for today - applying a format to date_sas has no impact on the calculation of diff as the format just
	displays the values */
run;

/* The number of days for diff are for the actual number of the date whatever the format displayed */
proc print data=work.time_differences;
	var date date_sas diff;
	/* Applying the format has no impact as diff calculated in the data step */
	*format date_sas yyq.;
run;