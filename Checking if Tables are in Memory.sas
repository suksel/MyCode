cas;

proc cas;
	accessControl.assumeRole / adminRole="superuser";
	accessControl.accessPersonalCaslibs;
	table.caslibinfo result=casliblist / showHidden=true, verbose=true;

	do row over casliblist.caslibinfo;

		if substrn(row.Name, 1, 8)=="CASUSER(" then
			do;

				if (substrn(row.Name, 9, 4) !="sas." and substrn(row.Name, 9, 3) !="cas") 
					then
						do;
						print "Libname is: " !! row.Name;
						table.tableinfo result=tableList / caslib=row.Name;
						*describe tableList;

						if exists(tableList, "TableInfo") then
							do;

								do row over tableList.tableinfo;
									print "Table is : "  !! row.Name;
								end;
							end;
					end;
			end;
	end;
	run;