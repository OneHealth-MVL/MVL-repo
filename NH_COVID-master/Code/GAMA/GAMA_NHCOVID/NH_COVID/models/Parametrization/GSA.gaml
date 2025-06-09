/**
* Name: Parameters for GSA
* Parameters for the model
* Author: jpablo91
* Tags: 
*/

// ===========| BASELINE |=================
model Parameters
global{
	/*======| Scenarios: |==========
	 * 0 = Baseline
	 * 1 = Vaccine effect according to @B202
	 * 2 = Vaccine effect according to @Polack202
	 */
	 int Scenario <- 0;
	 // ===========| Disease Parameters |=========
	 float GlobalShedding_p <- one_of(0.35, 0.35*0.8, 0.35*1.2, 0.35*0.6, 0.35*1.4); // Baseline 0.5(0.3, 0.7)
	 float GlobalInfection_p <- GlobalShedding_p; // Baseline 0.5(0.3, 0.7)
	 float Asymptomatic_p <- 0.4; // Basleine 0.25
	 float Introduction_p <- one_of(0.01, 0.05, 0.1); // Baseline 0.01(0.05, 0.1)
	 float Res_Hospitalization <- 0.23/(24*5); // 
	 float BaseMortality <- 0.118;
	 
	 // ~~~~~~~~~~~~~~~~~~~ || INTERVENTIONS || ~~~~~~~~~~~~~~~~~~~~	
	 int TestingFreq <- one_of(3, 5, 7); // 7(3, 5)
	 float Test_sensitivity <- one_of(0.75, 0.8, 0.95); // Detection probability 0.75(0.85, 0.95)
	 // ~~~~~~PPE USE~~~~~~~
	 float PPE_OR <- one_of(0.0722, 0.1467, 0.3408); // Odds ratio for the use of PPE  0.1467(0.0722, 0.3408)
	 float p_PPE_res <- 0.75;
	 float p_PPE_staff <- 0.9;
	 // ~~~~~~Vaccination~~~~~
	 string VaccineEff <- one_of('Equal', 'A', 'B');
	 float vaccination_dist <- one_of(0.3, 0.5, 0.7); // proportion of doses for staff (for residents is 1 - p)
	 int Vaccination_decay <- 120*24;
	 float First_dose_effect <- 0.6; // the first dose effect will be scaled by this constant.
}