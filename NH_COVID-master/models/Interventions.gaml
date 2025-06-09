/**
* Name: Interventions
* Based on the internal empty template. 
* Author: jpablo91
* Tags: 
*/

@no_experiment

model Interventions

import "global.gaml"

species Interventions{
	list<People> Infected_People <- [] update: (agents of_generic_species People where each.is_infectious);
	bool active;
	
	// Active surveillance
	action ActiveSurveillance{
		// Resident testing
		if R_Testing and every(TestingFreq*t#cycle){ // test the residents every week
//		int RoomsToTest <- length(Rooms where(each.Type = "Bedroom" and (length(each.CurrentRes) > 0)));
//		if RoomsToTest > 0{
			ask Rooms where(each.Type = "Bedroom" and (length(each.CurrentRes) > 0)){
				Residents t_resident <- one_of(CurrentRes where(!each.hospitalized));
				Tests_r <- Tests_r + 1;
				current_facility.activeTests <- current_facility.activeTests + 1;
//				write t_resident.name + ' was tested';
				 if flip(Test_sensitivity) and t_resident.is_infected{
					t_resident.detected <- true;
					write t_resident.name + ' was tested and positive';
					current_facility.activePositive <- current_facility.activePositive + 1;
					// If one of the residents positive, test the roomates.
					ask CurrentRes{
						if flip(Test_sensitivity) and is_infected{
							detected <- true;
						}
					}
				}
//				write 'tested at day: ' + cycle/t;
			}
//		}
			
		}
		
		// Staff testing 
		if S_Testing and every(TestingFreq*t#cycle){
			ask (Staff where !each.tested){
				if flip(Test_sensitivity) and is_infected{
					detected <- true;
					do die; // remove the staff member for now
					}
					Tests_s <- Tests_s + 1;
				}
		}
	}

	// Passive surveillance (Targeted)
	action PassiveSurveillance{
		list<Residents> ASR <- Residents where(!each.detected and each.is_symptomatic);
		if length(ASR) > 0 {
			ask one_of(ASR){
				current_facility.pasiveTests <- current_facility.pasiveTests + 1;
				if flip(Test_sensitivity) and is_infected{
					detected <- true;
					current_facility.pasivePositive <- current_facility.pasivePositive + 1;
				}
				Tests_r <- Tests_r + 1;
			}
			
		}
	}
	
	action Isolation{
		if length(Residents where(each.detected and !each.is_isolated)) > 0 {
			ask one_of(Residents where(each.detected and !each.is_isolated)){
				my_bedroom.CurrentRes >- self; // remove self
				add self to: one_of(current_facility.isolationRooms);
				Rooms q_room <- one_of(Rooms where(each.Type = "Isolation"));
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
	
	reflex StartVaccination when: (every(80*t#cycle)){
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
		if(length(Infected_People) > 0){
			do PassiveSurveillance;
			do Isolation;
		}
	}
}

/* Insert your model definition here */

