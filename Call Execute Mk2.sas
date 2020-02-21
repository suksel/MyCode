data x;
	x=1;
run;

data _null_;
	if exist("work.x") then
		call execute("Proc delete data=work.x;run;");
run;