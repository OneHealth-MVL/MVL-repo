/**
* Name: Interventions
* Based on the internal empty template. 
* Author: jpablo91
* Tags: 
*/

@no_experiment

model Interventions

import "../global.gaml"

species Interventions{
//	list<People> Infected_People <- [] update: (agents of_generic_species People where each.is_infectious);
	int Infected_People update: length(agents of_generic_species People where each.is_infectious);
	bool active;
	
	// Active surveillance
	action ActiveSurveillance{
		int tests;
		int pos;
		// Resident testing
		if R_Testing and every(TestingFreq*24#cycle){ // test the residents every week
			ask Rooms where(each.Type = "Bedroom" and (length(each.CurrentRes) > 0)){
				Residents t_resident <- one_of(CurrentRes);
				tests <- tests + 1;
				Tests_r <- Tests_r + 1;
				if flip(Test_sensitivity) and t_resident.is_infected{
					t_resident.detected <- true;
					ask CurrentRes{ // If one of the residents positive, test the roomates.
						if flip(Test_sensitivity) and is_infected{
							detected <- true;
							pos <- pos + 1;
							ActiveDet_r <- ActiveDet_r + 1;
						}
					}
				}
				write string(pos) + '/' + string(tests) + ' tested at day: ' + cycle/24;
			}
//		}
			
		}
		// Staff testing 
		if S_Testing and every(TestingFreq*24#cycle){
			ask (Staff where !each.tested){
				if flip(Test_sensitivity) and is_infected{
					detected <- true;
					ActiveDet_s <- ActiveDet_s + 1;
					is_isolated <- true;
//					write 'Isoated: ' + name;
//					do die; // remove the staff member for now
					}
					Tests_s <- Tests_s + 1;
				}
		}
	}
	
	// Passive surveillance (Targeted)
	action PassiveSurveillance{
		// Residents
		list<Residents> ASR <- Residents where(!each.detected and each.is_symptomatic);
		if length(ASR) > 0 {
			ask one_of(ASR){
				if flip(Test_sensitivity*0.7) and is_infected{
					detected <- true;
					PassiveDet_r <- PassiveDet_r + 1;
				}
				Tests_r <- Tests_r + 1;
			}
		}
		//Staff
		list<Staff> SS <- Staff where(!each.detected and each.is_symptomatic);
		if length(SS) > 0{
			ask SS{
				detected <- flip(Test_sensitivity*0.7) and is_infected;
				is_isolated <- detected;
				if detected{
					PassiveDet_s <- PassiveDet_s + 1;
					write 'Detected ' + name;
				}
			}
		}
	}
	
	action Isolation{
		if length(Residents where(each.detected and !each.is_isolated)) > 0 {
			ask one_of(Residents where(each.detected and !each.is_isolated)){
				my_bedroom.CurrentRes >- self; // remove self
				Rooms q_room <- one_of(Rooms where(each.Type = "PrivateBedroom"));
				my_bedroom <- q_room;
				current_room <- my_bedroom;
				self.location <- q_room.location;
				is_isolated <- true;
				}			
		}
		
	}
	
	action Vaccination{
		// Staff vaccination
		ask floor(vaccination_dist*Total_Staff) among Staff where(!each.is_vaccinated){
			is_vaccinated <- true;
			vaccinated_days <- 0;
//			Vaccine_e <- Vi_first_dose;
			x_Vaccine <- 0.6;
//			shedding_p <- shedding_p * (1-Vaccine_effect);
//			infection_p <- infection_p * (1-Vaccine_effect);
		}
		
		// Resident vaccination
		ask floor((1 - vaccination_dist)*Total_Residents) among Residents where(!each.is_vaccinated){
			is_vaccinated <- true;
			vaccinated_days <- 0;
//			Vaccine_e <- Vi_first_dose;
			x_Vaccine <- 0.6;
//			shedding_p <- shedding_p * (1-Vaccine_effect);
//			infection_p <- infection_p * (1-Vaccine_effect);
		}
	}
	
	reflex StartVaccination when: (every(80*24#cycle)) and vaccination_dist != 0.0{
		do Vaccination;
		write "------------------";
		write "Vaccination at:" + cycle;
		write "Residents: " + floor(vaccination_dist*Total_Residents) ;
		write "Staff: " + floor((1 - vaccination_dist)*Total_Staff) ;
		write "------------------";
	}
	
	reflex interventions{
		active <- true;
//		write "~~~~~~~~~~~~~~~~~~~";
//		write 'intervention is on';
//		write "~~~~~~~~~~~~~~~~~~~";
		do ActiveSurveillance;
		if(Infected_People > 0){
			if every(24#cycle){
				do PassiveSurveillance;	
			}
			do Isolation;
		}
	}
}