


/*********************************************************************************************************/

/*Import data CS*/
%web_drop_table(WORK.IMPORT_CS);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT_CS;
	Sheet="Meta_muscle_adapt_Data";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT_CS; RUN;
%web_open_table(WORK.IMPORT_CS);
/**********************************************************************************************/

/*    Model 2: FIXED effects model on CS raw data   */
ODS rtf FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model2_CS_fixed effect model_raw_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=WORK.IMPORT_CS nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2;
	model CS_percent_change=Training_type_new2 /
		noint DDFM=satterthwaite solution cl alpha=0.05;
	lsmeans Training_type_new2 / plots=meanplot OBSMARGINS cl pdiff=all adjust=bon stepdown adjdfe=row;
	/*generate output data*/
output out=Model2_CS_Fixed_raw_24 pred=p resid=r;
RUN;
ODS rtf CLOSE;

/*******************************************************************************************************/

/*Datastep creating log-transformed weeks and sessions per week*/
data IMPORT_CS_log;
set WORK.IMPORT_CS;
Weeks_log = log(Weeks);
Hours_week_log = log(Hours_week);
Sessions_week_avg_log = log(Sessions_week_avg);
run;

/*******************************************************************************************************/

/*check of some data*/

proc means data=IMPORT_CS_log Q1 mean  P10 P90 max;
class training_type_new2;
var weeks weeks_log;
run;

proc means data=IMPORT_CS_log Q1 Q3 P5 P10 P90 max;
var weeks weeks_log sessions_week_avg;
run;

proc univariate data=IMPORT_CS_log;
class training_type_new2;
var weeks;
histogram/  midpoints=1.1 to 52 by 2;
run;

proc univariate data=IMPORT_CS_log;
var sessions_week_avg;
histogram/  endpoints=0.1 1.1 2.1 3.1 4.1 5.1 6.1 7.1 8.1 9.1 10.1 11.1 12.1 13.1 14.1;
run;

Proc univariate data=IMPORT_CS_log normaltest;
var Weeks;
by Training_type_new2;
histogram;
run;


/******************************************************************************************/
/*Model 3- CS main analysis*/

ODS rtf FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model3_CS_mainAnalysis_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_CS_log nobound METHOD=rspl plots=residualpanel plots=studentpanel; 
	class Study_nr Subject_group_nr Training_type_new2 Status2 large_small_muscle (ref="0")
		disease_simple (ref="0") Sex Age_category2 (ref="0") CS_Enzyme_Analysis_type;
	weight CS_inverse_VAR_LOG;
	model CS_change_factor_log=Training_type_new2 Status2 Weeks_log*Training_type_new2 Sessions_week_avg_log large_small_muscle
	disease_simple Sex Age_category2 CS_Enzyme_Analysis_type/
		noint DDFM=satterthwaite solution cl alpha=0.05 ;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Training_type_new2 Status2 large_small_muscle
	disease_simple sex Age_category2 CS_Enzyme_Analysis_type/ plots=meanplot OBSMARGINS E cl pdiff=all adjust=bon stepdown adjdfe=row;
	Estimate
		"Men-women"
		Sex 1 -1 0/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
/*Estimates changes at given weeks, isolated for each intensity*/
/*Notes for understanding: the weighting coefficients for categorical variables are
the fractions of the dataset. These coefficients are extracted manually from the 
OBSMARGINS option within the lsmeans statement. 
The log-transformed linear effects (weeks, and sessions per week) have coefficients=ln(weeks or sessions)  */
	Estimate
		"SIT",
		"SIT 1 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
		CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 2 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.693147180559945 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 3 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 1.09861228866811 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 4 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 1.38629436111989 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 5 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 1.6094379124341 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 6 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 1.79175946922805 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 7 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 1.94591014905531 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 8 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 2.07944154167984 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 9 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 2.19722457733622 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 10 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 2.30258509299405 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"SIT 11 week"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 2.39789527279837 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT",
		"HIT 1 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 2 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0.693147180559945 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 3 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 1.09861228866811 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 4 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 1.38629436111989 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 5 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 1.6094379124341 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 6 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 1.79175946922805 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 7 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 1.94591014905531 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 8 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 2.07944154167984 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 9 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 2.19722457733622 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 10 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 2.30258509299405 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 11 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 2.39789527279837 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 12 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 2.484906649788 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 13 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 2.56494935746154 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"HIT 14 week"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 2.63905733 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET",
		"ET 1 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 0 
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 2 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 0.693147180559945
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 3 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 1.09861228866811
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 4 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 1.38629436111989
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 5 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 1.6094379124341
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 6 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 1.79175946922805
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 7 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 1.94591014905531
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 8 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.07944154167984
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 9 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.19722457733622
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 10 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.30258509299405
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 11 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.39789527279837
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 12 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.484906649788
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 13 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.56494935746154
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 14 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.63905733
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 15 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.708050201
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 16 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.772588722
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 17 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.833213344
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 18 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.890371758
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 19 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.944438979
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 20 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 2.995732274
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 21 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 3.044522438
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 22 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 3.091042453
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 23 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 3.135494216
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 24 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 3.17805383
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 25 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 3.218875825
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"ET 26 week"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 3.258096538
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943/ cl alpha=0.05;

/*Estimates differences between intensities at given weeks*/		
	Estimate
		"SIT-ET @2weeks"
		Training_type_new2 1 0 -1
		Weeks_log*Training_type_new2 0.693147180559945 0 -0.693147180559945,
		"SIT-HIT @2weeks"
		Training_type_new2 1 -1 0
		Weeks_log*Training_type_new2 0.693147180559945 -0.693147180559945 0,
		"HIT-ET @2weeks"
		Training_type_new2 0 1 -1
		Weeks_log*Training_type_new2 0 0.693147180559945 -0.693147180559945
		/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;

	Estimate
		"SIT-ET @6weeks"
		Training_type_new2 1 0 -1
		Weeks_log*Training_type_new2 1.79175946922805 0 -1.79175946922805,
		"SIT-HIT @6weeks"
		Training_type_new2 1 -1 0
		Weeks_log*Training_type_new2 1.79175946922805 -1.79175946922805 0,
		"HIT-ET @6weeks"
		Training_type_new2 0 1 -1
		Weeks_log*Training_type_new2 0 1.79175946922805 -1.79175946922805
		/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
		
	Estimate
		"SIT-ET @10weeks"
		Training_type_new2 1 0 -1
		Weeks_log*Training_type_new2 2.30258509299405 0 -2.30258509299405,
		"SIT-HIT @10weeks"
		Training_type_new2 1 -1 0
		Weeks_log*Training_type_new2 2.30258509299405 -2.30258509299405 0,
		"HIT-ET @10weeks"
		Training_type_new2 0 1 -1
		Weeks_log*Training_type_new2 0 2.30258509299405 -2.30258509299405
		/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;

/*Mean change between weeks (coefficient are weighted by fraction of dataset and is ln(week)-ln(week))*/
	Estimate
		"From 0-2 weeks"
		Training_type_new2 0.1599 0.3737 0.4665
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.110834234171535 0.259029101375252 0.323353159731214
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		"From 2-6 weeks"
		Weeks_log*Training_type_new2 0.175668104958031 0.410551412275273 0.512502632663673,
		"From 2-10 weeks"
		Weeks_log*Training_type_new2 0.257349122198213 0.601446947876623 0.750802786150508,
		"From 6-10 weeks"
		Weeks_log*Training_type_new2 0.0816810172401819 0.190895535601351 0.238300153486835
	/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;	

/*SIT change between weeks (coefficient are  ln(week)-ln(week))*/
	Estimate
		"SIT From 0-2 weeks"
		Training_type_new2 1 0 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.693147181 0 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		"SIT From 2-6 weeks"
		Weeks_log*Training_type_new2 1.098612289 0 0,
		"SIT From 2-10 weeks"
		Weeks_log*Training_type_new2 1.609437912 0 0,
		"SIT From 6-10 weeks"
		Weeks_log*Training_type_new2 0.510825624 0 0
	/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;	
/*HIT change between weeks (coefficient are  ln(week)-ln(week))*/
	Estimate
		"HIT From 0-2 weeks"
		Training_type_new2 0 1 0
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0.693147181 0
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		"HIT From 2-6 weeks"
		Weeks_log*Training_type_new2 0 1.098612289 0,
		"HIT From 2-10 weeks"
		Weeks_log*Training_type_new2 0 1.609437912 0,
		"HIT From 6-10 weeks"
		Weeks_log*Training_type_new2 0 0.510825624 0
	/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
/*ET change between weeks (coefficient are  ln(week)-ln(week))*/
	Estimate
		"ET From 0-2 weeks"
		Training_type_new2 0 0 1
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0 0 0.693147181
		Sessions_week_avg_log 1.3075
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		"ET From 2-6 weeks"
		Weeks_log*Training_type_new2 0 0 1.098612289,
		"ET From 2-10 weeks"
		Weeks_log*Training_type_new2 0 0 1.609437912,
		"ET From 6-10 weeks"
		Weeks_log*Training_type_new2 0 0 0.510825624
	/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
	
/*Estimates differences between intensities in change between weeks specified */
	Estimate
		"SIT-ET from 2wk to 6wk"
		Weeks_log*Training_type_new2 1.098612289 0 -1.098612289,
		"SIT-HIT from 2wk to 6wk"
		Weeks_log*Training_type_new2 1.098612289 -1.098612289 0,
		"HIT-ET from 2wk to 6wk"
		Weeks_log*Training_type_new2 0 1.098612289 -1.098612289
		/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"SIT-ET from 2wk to 10wk"
		Weeks_log*Training_type_new2 1.6094379124341 0 -1.6094379124341,
		"SIT-HIT from 2wk to 10wk"
		Weeks_log*Training_type_new2 1.6094379124341 -1.6094379124341 0,
		"HIT-ET from 2wk to 10wk"
		Weeks_log*Training_type_new2 0 1.6094379124341 -1.6094379124341
		/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"SIT-ET from 6wk to 10wk"
		Weeks_log*Training_type_new2 0.510825624 0 -0.510825624,
		"SIT-HIT from 6wk to 10wk"
		Weeks_log*Training_type_new2 0.510825624 -0.510825624 0,
		"HIT-ET from 6wk to 10wk"
		Weeks_log*Training_type_new2 0 0.510825624 -0.510825624
		/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;


	
/*Impact of sessions per week coefficients from printed E LSMEANS */
	Estimate
		"Impact of sessions",
		"1 session/week"
		Training_type_new2 0.1599 0.3736 0.4665 
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.2952 0.6900 0.8613
		Sessions_week_avg_log 0
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
		CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"2 sessions/week"
		Training_type_new2 0.1599 0.3736 0.4665
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.2952 0.6900 0.8613
		Sessions_week_avg_log 0.693147180559945
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
		CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
	
		"3 sessions/week"
		Training_type_new2 0.1599 0.3737 0.4665
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.2952 0.6900 0.8613
		Sessions_week_avg_log 1.09861228866811
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"4 sessions/week"
		Training_type_new2 0.1599 0.3737 0.4665
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.2952 0.6900 0.8613
		Sessions_week_avg_log 1.386294361
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"5 sessions/week"
		Training_type_new2 0.1599 0.3737 0.4665
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.2952 0.6900 0.8613
		Sessions_week_avg_log 1.609437912
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943,
		
		"6 sessions/week"
		Training_type_new2 0.1599 0.3737 0.4665
		Status2 0.5833 0.2900 0.1267
		Weeks_log*Training_type_new2 0.2952 0.6900 0.8613
		Sessions_week_avg_log 1.791759469
		large_small_muscle 0.1352 0.8648
		disease_simple 0.2177 0.7823
		Sex 0.6575 0.094 0.2485 
CS_Enzyme_Analysis_type 0.1109 0.8891
		Age_category2 0.1659 0.1398 0.6943/ cl alpha=0.05;

	
/*Differences between levels of training frequency*/
	Estimate
	"4-2 sessions/week"
	Sessions_week_avg_log 0.693147181,
	"6-4 sessions/week"
	Sessions_week_avg_log 0.405465108,
	"6-2 sessions/week"
	Sessions_week_avg_log 1.098612289	
	/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
/*generate output data*/
output out=Model3_CSMain_24 pred=p resid=r;
RUN;
ODS rtf CLOSE;


/*********************************************************************************************************/
/*DISEASE groups   model 4  */

/*Import filtered data with only untrained subjects, and only young/old*/
%web_drop_table(IMPORT_CS_Disease);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_CS_Disease;
	Sheet="Meta_muscle_adapt_untrained_O&Y";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_CS_Disease; RUN;
%web_open_table(IMPORT_CS_Disease);

/*Datastep creating log-transformed weeks and sessions per week*/
data IMPORT_CS_Disease_log;
set IMPORT_CS_Disease;
Weeks_log = log(Weeks);
Sessions_week_avg_log = log(Sessions_week_avg);
run;



ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model4_CS_DiseaseXage_june24.rtf' STYLE= minimal;
options orientation=landscape;
/*MODEL disease*age*/
proc GLIMMIX data=IMPORT_CS_Disease_log nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Disease_USE Age_category2 ;
	weight CS_inverse_VAR_LOG;
	model CS_change_factor_log=Training_type_new2 Weeks_log*Training_type_new2 Sessions_week_avg_log Disease_USE*Age_category2/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Disease_USE*Age_category2/ plots=meanplot OBSMARGINS cl pdiff=control adjust=bon stepdown adjdfe=row;
	lsmeans Training_type_new2/ plots=meanplot OBSMARGINS cl;
	Estimate "HealthyYoung - HealthyOld  -  MetabolicYoung   -  MetabolicOld  -   CVDOld   -  COPDOld (order coding)";
	Estimate
		"Young, metabolic-healthy"
		Disease_USE*Age_category2 -1 0 1 0 0 0
		/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"Old, metabolic-healthy"
		Disease_USE*Age_category2 0 -1 0 1 0 0,
		"Old, CVD-healthy"
		Disease_USE*Age_category2 0 -1 0 0 1 0,
		"Old, COPD-healthy"
		Disease_USE*Age_category2 0 -1 0 0 0 1
		/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row; 
/*generate output data*/
output out=Model4_CS_disease_24 pred=p resid=r;
run;
ODS RTF CLOSE;

/*********************************************************************************************************/
/*SEX x age Model5*/

/*Import of new data sheet including only untrained, young/old, only healthy and no mixed sex groups*/
%web_drop_table(IMPORT_CS_sex);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_CS_sex;
	Sheet="Meta_untr_O&Y_healthy_sex";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_CS_sex; RUN;
%web_open_table(IMPORT_CS_sex);
 
 /*Datastep creating log-transformed weeks and sessions per week*/
data IMPORT_CS_sex_log;
set IMPORT_CS_sex;
Weeks_log = log(Weeks);
Sessions_week_avg_log = log(Sessions_week_avg);
run;


ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model5_CS_Sex_X_age_24.rtf' STYLE= minimal;
options orientation=landscape;
/*MODEL sex*age: treningsform x varighet*/
proc GLIMMIX data=IMPORT_CS_sex_log nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Disease_USE Sex Age_category2 ;
	weight CS_inverse_VAR_LOG;
	model CS_change_factor_log=Training_type_new2 Weeks_log*Training_type_new2 Sessions_week_avg_log Sex*Age_category2/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Sex*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
	lsmeans Training_type_new2/ plots=meanplot OBSMARGINS cl;
	output out=Model5_CS_sexage_24 pred=p resid=r;
run;
ODS RTF CLOSE;

 
/*********************************************************************************************************/




/*    MODEL 6 - training status x training intensity - per hour  */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model6_CS_perhour_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_CS_log nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Status2 Training_type_new2;
	weight CS_inverse_VAR_LOG;
	model CS_efficiency_log =Status2*Training_type_new2/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Status2*Training_type_new2/ plots=meanplot E OBSMARGINS cl;
	Estimate 
	"Mean SIT, weighted by group size"
		Status2*Training_type_new2 			0.2011 0 0   
											0.518 0 0   
											0.2809 0 0,
		"Mean HIT, weighted by group size"
		Status2*Training_type_new2 			0 0.5772 0   
											0 0.275 0
											0 0.1478 0,

		"Mean ET, weighted by group size"
		Status2*Training_type_new2 			0 0 0.7037   
											0 0 0.2147   
											0 0 0.0816/cl alpha=0.05;
											
	Estimate 
		"Difference SIT - HIT, weighted"
		Status2*Training_type_new2 			0.2011 -0.5772 0   
											0.518 -0.275 0   
											0.2809 -0.1478 0,
		"Difference SIT - ET, weighted"
		Status2*Training_type_new2 			0.2011 0 -0.7037   
											0.518 0 -0.2147   
											0.2809 0 -0.0816,									
		"Difference HIT - ET, weighted"
		Status2*Training_type_new2 			0 0.5772 -0.7037   
											0 0.275 -0.2147
											0 0.1478 -0.0816/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;


	Estimate
		"Difference Untrained - Mod-Trained SIT"
		Status2*Training_type_new2 			1 0 0   
										-1 0 0   
										0 0 0,
		"Difference Untrained - Well-Trained SIT"
		Status2*Training_type_new2 			1 0 0   
										0 0 0   
										-1 0 0,
		"Difference Mod-Trained - Well-Trained SIT"
		Status2*Training_type_new2 			0 0 0   
										1 0 0   
										-1 0 0,
		"Difference Untrained - Mod-Trained HIT"
		Status2*Training_type_new2 			0 1 0   
										0 -1 0   
										0 0 0,
		"Difference Untrained - Well-Trained HIT"
		Status2*Training_type_new2 			0 1 0   
										0 0 0   
										0 -1 0,
		"Difference Mod-Trained - Well-Trained HIT"
		Status2*Training_type_new2 			0 0 0   
										0 1 0   
										0 -1 0,
		"Difference Untrained - Mod-Trained ET"
		Status2*Training_type_new2 			0 0 1   
										0 0 -1   
										0 0 0,
		"Difference Untrained - Well-Trained ET"
		Status2*Training_type_new2 			0 0 1   
										0 0 0   
										0 0 -1,
		"Difference Mod-Trained - Well-Trained ET"
		Status2*Training_type_new2 			0 0 0   
										0 0 1   
										0 0 -1/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"Difference Untrained - Mod-Trained SIT"
		Status2*Training_type_new2 			1 0 0   
										-1 0 0   
										0 0 0,
		"Difference Untrained - Well-Trained SIT"
		Status2*Training_type_new2 			1 0 0   
										0 0 0   
										-1 0 0,
		"Difference Mod-Trained - Well-Trained SIT"
		Status2*Training_type_new2 			0 0 0   
										1 0 0   
										-1 0 0/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"Difference Untrained - Mod-Trained HIT"
		Status2*Training_type_new2 			0 1 0   
										0 -1 0   
										0 0 0,
		"Difference Untrained - Well-Trained HIT"
		Status2*Training_type_new2 			0 1 0   
										0 0 0   
										0 -1 0,
		"Difference Mod-Trained - Well-Trained HIT"
		Status2*Training_type_new2 			0 0 0   
										0 1 0   
										0 -1 0/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"Difference Untrained - Mod-Trained ET"
		Status2*Training_type_new2 			0 0 1   
										0 0 -1   
										0 0 0,
		"Difference Untrained - Well-Trained ET"
		Status2*Training_type_new2 			0 0 1   
										0 0 0   
										0 0 -1,
		"Difference Mod-Trained - Well-Trained ET"
		Status2*Training_type_new2 			0 0 0   
										0 0 1   
										0 0 -1/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"Difference SIT - HIT, non-weighted"
		Status2*Training_type_new2 			0.333 -0.333 0   
										0.333 -0.333 0   
										0.333 -0.333 0,
		"Difference SIT - ET, non-weighted"
		Status2*Training_type_new2 			0.333 0 -0.333  
										0.333 0 -0.333
										0.333 0 -0.333,   
		"Difference HIT - ET, non-weighted"
		Status2*Training_type_new2 			0 0.333 -0.333  
										0 0.333 -0.333   
										0 0.333 -0.333/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"Difference Untrained SIT - HIT"
		Status2*Training_type_new2			1 -1 0   
										0 0 0  
										0 0 0,
		"Difference Untrained SIT - ET"
		Status2*Training_type_new2 			1 0 -1   
										0 0 0  
										0 0 0,   
		"Difference Untrained HIT - ET"
		Status2*Training_type_new2 			0 1 -1   
										0 0 0  
										0 0 0/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"Difference Mod-Trained SIT - HIT"
		Status2*Training_type_new2			0 0 0   
										1 -1 0  
										0 0 0,
		"Difference Mod-Trained SIT - ET"
		Status2*Training_type_new2 			0 0 0   
										1 0 -1  
										0 0 0,   
		"Difference Mod-Trained HIT - ET"
		Status2*Training_type_new2 			0 0 0   
										0 1 -1  
										0 0 0/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;
	Estimate
		"Difference Well-Trained SIT - HIT"
		Status2*Training_type_new2			0 0 0   
										0 0 0  
										1 -1 0,
		"Difference Well-Trained SIT - ET"
		Status2*Training_type_new2 			0 0 0   
										0 0 0  
										1 0 -1,   
		"Difference Well-Trained HIT - ET"
		Status2*Training_type_new2 			0 0 0   
										0 0 0  
										0 1 -1/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;
/*generate output data*/
output out=Model6_CS_perhour_24 pred=p resid=r;
run;
ODS RTF CLOSE;
