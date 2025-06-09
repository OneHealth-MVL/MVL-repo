/**
* Name: Parameters (BASELINE scenario)
* Parameters for the model
* Author: jpablo91
* Tags: 
*/
@no_experiment
/*
 * ===========| BASELINE |=================
 */

model Parameters
import "../global.gaml"
global{
	/*======| Scenarios: |==========
	 * 0 = Baseline
	 * 1 = Vaccine effect according to @B202
	 * 2 = Vaccine effect according to @Polack202
	 */	 
	 // ============| NH parameters: |================
	 int nFacilities <- 2; // !! change it to add the number of residents and staff per nursing homes !!
	 // Number of residents
	 int nResA <- 56;
	 int nResB <- 82;
	 
	 // Number of staff
	 int nStaffA <- 25;
	 int nStaffB <- 40;

	 // Staffing hours
	 // average staff-resident contacts per turn
	 int PPH_CN <- rnd(60,90); //RNA 
	 int PPH_RN <- rnd(3,9);
	 int PPH_LPN <- rnd(5,15);
	 // Shared staff
	 // mean strenght
	 int sharedStrength <-rnd(1,3);
	 
	 // Vaccination proportion
	 
	 // shared staff scenarios
	  int SharedStaffScenario <- one_of(0, 1, 2, 3);
	 
	 // ===========| Disease Parameters |=========
	 float GlobalShedding_p <- rnd(0.27, 0.49); // Baseline 0.5(0.3, 0.7)
	 float GlobalInfection_p <- GlobalShedding_p; // Baseline 0.5(0.3, 0.7)
	 float Asymptomatic_p <- rnd(0.25,0.53); // Basleine 0.25
	 float Introduction_p <- one_of(0.05); // Baseline (0.01, 0.05, 0.1)
	 float Res_Hospitalization <- rnd(0.15,0.30)/(t*5); // 
	 float BaseMortality <- rnd(0.20,0.40);
	 float EnvironmentalContamination <- 0.0;
	 
	 // ~~~~~~~~~~~~~~~~~~~ || INTERVENTIONS || ~~~~~~~~~~~~~~~~~~~~	
	 float Desinfection_p <- one_of(0.0);
	 int TestingFreq <- one_of(14); // 7(3, 5)
	 float Test_sensitivity <- rnd(0.70,0.90); // Detection probability 0.75(0.85, 0.95)
	 // ~~~~~~PPE USE~~~~~~~
	 float PPE_OR <- rnd(0.07, 0.20); // Odds ratio for the use of PPE  (0.1467, 0.0722, 0.3408)
	 float p_PPE_res <- 0.6;
	 float p_PPE_staff <- 0.6;
	 // ~~~~~~Vaccination~~~~~
	 string VaccineEff <- one_of('Equal','A','B'); // ('Equal', 'A', 'B')
	 float vaccination_dist <- one_of(0.5); // proportion of doses for staff (for residents is 1 - p) (0.3, 0.5, 0.7)
	 int Vaccination_decay <- rnd(90,150)*t;
	 float First_dose_effect <- 0.4; // the first dose effect will be scaled by this constant.
	
	
}