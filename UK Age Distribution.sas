data age_dist;
	/* Streaminit fixes the Random Stream */
	call streaminit(3);

	do i=1 to 100000;
		age=rand('table', 0.062357434, 0.055919037, 0.058111886, 0.037078826, 
			0.093933399, 0.068418129, 0.065695142, 0.066555511, 0.073098927, 
			0.073124553, 0.064228897, 0.056778657, 0.060224825, 0.04768823, 0.03885219, 
			0.031698941, 0.023860602, 0.022374812);
		output;
	end;
run;

proc format;
	value agedist 1="Age 0 to 4" 2="Age 5 to 9" 3="Age 10 to 14" 4="Age 15 to 17" 
		5="Age 18 to 24" 6="Age 25 to 29" 7="Age 30 to 34" 8="Age 35 to 39" 
		9="Age 40 to 44" 10="Age 45 to 49" 11="Age 50 to 54" 12="Age 55 to 59" 
		13="Age 60 to 64" 14="Age 65 to 69" 15="Age 70 to 74" 16="Age 75 to 79" 
		17="Age 80 to 84" 18="Age 85 and over";
run;

proc freq data=age_dist;
	tables age;
	format age agedist.;
run;