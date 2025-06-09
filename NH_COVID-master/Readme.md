# Testing and vaccination to reduce the impact of COVID-19 in nursing homes: an agent-based approach

This is the repository for the model described at [Testing and vaccination to reduce the impact of COVID-19 in nursing homes: an agent-based approach](https://www.researchgate.net/publication/360717965_Testing_and_vaccination_to_reduce_the_impact_of_COVID-19_in_nursing_homes_an_agent-based_approach). The model runs in [GAMA platform](https://gama-platform.github.io) and the outcomes are summarized using R.  

You can find the GAMA project to run the model in the [NH_COVID](Code/NH_COVID/) directory. The model is contained in different files:
  
  - [global.gaml](Code/GAMA/GAMA_NHCOVID/NH_COVID/models/global.gaml), contains the declaration of global variables in the model.
  - [MainGUI.gaml](Code/GAMA/GAMA_NHCOVID/NH_COVID/models/MainGUI.gaml), has the user interface and batch experiments declaration.
  - [Sp.gaml](Code/GAMA/GAMA_NHCOVID/NH_COVID/models/species/Sp.gaml), has the declaration of the agents in the model and their behavior.
  - [Interventions.gaml](Code/GAMA/GAMA_NHCOVID/NH_COVID/models/species/Interventions.gaml), The declaration of the interventions implemented in the model
  - [Parametrization](Code/GAMA/GAMA_NHCOVID/NH_COVID/models/Parametrization/), contains the files for the different parametrization used


The code used to do the analysis of the outcomes can be found in [SimsOutput.Rmd](Code/R/SimsOutput.Rmd)


