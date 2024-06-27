/*In this file, mitopooled is named "mixedmarkers" (name outputs) or "Mito" (variable name)*/


/*********************************************************************************************************/

/*Import data mixed markers*/
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	Sheet="MergedMarkers_percent";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);
/**********************************************************************************************/

/*MODEL 1:   Compare mitochondrial markers before pooled analysis*/
ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model1_Mixedmarkers_Compare_markers_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=Work.Import nobound METHOD=rspl; 
	class Study_nr Subject_group_nr MitoMarker;
	weight Mito_inverse_VAR_LOG;
	model Mito_change_factor_log=MitoMarker/
		noint ddfm=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1;
	lsmeans MitoMarker/ plots=meanplot OBSMARGINS cl pdiff=all adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model1_Mixedmarkers_24 pred=p resid=r;
run;
ODS RTF CLOSE;

/*************************************************************************************************/
/*    Model 2: FIXED effects model on mixed markers raw data   */
ODS rtf FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model2_Mixedmarkers_fixed effect model_raw_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=Work.Import nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2;
	model Mito_percent_change=Training_type_new2 /
		noint DDFM=satterthwaite solution cl alpha=0.05;
	lsmeans Training_type_new2 / plots=meanplot OBSMARGINS cl pdiff=all adjust=bon stepdown adjdfe=row;
	/*generate output data*/
output out=Model2_FixedEffectModelraw_24 pred=p resid=r;
RUN;
ODS rtf CLOSE;

/*******************************************************************************************************/

/*Datastep creating log-transformed weeks and sessions per week*/
data want;
set Work.Import;
Weeks_log = log(Weeks);
Hours_week_log = log(Hours_week);
Sessions_week_avg_log = log(Sessions_week_avg);
run;


/******************************************************************************************/
/*Model 3- Mixed markers main analysis*/

ODS rtf FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model3_Mixedmarkers_mainAnalysis_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=Want nobound METHOD=rspl plots=residualpanel plots=studentpanel; 
	class Study_nr Subject_group_nr Mitomarker Training_type_new2 Status2 
		large_small_muscle (ref="0") disease_simple (ref="0") Sex Age_category2 (ref="0");
	weight Mito_inverse_VAR_LOG;
	model Mito_change_factor_log=Training_type_new2 Status2 Weeks_log*Training_type_new2 Sessions_week_avg_log 
	large_small_muscle disease_simple Sex Age_category2 /
		noint DDFM=satterthwaite solution cl alpha=0.05 ;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	random Mitomarker;
	parms 1 1 1 1;
	lsmeans Training_type_new2 Status2 /*Sessions_week_over_3*/ 
	large_small_muscle disease_simple sex Age_category2 / plots=meanplot OBSMARGINS E cl pdiff=all adjust=bon stepdown adjdfe=row;
	Estimate
		"Men-women"
		Sex 1 -1 0/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;
/*Estimates changes at given weeks, isolated for each intensity*/
/*Notes for understanding: th weighting coefficients for categorical variables are
the fractions of the dataset. These coefficients are extracted manually from the 
OBSMARGINS option within the lsmeans statement. 
The log-transformed linear effects (weeks, and sessions per week) have coefficients=ln(weeks or sessions)  */
	Estimate
		"SIT",
		"SIT 1 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 2 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.693147180559945 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 3 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 1.09861228866811 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 4 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 1.38629436111989 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 5 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 1.6094379124341 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 6 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 1.79175946922805 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 7 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 1.94591014905531 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 8 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 2.07944154167984 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 9 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 2.19722457733622 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 10 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 2.30258509299405 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"SIT 11 week"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 2.39789527279837 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT",
		"HIT 1 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 2 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0.693147180559945 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 3 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 1.09861228866811 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 4 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 1.38629436111989 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 5 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 1.6094379124341 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 6 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 1.79175946922805 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 7 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 1.94591014905531 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 8 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 2.07944154167984 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 9 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 2.19722457733622 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 10 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 2.30258509299405 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 11 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 2.39789527279837 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 12 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 2.484906649788 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"HIT 13 week"
		Training_type_new2 0 1 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 2.56494935746154 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET",
		"ET 1 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 0 
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 2 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 0.693147180559945
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 3 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 1.09861228866811
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 4 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 1.38629436111989
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 5 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 1.6094379124341
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 6 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 1.79175946922805
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 7 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 1.94591014905531
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 8 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.07944154167984
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 9 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.19722457733622
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 10 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.30258509299405
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 11 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.39789527279837
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 12 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.484906649788
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 13 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.56494935746154
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 14 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.63905733
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 15 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.708050201
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 16 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.772588722
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 17 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.833213344
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 18 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.890371758
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 19 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.944438979
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 20 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 2.995732274
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 21 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 3.044522438
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 22 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 3.091042453
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		
		"ET 23 week"
		Training_type_new2 0 0 1
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 3.135494216
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008/ cl alpha=0.05;

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
		Training_type_new2 0.1517 0.34 0.5083
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.105150427 0.235670041 0.352326712
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		"From 2-6 weeks"
		Weeks_log*Training_type_new2 0.166659484 0.373528178 0.558424626,
		"From 2-10 weeks"
		Weeks_log*Training_type_new2 0.244151731 0.54720889 0.818077291,
		"From 6-10 weeks"
		Weeks_log*Training_type_new2 0.077492247 0.173680712 0.259652665
	/ADJUSt=bon stepdown cl alpha=0.05 adjdfe=row;	

/*SIT change between weeks (coefficient are  ln(week)-ln(week))*/
	Estimate
		"SIT From 0-2 weeks"
		Training_type_new2 1 0 0
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.693147181 0 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
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
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0.693147181 0
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
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
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0 0 0.693147181
		Sessions_week_avg_log 1.3135
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
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



	
/*Impact of sessions per week*/		
	Estimate
		"Impact of sessions",
		"1 session/week"
		Training_type_new2 0.1517 0.34 0.5083
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.285 0.6389 0.9551
		Sessions_week_avg_log 0
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		"2 sessions/week"
		Training_type_new2 0.1517 0.34 0.5083
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.285 0.6389 0.9551
		Sessions_week_avg_log 0.693147180559945
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		"3 sessions/week"
		Training_type_new2 0.1517 0.34 0.5083
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.285 0.6389 0.9551
		Sessions_week_avg_log 1.09861228866811
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		"4 sessions/week"
		Training_type_new2 0.1517 0.34 0.5083
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.285 0.6389 0.9551
		Sessions_week_avg_log 1.386294361
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		"5 sessions/week"
		Training_type_new2 0.1517 0.34 0.5083
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.285 0.6389 0.9551
		Sessions_week_avg_log 1.609437912
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008,
		"6 sessions/week"
		Training_type_new2 0.1517 0.34 0.5083
		Status2 0.6189 0.2702 0.1109
		Weeks_log*Training_type_new2 0.285 0.6389 0.9551
		Sessions_week_avg_log 1.791759469
		large_small_muscle 0.1086 0.8914
		disease_simple 0.2116 0.7884
		Sex 0.6711 0.0921 0.2368
		Age_category2 0.1693 0.1299 0.7008/ cl alpha=0.05;
		
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
output out=Model3_MixedmarkersMain_24 pred=p resid=r;
RUN;
ODS rtf CLOSE;


/*********************************************************************************************************/
/*DISEASE groups   model4  */

/*Import filtered data with only untrained subjects, and only young/old*/
%web_drop_table(IMPORT_Disease);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_Disease;
	Sheet="MergedMarkers_untrained_Y&O";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_Disease; RUN;
%web_open_table(IMPORT_Disease);

/*Datastep creating log-transformed weeks and sessions per week*/
data IMPORT_Disease_log;
set IMPORT_Disease;
Weeks_log = log(Weeks);
Sessions_week_avg_log = log(Sessions_week_avg);
run;



ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model4_Mixedmarkers_DiseaseXage_june24.rtf' STYLE= minimal;
options orientation=landscape;
/*MODEL disease*age*/
proc GLIMMIX data=IMPORT_Disease_log nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Mitomarker Training_type_new2 Disease_USE Age_category2 ;
	weight Mito_inverse_VAR_LOG;
	model Mito_change_factor_log=Training_type_new2 Weeks_log*Training_type_new2 Sessions_week_avg_log Disease_USE*Age_category2/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	random Mitomarker;
	parms 1 1 1 1;
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
output out=Model4_Mixedmarkers_disease_24 pred=p resid=r;
run;
ODS RTF CLOSE;

/*********************************************************************************************************/
/*SEX x age model5*/

/*Import of new data sheet including only untrained, young/old, only healthy and no mixed sex groups*/
%web_drop_table(Import_sex);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_sex;
	Sheet="Merged_untrained_Y&O_M&F_health";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_sex; RUN;
%web_open_table(IMPORT_sex);
 
 /*Datastep creating log-transformed weeks and sessions per week*/
data IMPORT_Sex_log;
set IMPORT_Sex;
Weeks_log = log(Weeks);
Sessions_week_avg_log = log(Sessions_week_avg);
run;


ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model5_Mixedmarkers_Sex_X_age_24.rtf' STYLE= minimal;
options orientation=landscape;
/*MODEL sex*age: treningsform x varighet*/
proc GLIMMIX data=IMPORT_Sex_log nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Mitomarker Training_type_new2 Disease_USE Sex Age_category2 ;
	weight Mito_inverse_VAR_LOG;
	model Mito_change_factor_log=Training_type_new2 Weeks_log*Training_type_new2 Sessions_week_avg_log Sex*Age_category2/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	random Mitomarker;
	parms 1 1 1 1;
	lsmeans Sex*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
	lsmeans Training_type_new2/ plots=meanplot OBSMARGINS cl;
	output out=Model5_Mixedmarkers_sexage_24 pred=p resid=r;
run;
ODS RTF CLOSE;

 
/*********************************************************************************************************/




/*    MODEL 6 - training status x training intensity - per hour  */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model6_Mixedmarkers_perhour_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=Work.Import nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Mitomarker Status2 Training_type_new2;
	weight Mito_inverse_VAR_LOG;
	model Mito_efficiency_log=Status2*Training_type_new2/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	random Mitomarker;
	parms 1 1 1 1;
	lsmeans Status2*Training_type_new2/ plots=meanplot OBSMARGINS cl;
	Estimate 
	"Mean SIT, weighted by group size"
		Status2*Training_type_new2 			0.2549 0 0   
											0.4921 0 0   
											0.2529 0 0,
	"Mean HIT, weighted by group size"
		Status2*Training_type_new2 			0 0.5854 0   
											0 0.2685 0
											0 0.1461 0,

	"Mean ET, weighted by group size"
		Status2*Training_type_new2 			0 0 0.738   
											0 0 0.1975   
											0 0 0.0645/cl alpha=0.05;
											
	Estimate 
	"Difference SIT - HIT, weighted"
		Status2*Training_type_new2 			0.2549 -0.5854 0   
											0.4921 -0.2685 0   
											0.2529 -0.1461 0,
	"Difference SIT - ET, weighted"
		Status2*Training_type_new2 			0.2549 0 -0.738   
											0.4921 0 -0.1975   
											0.2529 0 -0.0645,									
	"Difference HIT - ET, weighted"
		Status2*Training_type_new2 			0 0.5854 -0.738   
											0 0.2685 -0.1975
											0 0.1461 -0.0645/ADJUST=bon stepdown cl alpha=0.05 adjdfe=row;

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
output out=Model6_Mixedmarkers_perhour_24 pred=p resid=r;
run;
ODS RTF CLOSE;
