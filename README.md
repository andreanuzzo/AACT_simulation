# Description
This is the code repository for the paper [Universal Shelter-in-Place vs. Advanced Automated Contact Tracing and Targeted Isolation: A Case for 21st-Century Technologies for SARS-CoV-2 and Future Pandemics](https://doi.org/10.1016/j.mayocp.2020.06.027)

# Dependencies
Requires the following packages in base R 3.6.1
```
#Calculations
deSolve=1.28
bitops=1.0-6
purrr=0.3.3

#Data handling
RCurl=1.95-4.12
janitor=1.2.0
gg.gap=1.3
directlabels=2020.1.31
scales=1.0.0
tidyverse=1.2.1d
stringr=1.4.0
dplyr=0.8.3
readr=1.3.1
lubridate=1.7.4
forcats=0.4.0

#Graphics
DiagrammeR=1.0.5
ggrepel=0.8.1
ggsci=2.9
ggpubr=0.2.3
RColorBrewer=1.1-2
ggthemes=4.2.0
ggplot2=3.2.1
deSolve=1.28
kableExtra=1.1.0
knitr=1.25

```

# Approach
In this framework we analyze two possibilities to implement non-clinical procedures to stop the spread of the epidemic:
 - Advanced contact tracing: Through AACT, it is possible to inform Exposed (asymptomatic/non-infected) members of the community of the exposure risk. Once warned, they would ideally self-isolate themselves and prevent second-order spreading of the contagion. Therefore, self-isolated contacts will depend on the AACT penetrance p in both the Infected and the Exposed population. We are assuming efficacy 100% (or rather, traced contacts receiving warnings and not self-isolating would pose as much risk as non- traced contacts). Self-isolated members might still develop symptoms. The percentage of AACT penetration will also limit the further exposure, thus reducing the 𝛽 transition between Susceptible and Exposed.
 - Traditional measures: in order to stop the contagion, authorities might recur to enforce social distancing through different measures, going from limitation of public gathering to full lockdown. We use the variable g to model these interventions which will act aspecifically on Susceptible, Exposed and Infected population. This measure does not depend on the percentage of Infected patients, but will still limit the 𝛽 of the Susceptible population. Quarantine will last for a time of 50 days (assumed reasonable in the current scenario)

# Models
## Traditional
| Compartment | Functional definition                                                                         |
|-------------|-----------------------------------------------------------------------------------------------|
| S           | Susceptible individuals                                                                       |
| E           | Exposed to infection, unclear symptomatic conditions, potentially infectious                  |
| I           | Infected, confirmed symptomatic and infectious                                                |
| Q           | Isolated from the rest of the population through forced measures. Unclear clinical definition |
| R           | Recovered, immune from further infection                                                      |
| D           | Case fatality (death due to COVID-19, not other causes)                                       |

### Flows

1. ![1](https://latex.codecogs.com/png.latex?%5Cdelta%20%3D%20%5Cfrac%7B1%7D%7BT_%7Binterv%7D%7D)

2. ![2](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%20S%7D%7Bd%20t%7D%20%3D%20-%20%281%20-%20g%29%5Cfrac%7B%5Cbeta%7D%7BN%7D%20S%20I%20-%20g%20%5Ctheta%20S)

3. ![3](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%20Q%20%7D%7Bd%20t%20%7D%20%3D%20g%20%5Ctheta%20S%20-%20%5Ctheta%20Q)

4. ![4](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%20E%7D%7Bd%20t%7D%20%3D%20%281%20-%20g%29%5Cfrac%7B%5Cbeta%7D%7BN%7D%20S%20I%20-%20%5Cdelta%20E)

5. ![5](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%20I%7D%7Bd%20t%7D%20%3D%20%5Cdelta%20E%20-%20%5Cgamma%20I%20-%20g%20I)

6. ![6](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%20R%7D%7Bd%20t%7D%20%3D%20%5Cgamma%20I%20&plus;%20%5Ctheta%20Q)

7. ![7](https://latex.codecogs.com/png.latex?\frac{dD}{dt}&space;=&space;\mu&space;I)


Here we will consider ![g](https://latex.codecogs.com/png.latex?%5Cinline%20g) as the strength of intervention, hard to quantify numerically, but can be assumed to increase from limiting big gathering events up to full lockdown, and ![theta](https://latex.codecogs.com/png.latex?%5Cinline%20%5Ctheta) as the rate of intervention (assumint time of intervention 50 days). Here ![g](https://latex.codecogs.com/png.latex?%5Cinline%20g) will have effect on the Susceptible population. Quarantined people will decrease after the intervetion time (and ideally assigned to the Recovered, not the Susceptible population for simplicity purposes). The incidence of intervention does _not_ depend on the I compartment.

## AACT
| Compartment | Functional definition                                                                         |
|-------------|-----------------------------------------------------------------------------------------------|
| S           | Susceptible individuals                                                                       |
| E           | Exposed to infection, unclear symptomatic conditions, potentially infectious                  |
| I           | Infected, confirmed symptomatic and infectious                                                |
| Sq          | Traced contacts, thus exposed but (self-)isolated                                             |
| R           | Recovered, immune from further infection                                                      |
| D           | Case fatality (death due to COVID-19, not other causes)                                       |

Here we will consider ![p](https://latex.codecogs.com/png.latex?%5Cinline%20p) as the percentage of adoption of the contact tracing digital solution among the _whole_ population and ![alpha](https://latex.codecogs.com/png.latex?%5Cinline%20%5Calpha) the percentage of population _with_ the app that would eventually follow the recommendation and self-isolate. We are assuming that percentage of responsible use corresponds to efficacy and tempestivity of isolation Moreover, we do not model the second and third-grade exposure risks from the first contacts for simplicity.
### Flows

1. ![1](https://latex.codecogs.com/png.latex?%5Cdelta%20%3D%20%5Cfrac%7B1%7D%7BT_%7Blat%7D%7D)

2. ![2](https://latex.codecogs.com/png.latex?\frac{dS}{dt}=-(1-p\cdot&space;\alpha)\frac{\beta}{N}SI)

3. ![3](https://latex.codecogs.com/png.latex?%5Cfrac%7BdE%7D%7Bdt%7D%20%3D%20%281-p%20%5Calpha%29%5Cfrac%7B%5Cbeta%7D%7BN%7DSI%20-%20%5Cdelta%20E%20-%20p%20E)

4. ![4](https://latex.codecogs.com/png.latex?\frac{dSq}{dt}&space;=&space;pE&space;-&space;\delta&space;Sq)

5. ![5](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%20I%7D%7Bd%20t%7D%3D%20%5Cdelta%20E%20-%20%5Cgamma%20I%20-%5Cmu%20I%20&plus;%20%5Cdelta%20Sq)

6. ![6](https://latex.codecogs.com/png.latex?\frac{dR}{dt}&space;=&space;\gamma&space;I)

7. ![7](https://latex.codecogs.com/png.latex?\frac{dD}{dt}&space;=&space;\mu&space;I)

