# Bayesian Synthetic Control Method (BSCM)
Link: https://bit.ly/3hubqs8

This repo provides the code for the methodology illustrated in our paper Bayesian Synthetic Control Method (Kim, Lee, Gupta 2020).  

Our paper adds a new, improved tool to a tool-box called quasi-experimental research methods. These are methods that are used to measure the causal effect of a treatment on a business or a population when random assignment of units to treatment and control groups is not possible. Instead, historical data are available that record the outcomes when some units were naturally exposed to the treatment while others were not. An example is a tax on sales of sugar-sweetened beverages that has been levied on retailers in one city but not in other cities, and both businesses and cities want to know what would have happened to retail prices and consumption in the affected city had the tax not been imposed. Thereby they can learn how the tax affected prices and consumption.

Existing methods in the tool-box that are very widely used by researchers include propensity score matching, difference-in-differences and synthetic control, each of which has pros and cons depending on the context. Our approach – Bayesian Synthetic Control Methods (BSCM) – builds upon synthetic control methods by suggesting a different way to operationalize them statistically. In particular, by using a Bayesian statistical approach, we are able to relax some of the constraints that are inherent in synthetic control methods and also get good measures of the precision of the estimated effects. The latter is especially important because managers want to know whether or not the effect of the event has been estimated reliably given the historical data, since they want to make future decisions based on the past experience.

To demonstrate the value of our approach, we applied BSCM to measure the effect of a tax on soda sales that was imposed in Washington state in 2010. Our method revealed that retailers passed through more than the amount of the tax to consumers in the form of raised retail prices. In turn, the higher prices led to soda sales decreasing by about 5-6%. Importantly, the effect of the tax on sales was estimated very precisely by our method. By contrast, when one of the extant methods was applied to the same data the estimated effect was unreliable enough that it could be zero, thereby leading to wrong conclusions about whether the tax “worked”. 

We encourage managers and policy makers to include BSCM in the set of methods they consider when they need to infer causality from naturally occurring data.

---
# Usage Instructions

Step 1 RStan setup: install RStan from here: https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started.   This will install the package RStan in R.  

Step 2 Other R packages installation: 
  * dplyr
  * loo
  * MASS
  * Matrix
  
Step 3 Run run_stan.R: this is the R code that runs the models with (a) Horseshoe and (b) Spike & Slab priors.  Both text files below are Stan code that implements two variations of our proposed model:

* Horseshoe_Publish.stan: variant that implements the Bayesian Horse-shoe prior
* Spike_Slab_Publish.stan: variant that implements the Spike-and-Slab prior
