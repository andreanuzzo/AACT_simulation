# SafeKit_model
Epidemiological model for contact tracing impact over the course of COVID-19 2020 pandemic

# Intro
Contact tracing has huge potential to limit and mitigate the spread of infectious diseases. In the recent pandemic of COVID-19, we are defining strategies to implement contact tracing through GPS location tracking and contemporarily preserve the privacy and safety of both patients and contacts at risk. 

This model starts from the effort of [Hellewell et al. 2020](https://doi.org/10.1016/S2214-109X(20)30074-7).

# Model 
## Assumptions
This is an evolution of the classical SIR model based on the following assumptions:
1. Susceptible population is constant
2. Infected population is subdivided into two categories
    * Symptomatic patients -> will spread the disease until they are hospitalized/quarantined
    * Asymptomatic patients -> either undetected or detected will continue to spread the virus until they go into self-quarantine
3. Penetrance of contact tracing will change the numbers of Asymptomatic Infected that self-quarantine them-selves 

## Preliminary model
 - fixed ratio between _I<sub>S</sub>_ and _I<sub>A</sub>_
 - no deaths
 - assume 100% consequence of contact tracing (i.e. every contact will go into self-quarantine)
 
## Secondary model
  - MCMC to layer change of states between _I<sub>S</sub>_ and _I<sub>A</sub>_
  - Number of deaths

## Tertiary model
TBD


