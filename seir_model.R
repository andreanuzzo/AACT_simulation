## Differential equation solver (lsoda function)
require(deSolve)

## For now, we are building a deterministic ODE model for SEIR. We can use trick up on our sleeves to run 
## various bootstraps to introduce a stochastic element.
## 
## Ideally we need a Susceptible, Exposed, Io (infected-occult), Is (Infected-symptomatic), Recovered model 
## (SEIoIsR).  
seir_model = function(current_timepoint, state_values, parameters){
  
  ## create state valriables
  S  = state_values[1] # susceptibles
  E  = state_values[2] # exposed
  Is = state_values[3] # infected symptomatic
  R  = state_values[4] # recovered
  
  with(
    as.list(parameters), 
    {
      ## compute derivatives
      dS = (-beta * S * Is)
      dE = (beta * S * Is) - (delta * E)
      dI = (delta * E) - (gamma * Is)
      dR = (gamma * Is)
      
      # combine 
      results = c(dS, dE, dI, dR)
      list(results)
    }
  )
  
}

## Parameters ... contact_rate rate from 
## https://www.researchgate.net/figure/Daily-average-number-of-contacts-per-person-in-age-group-j-The-average-number-of_fig2_228649013
contact_rate = 22 # number of contacts per day
## Below are all approximate parameters to make this run. Need to be replaced based on literature.
## See http://gabgoh.github.io/COVID/index.html
transmission_probability = 0.07
infectious_period = 3
## From infected to symptomatic
latent_period = 4.8

## beta (transmission rate), gamma (recovery rate), and delta (latency rate)
beta_value = contact_rate * transmission_probability
gamma_value = 1 / infectious_period
delta_value = 1 / latent_period
## Reproductive number:
( R0 = beta_value / gamma_value)

parameter_list = c(beta = beta_value, gamma = gamma_value, delta = delta_value)

## Initial values
## From https://google.org/crisisresponse/covid19-map for the US as of 2020-03-21
population = 331002651 # total US population
Xs = 15219 # infected / symptomatic hosts
Y = 147 # recovered hosts
Z = round(population * 0.10) # exposed hosts - arbitrarily assumed to be 10% of the total population
W = population - (Xs + Y + Z) # susceptible hosts

( N = W + Xs + Y + Z ) # Redundant, N = population

initial_values = c(S = W/N, W = Xs/N, I = Y/N, R = Z/N)
timepoints = seq(0, 50, by = 1)

######
## Simulate SEIR
output = deSolve::lsoda(initial_values, timepoints, seir_model, parameter_list)
######

## Usual generic plot
# susceptible hosts
plot (S ~ time, data = output, type='b', ylim = c(0,1), col = 'blue', ylab = 'S, E, I, R', main = 'SEIR spread') 
par (new = TRUE)    
# exposed hosts
plot (W ~ time, data = output, type='b', ylim = c(0,1), col = 'pink', ylab = '', axes = FALSE)
par (new = TRUE) 
# infectious hosts
plot (I ~ time, data = output, type='b', ylim = c(0,1), col = 'red', ylab = '', axes = FALSE) 
par (new = TRUE)  
# recovered hosts
plot (R ~ time, data = output, type='b', ylim = c(0,1), col = 'green', ylab = '', axes = FALSE)
legend(1, 0.8, c("S", "E", "I", "R"), fill = c("blue", "pink", "red", "green"))
