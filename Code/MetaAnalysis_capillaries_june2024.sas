
/*********************************************************************************************************/

/*Import data capillaries*/
%web_drop_table(IMPORT_capillaries);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_capillaries;
	Sheet="Meta_muscle_adapt_Data";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_capillaries; RUN;
%web_open_table(IMPORT_capillaries);
/*********************************************************************************************************/


/*    MODEL 7 CF% - status + duration + modality   */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model7_CF_percent_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Status2 Weeks_thirds;
	weight CF_inverse_VAR_log;
	model CF_change_factor_log=Training_type_new2 Status2 Weeks_thirds/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Training_type_new2 Status2 Weeks_thirds/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model7_CF_percent_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/

/*    MODEL 7 CF_abs - status + duration + modality  */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model7_CF_abs_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Status2 Weeks_thirds;
	weight CF_change_abs_inverse_VAR;
	model CF_change_abs=Training_type_new2 Status2 Weeks_thirds/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Training_type_new2 Status2 Weeks_thirds/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model7_CF_abs_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/


/*    MODEL 8 CD% - status + duration + modality   */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model8_CD_percent_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Status2 Weeks_thirds;
	weight CD_inverse_VAR_log;
	model CD_change_factor_log=Training_type_new2 Status2 Weeks_thirds/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Training_type_new2 Status2 Weeks_thirds/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model8_CD_percent_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/




/*    MODEL 8 CD_abs - status + duration + modality  */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model8_CD_abs_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Status2 Weeks_thirds;
	weight CD_change_abs_inverse_VAR;
	model CD_change_abs=Training_type_new2 Status2 Weeks_thirds/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Training_type_new2 Status2 Weeks_thirds/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model8_CD_abs_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/

/*    MODEL 9 CSA% - status + duration + modality   */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model9_CSA_percent_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Status2 Weeks_thirds;
	weight CSA_inverse_VAR_log;
	model CSA_change_factor_log=Training_type_new2 Status2 Weeks_thirds/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Training_type_new2 Status2 Weeks_thirds/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model9_CSA_percent_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/

/*    MODEL 9 CSA_abs - status + duration + modality  */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model9_CSA_abs_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Training_type_new2 Status2 Weeks_thirds;
	weight CSA_change_abs_inverse_VAR;
	model CSA_change_abs=Training_type_new2 Status2 Weeks_thirds/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Training_type_new2 Status2 Weeks_thirds/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model9_CSA_abs_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/





/*    Import step for extra analysis age x disease  */
%web_drop_table(IMPORT_capillaries_AgeDisease);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_capillaries_AgeDisease;
	Sheet="CF_untrained_oldyoung";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_capillaries_AgeDisease; RUN;
%web_open_table(IMPORT_capillaries_AgeDisease);
/*********************************************************************************************************/


/*    MODEL 10 - capillary disease x age    */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model10_CF_DiseaseXage_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries_AgeDisease nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Disease_USE Age_category2 Weeks_thirds Sessions_week_over_3;
	weight CF_inverse_VAR_LOG;
	model CF_change_factor_log=Disease_USE*Age_category2 Weeks_thirds Sessions_week_over_3/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Disease_USE*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=control adjust=bon stepdown adjdfe=row;
	Estimate "HealthyYoung - HealthyOld  -  MetabolicYoung   -  MetabolicOld  -   CVDOld   -  COPDOld";
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
output out=Model10_CF_DiseaseXage_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/



/*    MODEL 10 - capillary disease x age -absolute   */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model10_CF_DiseaseXage_abs_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries_AgeDisease nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Disease_USE Age_category2 Weeks_thirds Sessions_week_over_3;
	weight CF_change_abs_inverse_VAR;
	model CF_change_abs=Disease_USE*Age_category2 Weeks_thirds Sessions_week_over_3/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Disease_USE*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=control adjust=bon stepdown adjdfe=row;
	Estimate "HealthyYoung - HealthyOld  -  MetabolicYoung   -  MetabolicOld  -   CVDOld   -  COPDOld";
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
output out=Model10_CF_DiseaseXage_abs_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/




/*    Import step for extra analysis age x sex  */



%web_drop_table(IMPORT_capillaries_AgeSex);
FILENAME REFFILE '/home/oyvindskattebo0/mastersheet.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=IMPORT_capillaries_AgeSex;
	Sheet="CF_untr_oldyoung_healthy_sex";
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=IMPORT_capillaries_AgeSex; RUN;
%web_open_table(IMPORT_capillaries_AgeSex);
/*********************************************************************************************************/


/*    MODEL 11 - capillary sex x age    */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model11_CF_SexXage_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries_AgeSex nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Sex Age_category2 Weeks_thirds Sessions_week_over_3;
	weight CF_inverse_VAR_LOG;
	model CF_change_factor_log=Sex*Age_category2 Weeks_thirds Sessions_week_over_3/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Sex*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
	lsmeans Sex*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=control adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model11_CF_SexXage_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/



/*    MODEL 11 - capillary sex x age -absolute   */

ODS RTF FILE = '/home/oyvindskattebo0/MetaAnalysis june2024/Model11_CF_SexXage_abs_june24.rtf' STYLE= minimal;
options orientation=landscape;
proc GLIMMIX data=IMPORT_capillaries_AgeSex nobound METHOD=rspl; 
	class Study_nr Subject_group_nr Sex Age_category2 Weeks_thirds Sessions_week_over_3;
	weight CF_change_abs_inverse_VAR;
	model CF_change_abs=Sex*Age_category2 Weeks_thirds Sessions_week_over_3/
		noint DDFM=satterthwaite solution cl alpha=0.05;
	random Intercept / type=VC subject=Subject_group_nr;
	random Study_nr;
	parms 1 1 1/hold=3;
	lsmeans Sex*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=all adjust=bon stepdown adjdfe=row;
	lsmeans Sex*Age_category2/ plots=meanplot OBSMARGINS /*E*/ cl pdiff=control adjust=bon stepdown adjdfe=row;
/*generate output data*/
output out=Model11_CF_SexXage_abs_24 pred=p resid=r;
run;
ODS RTF CLOSE;
/*********************************************************************************************************/