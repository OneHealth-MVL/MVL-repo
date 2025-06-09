/**
* Name: Sp
* This script declares the species in the ABM and their actions 
* Author: jpablo91
* Tags: 
*/
@no_experiment

model Sp
import "global.gaml"

//===============Species:building============
species Building{
	string facility;
	int nResidents;
	int nStaff;
	list<Rooms> bedRooms;
	list<Rooms> staffRooms;
	list<Rooms> isolationRooms;
	int nRN;
	int nLPN;
	int nRNA;
	int currentRes update: length(Residents where (each.current_facility = self));
	int Infected_res update: length(Residents where ((each.current_facility = self) and (each.is_infected)));
	float tPrevRes;
	int Deaths;
	int CIr;
	int CIs;
	int CIss;
	float PrevRes;
	int Deaths_res;
	int activeTests;
	int activePositive;
	int pasiveTests;
	int pasivePositive;
	int testPar;
	float shared_staff_percentage <- sharedStrength/65; 
	
	reflex saveSim when: ExportResults and current_date.hour = 0{
		tPrevRes <- Infected_res/currentRes;
		PrevRes <- CIr/currentRes;
		save [
			seed, cycle, // global sim parameters
			name, nResidents,
			currentRes,Infected_res, CIr, CIs, CIss, PrevRes,
			GlobalShedding_p, PPE_OR, Test_sensitivity,BaseMortality,Asymptomatic_p,VaccineEff,Vaccination_decay,PPH_CN,PPH_RN,PPH_LPN,
			shared_staff_percentage
		
		] to: "../results/EC/Sim Results.csv" type:"csv" rewrite:false;
	}
	
	aspect B_geom{
		draw square(30) color: rgb (200, 220, 200, 255) border:#black; 
	}
}

//==========Species:Rooms==========
species Rooms{
//	string facility;
	Building current_facility;
	string Type;
	list<Residents> CurrentRes;
	bool Contaminated;
	int Contaminated_t update: Contaminated ? Contaminated_t + 1: 0;
	
	// Contamination
	reflex RoomsDesinfection when: Contaminated{
//		Contaminated <- flip(Desinfection_p);
//		Contaminated <- Contaminated_t > 14*t;
//		write 'Room ' + name + ' Desinfected';
	}
	
	
	aspect R_geom{
//		draw shape color: Contaminated ? #pink:#white border:#black;
	}
}

//============Species:people================
species People{
	Building current_facility; // Does caregiver have  a second job outside nursing homes? Options (A, B AB)
	Rooms current_room;
//	bool cont_room update: current_room.Contaminated;
	bool cont_room;
	Rooms my_bedroom;
//	string current_facility_string;
	bool is_active <- true;
	string people_type;
	int env_cont;
	list<People> contacts; // Agent contacts
	bool shared;
	//Disease parameters
	float shedding_p;
	float infection_p;
	bool is_susceptible <- true;
	bool is_infected;
	bool is_infectious;
	int infected_t update: (is_infected or is_infectious) ? infected_t + 1: 0;
	int infected_days;
	bool is_symptomatic;
	bool is_recovered;
	bool hosp_patient; // will the patient require hospitalization?
	float hospitalization_p;
	bool is_hospitalized; //Are they hospitalized in the same building??
	int hospitalization_t; // time hospitalized 
	int hospitalization_days; // hospitalization days
	int max_hosp_days; // how many days will the resident spend in hospital?
	bool is_isolated;
	float mortality <- BaseMortality;
	// PPE
	float PPE_e <- 1.0;
	int x_PPE;
	// Vaccine
	float Vaccine_e <- 1.0;
	float My_Vaccine_OR;
	float x_Vaccine;
	bool is_vaccinated;
	int vaccinated_days;
	int vaccine_doses;

	string infection_source;
	People infection_agent;
	
	bool tested;
	bool detected;
	int latent_period;
	
	
	//~~~~~~~~ Actions
	action ExportInfection(People source, People destination){
		if ExportResults{
					save [seed, cycle, source, destination, source.current_facility, source.shared, sharedStrength] to: "../results/" + "/N/InfNet" + int(seed) +".csv" type:"csv" rewrite:false;
				}
	}
	action infect{
		int p <- length(contacts);
		ask contacts where(each.is_susceptible){
			if flip(myself.infection_p/p){
				is_infected <- true;
				is_susceptible <- false;
				latent_period <-int(lognormal_trunc_rnd(3, 2, 2, 10));
				LastInfection <- cycle;
				do ExportInfection(myself, self);
				infection_source <- "Facility";
				max_hosp_days <- poisson(6.5); // how many days will the resident spend in hospital? (if hospitalized) !!! REPORT on the MODEL description
				infection_agent <- myself;
				Cumulative_I <- Cumulative_I + 1;
				write string(myself.name) + " Infected " + self.name + ' at cycle:' + cycle + ' from: ' + current_facility;
				if(self.people_type = 'staff'){
					current_facility.CIs <- current_facility.CIs + 1; 
					current_facility.CIss <- shared ? current_facility.CIss + 1: current_facility.CIss;
//					write myself.name + ' from: ' + myself.current_facility + ' Infected ' + name + ' from: ' + current_facility;
				} else if(self.people_type = 'resident'){
					current_facility.CIr <- current_facility.CIr + 1;
				}
			}
		}	
	}
	// Environmental contamination --------------
	action contaminate{
//		current_room.Contaminated <- true;
	}
	
	//~~~~~~~~ Reflex
	// wander
//	reflex normal_mov when: is_active{
//		do wander bounds:geometry(current_room) speed:2#m/#hour;
//	}
	// Disease dynamics ~~~~~~~~~~~~~~~~~~~~~~
	reflex Disease_dynamics{
		// update susceptibility
		float odds_s <- GlobalShedding_p/(1-GlobalShedding_p); // compute the odds of the base probability of transmission [W]
		float shedding_o <- exp(ln(odds_s) + ln(PPE_OR)*x_PPE + ln(My_Vaccine_OR)*x_Vaccine);
		shedding_p <-  shedding_o/(1 + shedding_o); //convert the odds to probability
		
		float odds_i <- GlobalShedding_p/(1-GlobalShedding_p); // compute the odds of the base probability of transmission
		float infection_o <- exp(ln(odds_i) + ln(PPE_OR)*x_PPE + ln(My_Vaccine_OR)*x_Vaccine);
		infection_p <-  infection_o/(1 + infection_o); //convert the odds to probability
		
		// when infected:
		if is_infected{
			// State transition E -> I
			if infected_t > latent_period*t{ 
				is_infectious <- true;
				is_symptomatic <- true;
				if flip(Asymptomatic_p){
					is_symptomatic <- false;
				}
			}
		}
		
		if is_infectious{
//			infected_t <- infected_t + 1;
			if flip(shedding_p) and is_active{
				do infect;
			}
			// Contaminate room
			if flip(0.0){
				do contaminate;
			}
			// ******State Transition I -> H
			if flip(hospitalization_p) and !is_hospitalized{
				// Move to hospital
				is_hospitalized <- true;
				current_room <- first(Rooms where(each.Type = "Hospital"));
				location <- current_room.location;	
				is_active <- false;
				if(people_type = 'resident'){
					my_bedroom.CurrentRes >- self;	
				}
//				write string(self) + "Moved to Hospitalization";
				Cumulative_H <- Cumulative_H + 1;
			}
			// ******State Transition H -> D
			
			
			// ******State Transition I -> R
			if infected_t > Infection_Duration*t{
				is_infected <- false;
				is_infectious <- false;
				is_recovered <- true;
				is_symptomatic <- false;
				infected_t <- 0;
			}
		}
		
		infected_days <- int(infected_t/t);
		
		// VACCINATION
		if is_vaccinated{
			vaccinated_days <- vaccinated_days + 1;
			
			// Boolean Vaccinaiton decay
			if(vaccinated_days = Revaccination_t*t){
				vaccine_doses <- 2;
//				Vaccine_e <- 1 - Vi_second_dose;
				x_Vaccine <- 1.0;
			}
			if (vaccinated_days > Vaccination_decay){ // vaccine effect decay
				is_vaccinated <- false;
				Vaccine_e <- 1.0;
			}
			
		}
	}
	
	reflex EnvContamination when:!is_infected and cont_room{
		if(flip(EnvironmentalContamination)){
			is_infected <- true;
			env_cont <- env_cont + 1;
//			write 'Agent ' + name + ' infected from environment';
		}
	}
}

//=============Subspecies: Residents ============
species Residents parent:People{
	string people_type <- "resident";
	bool attended;
	int StaffInteractions;
	bool hospitalized;
	
	
//	action to_my_room{
//		point target <- my_bedroom.location;
//		do goto target:target;
//	}
	
	reflex ResidentContacts when:is_infected and !detected{
		contacts <- my_bedroom.CurrentRes;
		// 
	}
	
	reflex Switch_Rooms when:false{
		if(Schedule = "Recreation Time" and is_active){
			if RecreationRestrictions{
				current_room <- my_bedroom;
			}
			if !RecreationRestrictions{
				current_room <- one_of(Rooms where(each.Type = "Recreation")); // !!! Every cycle is runing this, check how to do once per sched change
			}
			
		} if(Schedule = "Eating Time" and is_active){
			if CD_Restriction{
				current_room <- my_bedroom;
			}
			if !CD_Restriction{
				current_room <- one_of(Rooms where(each.Type = "Dinning Room"));
			}
		} if(Schedule = "Quiet Hours" and is_active){
			current_room <- my_bedroom;
		}
		location <- any_location_in(current_room);
		
		// *** move from isolation back to room
			if is_isolated and !is_infected{
//				my_bedroom <- first(Rooms where((each.Type = "Bedroom") and (length(each.CurrentRes) < 3)));
				my_bedroom <- (Rooms where(each.Type = "Bedroom")) with_min_of(length(each.CurrentRes));
				location <- my_bedroom.location;
				is_isolated <- false;
				my_bedroom.CurrentRes <+ self;
			}
	}
	
	// Hospitalization
	reflex Hospitalization when:is_hospitalized{
		hospitalized <- true;
		hospitalization_t <- hospitalization_t + 1;
		hospitalization_days <- int(hospitalization_t/t);
		if hospitalization_days > max_hosp_days{
			if flip(1 - mortality){
				location <- my_bedroom.location;
				is_active <- true;
				hospitalized <- false;
				hospitalization_t <- 0;
				is_hospitalized <- false;
			} else{
				current_facility.Deaths <- current_facility.Deaths + 1;
				do die;
			}
			
		}
		
	}
	
	//~~~~~~~~~~~ Aspect 
	aspect R_geom{
		draw circle(0.3) color:is_infected ? rgb (230, 50, 50,255) : rgb (50, 230, 50, 255);
	}
}

//=============Subspecies: Staff ============
species Staff parent:People{
	/*Staff schedules:
	 * 1 = 7-15; 2 = 15-23; 3 = 23-7
	 */
	 int schedule;
	 int shiftLength; 
	 string people_type <- 'staff';
	 string Type;
	 bool at_community;
	 int ResTurn <- 1;
	 list<Building> workplace;
	 list<Residents> TargetRes;
	 
	 
	 reflex StaffContacts when:is_infected{
		contacts <- Staff where(!each.is_infected and each.is_active and each.current_facility = self.current_facility);
	}
	
	 reflex StaffSchedules{
	 	if (current_date.hour = 8 and schedule = 1){
	 		is_active <- true;
	 	} else if ((current_date.hour = 16) and schedule = 2){
	 		is_active <- true;
	 	} else if ((current_date.hour = 0)  and schedule = 3){
	 		is_active <- true;
	 	} else{
	 		is_active <- false;
	 	}
	 	
	 	current_room <- is_active? one_of(current_facility.staffRooms) : nil;
	 	
	 	// Go to community
	 	if !is_active{
//	 		location <- any_location_in(geometry(community_shp));
	 		at_community <- true;
	 	} else if is_active and at_community{ // Return to the NH
	 	current_facility <- one_of(workplace);
	 	//Report the residents per turn
//	 	if ExportResults{
//	 		save [cycle, name, Type, ResTurn] to: "../results/" + "/S/RPT" + int(seed) +".csv" type:"csv" rewrite:false;
//	 	}
	 		current_room <- one_of(Rooms where((each.Type = "Staff") and (each.current_facility = self.current_facility)));
			location <- any_location_in(current_room);
			ResTurn <- 0;
			at_community <- false;
			if flip(Introduction_p/100){
				is_infected <- true;
				infection_source <- "Community";
				Cumulative_I_s <- Cumulative_I_s + 1;
			}
	 	}
	 }
	 
	 reflex PatientInteraction when:is_active{
	 	int ResSeen;
	 	// Pick up a number of residents to interact in a given hour
	 	if Type = 'CN'{
//	 		ResSeen <- rnd_choice(PPH_CN);
	 		ResSeen <- poisson(PPH_CN);	
	 		ResTurn <- ResTurn + ResSeen;
	 	} else if Type = 'RN'{
//	 		ResSeen <- rnd_choice(PPH_RN);
	 		ResSeen <- poisson(PPH_RN);
	 		ResTurn <- ResTurn + ResSeen;
	 	} else if Type = 'LPN'{
//	 		ResSeen <- rnd_choice(PPH_LPN);
	 		ResSeen <- poisson(PPH_LPN);
	 		ResTurn <- ResTurn + ResSeen;
	 	}
	 	
	 	// Residents contacted per turn
	 	TargetRes <- sample(list(Residents where (each.is_active and (each.current_facility = self.current_facility))), ResSeen, false);
	 	// Infected residents contacted per turn
	 	list<Residents> InfRes <- TargetRes where(each.is_infectious);
	 	// Proportion of infected (from the contacted ones)
	 	float pInf <- length(InfRes) > 0 ? length(InfRes)/length(TargetRes): 0.0;
	 	
	 	// Resident to staff transmission --------------------
	 	// If there is more than 1 infected add a probability of infection
	 	if(pInf > 0 and !self.is_infected){
	 		if flip(infection_p*pInf){
	 			Residents infectionRes <- one_of(InfRes);
	 			is_infected <- true;
	 			Cumulative_I_s <- Cumulative_I_s + 1;
	 			write infectionRes.name + " Infected " + self.name + ' at cycle:' + cycle + ' from: ' + current_facility;
	 			do ExportInfection(infectionRes, self);
//	 			write name + ' got infected';
	 			self.current_facility.CIs <- self.current_facility.CIs + 1; 
	 			current_facility.CIss <- shared ? current_facility.CIss + 1: current_facility.CIss;
	 		}
	 	}
	 	
	 	// Staff to Resident transmission ----------------
	 	if(is_infectious){
	 		ask TargetRes where(!each.is_infected){
	 			if flip(shedding_p*(1/length(myself.TargetRes))){ // <- should we account for the number of resident interactions?
//	 			if flip(shedding_p){
	 				is_infected <- true;
	 				infection_source <- 'staff';
	 				Cumulative_I_r <- Cumulative_I_r + 1;
	 				self.current_facility.CIr <- self.current_facility.CIr + 1; 
	 				write string(myself.name) + " Infected " + self.name + ' at cycle:' + cycle + ' from: ' + current_facility;
	 				do ExportInfection(myself, self);
//	 				write string(myself) + ' Infected ' + self + ' at cycle:' + cycle;
	 			}
	 		}
//	 		
	 	}
	 	
//	 	ask TargetRes where(each.is_infectious){
////	 		attended <- true;
////	 		StaffInteractions <- StaffInteractions + 1;
//	 		// Staff to resident transmission
//	 		if myself.is_infectious and !self.is_infected{
//	 			if flip(myself.shedding_p){
//	 				if flip(self.infection_p){
//	 					self.is_infected <- true;
//	 					infection_source <- 'staff';
//	 					Cumulative_I_r <- Cumulative_I_r + 1;
////	 					write string(myself) + ' Infected ' + self + ' at cycle:' + cycle;
//	 				}
//	 				
//	 			}
//	 		}
//	 		
//	 		// Resident to staff transmission
//	 		if self.is_infectious and !myself.is_infected{
//	 			if self.is_isolated{ // assuming there is a correct use of PPE
//	 				if flip(self.shedding_p){
//	 					if flip(myself.infection_p/5){
//	 						myself.is_infected <- true;
//	 						Cumulative_I_s <- Cumulative_I_s + 1;
//	 					}
//	 					
//	 				}
//	 			} else if !self.is_isolated{
//	 				if flip(self.shedding_p*myself.infection_p){
//	 					myself.is_infected <- true;
//	 					Cumulative_I_s <- Cumulative_I_s + 1;
//	 				}
//	 			}
//	 			
//	 		}
//	 	}

	 	//Empty the list after each time step
	 	TargetRes <- [];
	 }
	 
	 //~~~~~~~~~~~ Aspect 
	aspect S_geom{
		if is_active{
			draw circle(0.3) color:is_infected ? rgb (150, 25, 25,255) : rgb (25, 150, 25, 255);
		} else{
			draw circle(0.3) color:rgb (25, 150, 25, 100);
		}
		
	}
}

/* Insert your model definition here */

