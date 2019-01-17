data test;
	/* Streaminit fixes the Random Stream */
	call streaminit(2);

	do i=1 to 10000;
		age=rand('table', 0.1, 0.2, 0.3, 0.2, 0.1, 0.1);
		output;
	end;
run;

proc freq data=test;
	tables age;
run;