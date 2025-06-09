/**
* Name: MainGUI
* Based on the internal empty template. 
* Author: jpablo91
* Tags: 
*/


model MainGUI

import "global.gaml"
import "Sp.gaml"
import "Interventions.gaml"

experiment MainGUI type:gui{
	reflex NoExport{
//		ExportResults <- false;
	}
	
	output{
		layout #split consoles: true editors: false navigator: false tray: false tabs: false;
		display Map axes:false{
			species Building aspect:B_geom;
			species Rooms aspect:R_geom;
			species Residents aspect: R_geom; 
			species Staff aspect: S_geom;
			species Interventions;
		}
		display TS axes:false refresh: every(1 #cycles){
			chart "Epi Curve" type: series{
//				data "Exposed Residents" style:line value:E_r color:#orange;
				data "Infected Residents" style:line value:(Ir) color:#red;
				data "Infected Staff" style:line value:I_s color:#orange;
//				data "Cumulative Infected" style:line value:(Building sum_of(each.CIr))color:#darkred;
				data "Cumulative Infected" style:line value:(Building sum_of(each.CIs))color:#darkred;
//				data "Susceptible Residents" style:line value:S_r color:#green;
			}
		}
	}
			
}

experiment Batch type:batch repeat: 5000 until:  (cycle = SimLength){
}

/* Insert your model definition here */

