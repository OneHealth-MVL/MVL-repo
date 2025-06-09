/**
* Name: MainGUI
* Based on the internal empty template. 
* Author: jpablo91
* Tags: 
*/


model MainGUI

import "global.gaml"
import "species/Sp.gaml"
import "species/Interventions.gaml"

experiment MainGUI type:gui{
	reflex NoExport{
		ExportResults <- false;
	}
	
	output{
		layout #split consoles: true editors: false navigator: false tray: false tabs: false;
		display Map{
			species Building aspect:B_geom;
			species Rooms aspect:R_geom;
			species Residents aspect: R_geom; 
			species Staff aspect: S_geom;
			species Interventions;
		}
		display TS refresh: every(24 #cycles){
			chart "Epi Curve" type: series{
//				data "Exposed Residents" style:line value:E_r color:#orange;
				data "Infected Residents" style:line value:I_r color:rgb(230, 50, 50);
				data "Infected Staff" style:line value:I_s color:rgb(150, 50, 50);
				data "Cumulative Infected" style:line value:Cumulative_I_r color:#darkred;
//				data "Susceptible Residents" style:line value:S_r color:#green;
			}
		}
	}
	
		
}

experiment Batch type:batch repeat: 200 until: (Days_free > 24*7) or (cycle > SimLength){
}