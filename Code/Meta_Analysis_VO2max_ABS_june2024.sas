

/*********************************************************************************************************/

/*Import data VO2max*/
%web_drop_table(WORK.IMPORT_VO2max);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT_VO2max;
	Sheet="Meta_muscle_adapt_Data_WholeBod";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT_VO2max; RUN;
%web_open_table(WORK.IMPORT_VO2max);
/**********************************************************************************************/

/*    Model 13: FIXED effects model on VO2max raw data   */
ODS rtf FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model13_VO2maxABS_fixed effect model_raw_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=WORK.IMPORT_VO2max nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2;
	model relVO2max_change_abs=Training_type_new2 /
		noint DDFM=satterthwaite solution cl alpha=0.05;
	lsmeans Training_type_new2 / plots=meanplot OBSMARGINS cl pdiff=all adjust=bon stepdown adjdfe=row;
	/*generate output data*/
output out=Model13_VO2maxABS_Fixed_raw_24 pred=p resid=r;
RUN;
ODS rtf CLOSE;

/*******************************************************************************************************/

/*Datastep creating log-transformed weeks and sessions per week*/
data IMPORT_VO2max_log;
set WORK.IMPORT_VO2max;
Weeks_log = log(Weeks);
Hours_week_log = log(Hours_week);
Sessions_week_avg_log = log(Sessions_week_avg);
run;

/*******************************************************************************************************/

/*check of some data*/

proc means data=IMPORT_VO2max_log Q1 mean  P10 P90 max;
class training_type_new2;
var weeks weeks_log;
run;

proc means data=IMPORT_VO2max_log Q1 Q3 P5 P10 P90 max;
var weeks weeks_log sessions_week_avg;
run;

proc univariate data=IMPORT_VO2max_log;
class training_type_new2;
var weeks;
histogram/  midpoints=1.1 to 52 by 2;
run;

proc univariate data=IMPORT_VO2max_log;
var sessions_week_avg;
histogram/  endpoints=0.1 1.1 2.1 3.1 4.1 5.1 6.1 7.1 8.1 9.1 10.1 11.1 12.1 13.1 14.1;
run;

Proc univariate data=IMPORT_VO2max_log normaltest;
var Weeks;
by Training_type_new2;
histogram;
run;


/******************************************************************************************/
/*Model 14- VO2max absolute main analysis*/

ODS rtf FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model14_VO2maxABS_mainAnalysis_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_VO2max_log nobound METHOD=rspl plots=residualpanel plots=studentpanel; 
	class Study_nr Subject_group_nr Training_type_new2 Status2 
		disease_simple (ref="0") Sex Age_category2 (ref="0");
	weight relVO2max_change_abs_inverse_VAR;
	model relVO2max_change_abs=Training_type_new2 Status2 Weeks_log*Training_type_new2 Sessions_week_avg_log 
	disease_simple Sex Age_category2 /
		noint DDFM=satterthwaite solution cl alpha=0.05 ;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Training_type_new2 Status2 
	disease_simple sex Age_category2 / plots=meanplot OBSMARGINS E cl pdiff=all adjust=bon stepdown adjdfe=row;
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
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 2 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.693147180559945 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 3 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 1.09861228866811 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 4 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 1.38629436111989 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 5 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 1.6094379124341 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 6 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 1.79175946922805 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 7 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 1.94591014905531 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 8 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 2.07944154167984 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 9 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 2.19722457733622 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 10 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 2.30258509299405 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"SIT 11 week"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 2.39789527279837 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT",
		"HIT 1 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 2 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0.693147180559945 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 3 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 1.09861228866811 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 4 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 1.38629436111989 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 5 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 1.6094379124341 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 6 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 1.79175946922805 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 7 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 1.94591014905531 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 8 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 2.07944154167984 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 9 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 2.19722457733622 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 10 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 2.30258509299405 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 11 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 2.39789527279837 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 12 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 2.484906649788 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 13 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 2.56494935746154 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"HIT 14 week"
		Training_type_new2 0 1 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 2.63905733 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET",
		"ET 1 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 0 
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 2 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 0.693147180559945
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 3 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 1.09861228866811
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 4 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 1.38629436111989
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 5 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 1.6094379124341
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 6 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 1.79175946922805
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 7 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 1.94591014905531
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 8 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.07944154167984
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 9 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.19722457733622
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 10 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.30258509299405
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 11 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.39789527279837
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 12 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.484906649788
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 13 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.56494935746154
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 14 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.63905733
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 15 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.708050201
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 16 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.772588722
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 17 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.833213344
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 18 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.890371758
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 19 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.944438979
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 20 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 2.995732274
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 21 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 3.044522438
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 22 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 3.091042453
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 23 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 3.135494216
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 24 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 3.17805383
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 25 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 3.218875825
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"ET 26 week"
		Training_type_new2 0 0 1
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 3.258096538
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939/ cl alpha=0.05;

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
		Training_type_new2 0.1061 0.2765 0.6174
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.0735429158574102 0.191655195424825 0.42794906927771
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		"From 2-6 weeks"
		Weeks_log*Training_type_new2 0.116562763827686 0.303766297816732 0.678283227023691,
		"From 2-10 weeks"
		Weeks_log*Training_type_new2 0.170761362509258 0.445009582788029 0.993666967136814,
		"From 6-10 weeks"
		Weeks_log*Training_type_new2 0.0541985986815716 0.141243284971297 0.315383740113123
	/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;	

/*SIT change between weeks (coefficient are  ln(week)-ln(week))*/
	Estimate
		"SIT From 0-2 weeks"
		Training_type_new2 1 0 0
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.693147181 0 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
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
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0.693147181 0
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
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
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0 0 0.693147181
		Sessions_week_avg_log 1.3087
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
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
		Training_type_new2 0.1061 0.2765 0.6174 
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.2142 0.5583 1.2467
		Sessions_week_avg_log 0
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"2 sessions/week"
		Training_type_new2 0.1061 0.2765 0.6174
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.2142 0.5583 1.2467
		Sessions_week_avg_log 0.693147180559945
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
	
		"3 sessions/week"
		Training_type_new2 0.1061 0.2765 0.6174
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.2142 0.5583 1.2467
		Sessions_week_avg_log 1.09861228866811
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"4 sessions/week"
		Training_type_new2 0.1061 0.2765 0.6174
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.2142 0.5583 1.2467
		Sessions_week_avg_log 1.386294361
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"5 sessions/week"
		Training_type_new2 0.1061 0.2765 0.6174
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.2142 0.5583 1.2467
		Sessions_week_avg_log 1.609437912
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939,
		
		"6 sessions/week"
		Training_type_new2 0.1061 0.2765 0.6174
		Status2 0.7768 0.1613 0.0619
		Weeks_log*Training_type_new2 0.2142 0.5583 1.2467
		Sessions_week_avg_log 1.791759469
		disease_simple 0.3394 0.6606
		Sex 0.5484 0.1295 0.3221
		Age_category2 0.1962 0.3098 0.4939/ cl alpha=0.05;

	
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
output out=Model14_VO2maxABSMain_24 pred=p resid=r;
RUN;
ODS rtf CLOSE;


/*********************************************************************************************************/
/*DISEASE groups   model15  */

/*Import filtered data with only untrained subjects, and only young/old*/
%web_drop_table(IMPORT_VO2max_Disease);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_VO2max_Disease;
	Sheet="Meta_muscle_adapt_untrained_O&Y";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_VO2max_Disease; RUN;
%web_open_table(IMPORT_VO2max_Disease);

/*Datastep creating log-transformed weeks and sessions per week*/
data IMPORT_VO2max_Disease_log;
set IMPORT_VO2max_Disease;
Weeks_log = log(Weeks);
Sessions_week_avg_log = log(Sessions_week_avg);
run;



ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model15_VO2maxABS_DiseaseXage_june24.rtf' STYLE= minimal;
options orientation=landscape;
/*MODEL disease*age*/
proc GLIMMIX data=IMPORT_VO2max_Disease_log nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Disease_USE Age_category2 ;
	weight relVO2max_change_abs_inverse_VAR;
	model relVO2max_change_abs=Training_type_new2 Weeks_log*Training_type_new2 Sessions_week_avg_log Disease_USE*Age_category2/
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
output out=Model15_VO2maxABS_disease_24 pred=p resid=r;
run;
ODS RTF CLOSE;

/*********************************************************************************************************/
/*SEX x age model16*/

/*Import of new data sheet including only untrained, young/old, only healthy and no mixed sex groups*/
%web_drop_table(IMPORT_VO2max_sex);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_VO2max_sex;
	Sheet="Meta_untr_O&Y_healthy_sex";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_VO2max_sex; RUN;
%web_open_table(IMPORT_VO2max_sex);
 
 /*Datastep creating log-transformed weeks and sessions per week*/
data IMPORT_VO2max_sex_log;
set IMPORT_VO2max_sex;
Weeks_log = log(Weeks);
Sessions_week_avg_log = log(Sessions_week_avg);
run;


ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model16_VO2maxABS_Sex_X_age_24.rtf' STYLE= minimal;
options orientation=landscape;
/*MODEL sex*age: treningsform x varighet*/
proc GLIMMIX data=IMPORT_VO2max_sex_log nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Disease_USE Sex Age_category2 ;
	weight relVO2max_change_abs_inverse_VAR;
	model relVO2max_change_abs=Training_type_new2 Weeks_log*Training_type_new2 Sessions_week_avg_log Sex*Age_category2/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Sex*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
	lsmeans Training_type_new2/ plots=meanplot OBSMARGINS cl;
	output out=Model16_VO2maxABS_sexage_24 pred=p resid=r;
run;
ODS RTF CLOSE;

 
/*********************************************************************************************************/
