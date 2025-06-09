/**
* Name: NHv2 global
* This file declares the global parameters and initialization of the ABM 
* Author: jpablo91
* Tags: 
*/
@no_experiment
model NH01
import 'Parametrization/GSA.gaml'
import "Sp.gaml"
import "Interventions.gaml"

global{
	// Main settings:
	float step <- 8 #hour;
	int t <- 3;
	date starting_date <- date([2020,1,1,0,0,0]);
	bool ExportResults <- true;
	float seed <- int(self) + 0.0;
	int SimLength <- 90*t; //90 days, 3 months
	int Days_free;
	int test;

	// Staff parameters
	string Schedule;
	int Total_Staff update: Staff count(each.is_active or !each.is_active);
//	int Total_Staff <- int(gauss(MeanStaff, sdStaff)); // Total number of staff This is wrong make sure to change it !!!!!!!
	int Total_Residents <- 0 update: Residents count(each.is_infected or !each.is_infected);
	int TotalSharedStaff;
	map<int, float> TurnsDistribution <- ([1::0.4, 2::0.4, 3::0.2]); // Distribution of staff for each turn [Morning, Afternoon, Night]
	map<string, float> StaffDistribution <- ['CN'::0.25, 'LPN'::0.5, 'RN'::0.25, 'PT'::0.0]; // Distribution of staff by type [CN, LPN, RN, PT]
	
	 bool RecreationRestrictions;
	 bool CD_Restriction;
	
	//Disease parameters
	int InitialInfected <- 1;
	float infection_distance <- 1.5#m;
	int Infection_Duration <- 15;
	int LastInfection;
	
	// Disease outcomes
//	int S_r <- 0 update: Residents count (each.is_susceptible);
	int Ir <- 0 update: Residents count (each.is_infectious);
	int E_r <- 0 update: Residents count (each.is_infected);
	int H <- 0 update: Residents count (each.is_hospitalized);
//	int S_s <- 0 update: Staff count (each.is_susceptible);
	int I_s <- 0 update: Staff count (each.is_infectious);
	int E_s <- 0 update: Staff count (each.is_infected);
	int I <- 0 update: Ir + I_s; // Total Infected
	int E <- 0 update: E_r + E_s; // Total Exposed
	int D;
	int Tests_r;
	int Tests_s;
	
	int Cumulative_I;
	int CIr_a;
	int CIr_b;
	int Cumulative_I_r;
	int Cumulative_I_s;
	int Cumulative_H;
	
	// ~~~~~~~~~~~~~~~~~~~ || INTERVENTIONS || ~~~~~~~~~~~~~~~~~~~~	
	bool ActiveSurv;
	bool PassiveSurv;
	bool R_Testing;
	bool S_Testing;
	bool Resident_Vaccination;
	bool Staff_Vaccination;
	// ~~~~~~PPE USE~~~~~~~
	bool PPE_Use;
	float PPE_effect <- 0.0;
	// ~~~~~~Vaccination~~~~~
	int vaccination_freq <- 90; // when should another vaccination happen?
	float Vaccination_OR_S;
	float Vaccination_OR_R;
	
	
	int Revaccination_t <- 21 parameter: "Time to revaccination (second dose)";
	
	// ~~~~~~~~~~~ Initialization of the model ~~~~~~~~~~~~~~~~~~~~~
	init{
		// Set the interventions according to scenarios
		// Baseline conditions:
		RecreationRestrictions <- true;
		CD_Restriction <- true;
		ActiveSurv <- true;
		S_Testing <- true;
		R_Testing <- true;
		PPE_Use <- true;
		
		if VaccineEff = 'Equal'{
			Vaccination_OR_S <- 0.0493;
			Vaccination_OR_R <- 0.0493;
		}else if VaccineEff = 'A'{
			Vaccination_OR_S <- 0.0619;
			Vaccination_OR_R <- 0.0434;
		}else if VaccineEff = 'B'{
			Vaccination_OR_S <- 0.1357;
			Vaccination_OR_R <- 0.0441;
		}
		
		// Create the buildings ~~~~~~~~~~~~~~~~~~~~~~~~~
		create Building number: 2{
			facility <-  name = 'Building0' ? 'A': 'B';
			nResidents <- facility = 'A' ? nResA:nResB;
			nStaff <- facility = 'A' ? nStaffA:nStaffB;
			// create bedrooms:
			create Rooms number: int(nResidents/3) + 1{
				current_facility <- myself;
				Type <- 'Bedroom';
				add self to: myself.bedRooms;
			}
			// create isolation rooms
			create Rooms number:5{
				current_facility <- myself;
				Type <- 'Isolation';
				add self to: myself.isolationRooms;
			}
			// create hospital rooms
			create Rooms{
				Type <- 'Hospital';
			}
			// create staff rooms:
			create Rooms{
				current_facility <- myself;
				Type <- 'Staff';
				add self to: myself.staffRooms;
				
				// Create staff
				create Staff number: current_facility.nStaff{
					My_Vaccine_OR <- Vaccination_OR_S;
					schedule <- rnd_choice(TurnsDistribution);
					Type <- rnd_choice(StaffDistribution); // Staff type:
					float pShared <- sharedStrength / (nStaffA+nStaffB);
					// Define the type of staff and workplace:
					if Type = 'CN'{
//						float CNp <- SharedStaffScenario = 0 ? 0.0:(SharedStaffScenario = 1 ? 0.06:(SharedStaffScenario = 2 ? 0.20: 0.27));
						shared <- flip(pShared);
						workplace <- shared ? list(Building): one_of(myself.current_facility);
					} else if Type = 'LPN'{
//						float LPNp <- SharedStaffScenario = 0 ? 0.0:(SharedStaffScenario = 1 ? 0.06:(SharedStaffScenario = 2 ? 0.20: 0.27));
						shared <- flip(pShared);
						workplace <- shared ? list(Building): one_of(myself.current_facility);
					}else if Type = 'RN'{
//						float RNp <- SharedStaffScenario = 0 ? 0.0:(SharedStaffScenario = 1 ? 0.09:(SharedStaffScenario = 2 ? 0.22: 0.43));
						shared <- flip(pShared);
						workplace <- shared ? list(Building): one_of(myself.current_facility);
					}
					
					current_facility <- myself.current_facility;
					current_room <- one_of(myself);
					
					if flip(p_PPE_staff){
						x_PPE <- 1;
						PPE_e <- 1-PPE_effect;
					}else{
						x_PPE <- 0;
						PPE_e <- 1.0;
					}
					
				}
				
				
			}
			// Create residents v 2.0
			create Residents number: nResidents{
				current_facility <- myself;
				my_bedroom <- one_of(Rooms where((each.current_facility = self.current_facility) and (each.Type = "Bedroom") and (length(each.CurrentRes) < 3)));
				current_room <- my_bedroom;
				My_Vaccine_OR <- Vaccination_OR_R;
				hospitalization_p <- Res_Hospitalization;
				add self to: my_bedroom.CurrentRes;
				if flip(p_PPE_res){
					x_PPE <- 1;
					PPE_e <- 1-PPE_effect;
				}else{
					x_PPE <- 0;
					PPE_e <- 1.0;
				}
		}
		
		
		// Create the staff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// one for each schedule:
//		create Staff number: Total_Staff{
//			if(current_facility = nil) {write name + ' No facility';}
//			My_Vaccine_OR <- Vaccination_OR_S;
//			schedule <- rnd_choice(TurnsDistribution);
//			Type <- rnd_choice(StaffDistribution); // Staff type: 
//			// Define the type of staff and workplace:
//			if Type = 'CN'{
//				float CNp <- SharedStaffScenario = 0 ? 0.0:(SharedStaffScenario = 1 ? 0.06:(SharedStaffScenario = 2 ? 0.20: 0.27));
//				shared <- flip(CNp);
//				workplace <- shared ? list(Building): one_of(Building);
//			} else if Type = 'LPN'{
//				float LPNp <- SharedStaffScenario = 0 ? 0.0:(SharedStaffScenario = 1 ? 0.06:(SharedStaffScenario = 2 ? 0.20: 0.27));
//				shared <- flip(LPNp);
//				workplace <- shared ? list(Building): one_of(Building);
//			}else if Type = 'RN'{
//				float RNp <- SharedStaffScenario = 0 ? 0.0:(SharedStaffScenario = 1 ? 0.09:(SharedStaffScenario = 2 ? 0.22: 0.43));
//				shared <- flip(RNp);
//				workplace <- shared ? list(Building): one_of(Building);
//			}
			
//			current_facility <- one_of(workplace); 
//			current_room <- one_of(current_facility.facilityRooms where(each.Type = 'Staff'));
//			write name + ' ' + one_of(current_facility.staffRooms);
//			current_room <- one_of(Rooms);
			
//			if(current_room = nil){
//				test <- test + 1;
////				do die;
////				write name + ' has no room from the facility" ' + self.current_facility;
//			}
			
//			if flip(p_PPE_staff){
//				x_PPE <- 1;
//				PPE_e <- 1-PPE_effect;
//					}else{
//						x_PPE <- 0;
//						PPE_e <- 1.0;
//					}
					// Initial Vaccination
//					if flip(p_vaccination_staff){
//						is_vaccinated <- true;
//						transmission_p <- transmission_p * (1-Vaccine_effect);
//						shedding_p <- GlobalShedding_p * (1-Vaccine_effect);
//						infection_p <- GlobalInfection_p * (1-Vaccine_effect);
//					}
//		}
		}
		create Interventions;	
		
		TotalSharedStaff <- Staff count (each.shared);	
		

		write 'Morning Staff N; ' + Staff count (each.schedule = 1);
		write 'Afternoon Staff N; ' + Staff count (each.schedule = 2);
		write 'Evening Staff N; ' + Staff count (each.schedule = 3);
		write 'Shared staff, scenario: ' + SharedStaffScenario + '/ ' + TotalSharedStaff;
		write 'Vaccine scenario: ' + VaccineEff;
		write 'Test variable: ' + test;
		write '--------------------------';
//		write "mean latent period:" + Residents mean_of(each.Alatent_period) + "(" + Residents min_of(each.Alatent_period) + "," + Residents max_of(each.Alatent_period);
	}
	
	reflex Write_time{
//		write "Time: " + current_date;
	}
	
	
	reflex init_outbreak when: cycle = t{
		ask InitialInfected among (Residents){
			is_susceptible <- false;
			is_infected <- true;
			max_hosp_days <- poisson(8); // how many days will the resident spend in hospital? (if hospitalized)
		}
	}
	
//	reflex SaveResults when: ExportResults and current_date.hour = 0{
//		save [
//			seed, cycle, 
//			CIr_a, CIr_b, Ir, I_s,
////			LastInfection,Total_Residents, I, S_r, I_r, I_s, E_s, H, Cumulative_I, Cumulative_I_r, Cumulative_I_s, Cumulative_H, D, Tests_r, Tests_s, 
//			GlobalShedding_p, Introduction_p, SharedStaffScenario, TestingFreq, Test_sensitivity, PPE_OR, EnvironmentalContamination,
////			Vaccination_OR_S, vaccination_dist, VaccineEff, 
//			Desinfection_p
//		] to: "../results/EC/EpiCurve.csv" type:"csv" rewrite:false;
//	}
	
	reflex StopSim when:cycle > SimLength{
		do pause;
	}
	
	
	
	reflex DieOff when: (E_r + Ir + E_s) = 0{
//		bool OutbreakEnded;
		Days_free <- Days_free + 1;
//		write 'E: ' + E_r + '||  I:' + I_r;
		if Days_free > 24*7{
//			OutbreakEnded <- true;
			write "Outbreak ended at:" + cycle;	
		}
	}

}