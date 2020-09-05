rm(list=ls())
############################################################
# Initial setup
############################################################

library(rstan)
library(dplyr)
library(loo) 
require(MASS) # to generate from a multivariate normal distribution
require(Matrix) # to create sparse vectors

### TODO: change to your working directory where the .stan files are stored
#setwd("~/Desktop/") 
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

##############################################
# Data Generating Process
##############################################
set.seed(2019)

sig.param = 2
num.param = 50
N_train = 100
N_test = 100
nobs= N_train+N_test
Sig <- matrix(0, ncol=num.param, nrow=num.param)
diag(Sig) <- 10
sd=1
beta0 = 0
beta = c(0.2, 0.8, rep(0,(num.param-sig.param)))
X <- mvrnorm(nobs, mu=c(15,35, rep(10,8), rep(20,10), rep(30,10), rep(40,10), rep(50,10)), Sigma=Sig)
y <- beta0 + X %*% beta + rnorm(nobs,0,sd)

trainX <- X[1:N_train, ]
testX <- X[(N_train+1):nrow(X), ]
trainY <- y[1:N_train]
testY <- y[(N_train+1):nrow(y)]

standat <- list(N_train=N_train, p=ncol(trainX), y_train=trainY, X_train=trainX,
                N_test=N_test, X_test=testX)

##############################################
# Main Simulation
##############################################

############################################################
# Horseshoe
############################################################
fit_horseshoe = rstan::stan_model(file = 'Horseshoe_Publish.stan')
fit_horseshoe <- sampling(object = fit_horseshoe, data=standat, 
                          seed=2019, chains = 4,iter = 10,warmup = 5)

# LOO, WAIC
summary_horseshoe = summary(fit_horseshoe)
lik_horseshoe = extract_log_lik(fit_horseshoe)
loo_horseshoe = loo(lik_horseshoe)
waic_horseshoe = waic(lik_horseshoe)

############################################################
# Spike and Slab
############################################################
stan_normal_mixture = stan_model(file='Spike_Slab_Publish.stan')
fit_normal_mixture <- sampling(object = stan_normal_mixture, data=standat, 
                               seed=2019, chains = 4,iter = 10,warmup = 2)

# LOO, WAIC
lik_normal_mixture = extract_log_lik(fit_normal_mixture)
loo_normal_mixture = loo(lik_normal_mixture)
waic_normal_mixture = waic(lik_normal_mixture)

