/* Deletes combined tables so are fresh on each run*/
proc delete data=work.estimates;
run;

proc delete data=work.statistics;
run;

/* Builds macro with required statements */
%macro hold(date);
	proc arima data=sashelp.air(where=(date lt "&date"d));
		/* noprint supresses printout */
		identify var=air noprint;

		/* hold_&date: Puts a label on the output tables */
		/* noprint supresses printout */
		hold_&date: estimate p=(1, 12) q=1 
			outest=est_&date outmodel=mod_&date outstat=stat_&date noprint;
		run;
	quit;

	/* Now combine all the output tables together - perhaps do a bit of post output tidy-up - just keep the model ESTIMATE */
	data est;
		set work.est_&date;

		if _type_='EST';
	run;

	proc append base=work.estimates data=est force;
	run;

	data stat;
		set work.stat_&date;

		if _stat_='AIC' /* or _stat_='SBC' */;
	run;

	proc append base=work.statistics data=stat force;
	run;

%mend hold;

/* Run for however many periods you want to go back */
%macro runme(n);
	%do i=1 %to &n;

		/* -1 makes it go back a month - notice im starting from the last record you could put this
		in a macro as well */
%let date=%sysfunc(intnx(month, '01Jan61'd, -&i.), date9.);

		/* Invoke ARIMA macro built above */
%hold(date=&date);

		/* Just write date to Log for checking */
%put &date.;
	%end;
%mend runme;

/* Invoke the Macro(s) - number is how many months back to go */
%runme(6);
title 'Parameter Estimates';

proc print data=estimates label noobs;
run;

title 'Statistics';

proc print data=statistics label noobs;
run;

title;