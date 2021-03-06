################################################################################
###           Model of CMR data to estimate smolt population size         ###
###                 of Salmo salar in Bresle river.                         ###
###                  Sabrina Servanty & Etienne Pr�vost                      ###
###                          March 2015                                  ###
################################################################################

model {

######################################################################
# Considering effect of flow from 1rst April to 10 May in probability of capture in Eu
# Adding a decrease in the probability of capture in Beauchamps for:
###### - 1995
###### - 2000
###### - 2002
#####################################################################

######################################################################
#  DATA:
# Nyears: Length of time series from 1982 to 2014
# NBeau: Number of years with trapping in Beauchamps
# NEu: Number of years with trapping in Eu
# C_B[t]: Annual number of smolt captured at Beauchamps
# Cum_B[t]: Annual number of smolt captured at Beauchamps and released unmarked downstream
# Cm_B[t]: Annual number of smolt marked and released downstream Beauchamps
# Cm_Eu[t]: Annual number of marked smolt captured at Eu
# Cum_Eu[t]: Annual number of unmarked smolt captured at Eu
# D_B[t]: Annual number of dead smolt at Beauchamps
########################################################################
# NOTATION:
# p_B[t]: annual trap efficiency for capturing smolt at Beauchamps
# p_Eu[t]: annual trap efficiency for capturing smolt at Eu
# lambda[t]: annual mean smolt population size (mean of Poisson distribution)
# Ntot[t]: annual total smolt population size
# Nesc[t]: annual smolt population size escaping the river
############################################################################
#############################################################################

############################################################################################
###############          Hyperprior for the trapping efficiency          ###################
############################################################################################
### Mean and standard deviation of trap efficiency at Beauchamp
mu_B ~ dbeta(1,1) #mean probability of capture in Beauchamps

sigmap_B ~ dunif(0,30)
varp_B <- (sigmap_B)*(sigmap_B)
precp_B <- 1/(varp_B) # precision

p_B95 ~ dbeta(1,1) # decrease for year 1995
p_B00 ~ dbeta(1,1) # decrease for year 2000
p_B02 ~ dbeta(1,1) # decrease for year 2002

## Mean and standard deviation of trap efficiency at Eu
logit_int_Eu ~ dunif(-10,10)    #intercept
logit_flow_Eu ~ dunif(-10,10) #slope for flow data (1 April - 10 May)
sigmap_Eu ~ dunif(0,30)
varp_Eu <- (sigmap_Eu)*(sigmap_Eu)
precp_Eu <- 1/(varp_Eu) # precision

###############             Hyperparameters for Ntot       ##################
# Shape and rate parameter for gamma distribution  for negative binomial (see Gelman, 2d edition, p446)
shape_lambda ~ dgamma(0.001,0.001)
rate_lambda ~ dgamma(0.001,0.001)

mean_gamma <- shape_lambda/rate_lambda
var_gamma <- shape_lambda/(rate_lambda*rate_lambda)

lambda.pred ~ dgamma(shape_lambda,rate_lambda)
Ntot.pred ~ dpois(lambda.pred)

# Nyears : from 1982 to now on (migration year)
for (t in 1:6) {  # from 1982 to 1987
################              Prior for Ntot[t], i=1 to Nyears         ######################
  # Hierarchical under negative binomiale
  lambda[t] ~ dgamma(shape_lambda,rate_lambda)
  Ntot[t] ~ dpois(lambda[t])
  } # end of loop over years

for (t in 11:19) { #from 1992 to 2000
  lambda[t] ~ dgamma(shape_lambda,rate_lambda)
  Ntot[t] ~ dpois(lambda[t])
  } # end of loop over years

for (t in 21:Nyears) { # from 2002 to now on
  lambda[t] ~ dgamma(shape_lambda,rate_lambda)
  Ntot[t] ~ dpois(lambda[t])
  } # end of loop over years

#############	        Prior for p_Beauchamps[t]          #################
for (t in 1:NBeau) {
  
  logit_mupi_B[t] <- log(mu_B/(1-mu_B)) #logit transformation
  logit_pi_B[t] ~ dnorm(logit_mupi_B[t],precp_B)
  p_B[t] <- exp(logit_pi_B[t])/(1+exp(logit_pi_B[t]))  # back-transformation on the probability scale
  epsilon_B[t] <- (logit_pi_B[t] - logit_mupi_B[t])/sigmap_B # standardized residuals
  } ## End of loop over years

# Calculating total probability of capture at Beauchamps (decrease in probability in some years)
for (t in 1:9) { # from 1982 to 1994
    p_Btot[t] <- p_B[t]
    } #end of loop over years

p_Btot[10] <- p_B[10] * p_B95 #year 1995

for (t in 11:14) { # from 1996 to 1999
    p_Btot[t] <- p_B[t]
    } #end of loop over years

p_Btot[15] <- p_B[15] * p_B00 #year 2000
p_Btot[16] <- p_B[16] * p_B02 #year 2002

for (t in 17:NBeau) { #from 2003 to now on
    p_Btot[t] <- p_B[t]
    } #end of loop over years

#############	        Prior for p_Eu[t]          #################
for (t in 1:NEu) {  # For years when Eu is installed
  logQ_Eu[t] <- log(Q_Eu[t]) # ln transformation of covariate
  stlogQ_Eu[t] <- (logQ_Eu[t] - mean(logQ_Eu[]))/sd(logQ_Eu[]) # standardized covariate

  logit_mupi_Eu[t] <- logit_int_Eu + logit_flow_Eu * stlogQ_Eu[t]
  logit_pi_Eu[t] ~ dnorm(logit_mupi_Eu[t],precp_Eu)
  p_Eu[t] <- exp(logit_pi_Eu[t])/(1+exp(logit_pi_Eu[t]))  # back-transformation on the probability scale
  epsilon_Eu[t] <- (logit_pi_Eu[t] - logit_mupi_Eu[t])/sigmap_Eu # standardized residuals
  eps_Eu[t] <- logit_pi_Eu[t] - logit_mupi_Eu[t] # residuals not standardized
  } ## End of loop over years

test <- step(logit_flow_Eu) # is logit_flow >=0 ?

#Calculating R� = 1 -(E(variance of residuals (/!\ not standardized!) / E(variance of capture probabilities)))
# See Gelman & Pardoe 2006
sdeps_Eu <- sd(eps_Eu[])
vareps_Eu <- sdeps_Eu * sdeps_Eu

sdlpi_Eu <- sd(logit_pi_Eu[])
varlpi_Eu <- sdlpi_Eu * sdlpi_Eu

R2 <- 1 - (mean(vareps_Eu)/mean(varlpi_Eu))

###################                 LIKELIHOOD               #######################
# from 1982 to 1985 : only capture at Beauchamps
###############################################
for (t in 1:4) {
   # Binomial for captures at Beauchamps
  C_B[t] ~ dbin (p_Btot[t],Ntot[t]) # number of fish captured at Beauchamps
  Nesc[t] <- Ntot[t] - D_B[t]
  } # end of loop over the two first years

# Year 1986: capture at Beauchamps and recapture at Eu
C_B[5] ~ dbin (p_Btot[5],Ntot[5]) # number of fish captured at Beauchamps
num_B[5] <- Ntot[5] - C_B[5] + Cum_B[5] # total unmarked fish

Cm_Eu[5] ~ dbin(p_Eu[1],Cm_B[5]) # marked fish
Cum_Eu[5] ~ dbin(p_Eu[1], num_B[5]) #unmarked fish

Nesc[5] <- Cm_B[5] + num_B[5]  ### Total number of smolt escaping the river

# Year 1987: only capture at Beauchamps
C_B[6] ~ dbin (p_Btot[6],Ntot[6]) # number of fish captured at Beauchamps
Nesc[6] <- Ntot[6] - D_B[6]

# Year 1992: only capture at Beauchamps
C_B[11] ~ dbin (p_Btot[7],Ntot[11]) # number of fish captured at Beauchamps
Nesc[11] <- Ntot[11] - D_B[11]

# Year 1993 & 1994: capture at Beauchamps and recapture at Eu
for (t in 12:13) {
    C_B[t] ~ dbin (p_Btot[t-4],Ntot[t]) # number of fish captured at Beauchamps
    num_B[t] <- Ntot[t] - C_B[t] + Cum_B[t] # total unmarked fish

    Cm_Eu[t] ~ dbin(p_Eu[t-10],Cm_B[t]) # marked fish
    Cum_Eu[t] ~ dbin(p_Eu[t-10], num_B[t]) #unmarked fish

    Nesc[t] <- Cm_B[t] + num_B[t]  ### Total number of smolt escaping the river
    } # end of loop over years

# Year 1995: only capture at Beauchamps
C_B[14] ~ dbin (p_Btot[10],Ntot[14]) # number of fish captured at Beauchamps
Nesc[14] <- Ntot[14] - D_B[14]

# Year 1996 to 2000: capture at Beauchamps and recapture at Eu
for (t in 15:19) {
    C_B[t] ~ dbin (p_Btot[t-4],Ntot[t]) # number of fish captured at Beauchamps
    num_B[t] <- Ntot[t] - C_B[t] + Cum_B[t] # total unmarked fish

    Cm_Eu[t] ~ dbin(p_Eu[t-11],Cm_B[t]) # marked fish
    Cum_Eu[t] ~ dbin(p_Eu[t-11], num_B[t]) #unmarked fish

    Nesc[t] <- Cm_B[t] + num_B[t]  ### Total number of smolt escaping the river
    } # end of loop over years

# Year 2002: only capture at Beauchamps
C_B[21] ~ dbin (p_Btot[16],Ntot[21]) # number of fish captured at Beauchamps
Nesc[21] <- Ntot[21] - D_B[21]

# From 2003 to now on: capture at Beauchamps and recapture at Eu
for (t in 22:Nyears) {
    C_B[t] ~ dbin (p_Btot[t-5],Ntot[t]) # number of fish captured at Beauchamps
    num_B[t] <- Ntot[t] - C_B[t] + Cum_B[t] # total unmarked fish

    Cm_Eu[t] ~ dbin(p_Eu[t-13],Cm_B[t]) # marked fish
    Cum_Eu[t] ~ dbin(p_Eu[t-13], num_B[t]) #unmarked fish

    Nesc[t] <- Cm_B[t] + num_B[t]  ### Total number of smolt escaping the river
    } # end of loop over years

} # end of the model



