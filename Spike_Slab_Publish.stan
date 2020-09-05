data{
    int N_train; //Number of observations in the pre-treatment periods
    int N_test; //Number of observations in the post-treatment periods
    int p; //Number of control units
    real y_train[N_train]; //Treated unit in the pre-treatment periods
    matrix[N_train, p] X_train; //Control unit matrix in the pre-treatment
    matrix[N_test, p] X_test; //Control unit matrix in the post-treatment
}
parameters{
    real beta_0; //Intercept
    real<lower=0> sigma2; //Error term variance
    vector[p] beta; //Control unit weights 
    //Hyperparameters prior
    vector<lower=0>[p] tau2; //Variance slab
    vector<lower=0,upper=1>[p] gamma; //Inclusion probability
}
transformed parameters{
    real<lower=0> sigma; //Error sd
    vector[N_train] X_beta; //Synthetic control unit prediction in the pre-treatment period 
    sigma = sqrt(sigma2); 
    X_beta = beta_0 + X_train*beta;
}
model{
    //Pre-treatment estimation
    tau2 ~ inv_gamma(0.5, 0.5);
    gamma ~ uniform(0, 1);
    beta_0~cauchy(0,10);
    sigma ~ cauchy(0,10);
    for(j in 1:p){
        target += log_sum_exp(log(gamma[j]) + normal_lpdf(beta[j] | 0, sqrt(0.001)), 
        log(1-gamma[j]) + normal_lpdf(beta[j] | 0, sqrt(tau2[j])));
        }	
    target += -2 * log(sigma); 
    y_train ~ normal(X_beta, sigma);
}
generated quantities{ 
    //Post-treatment prediction & Log-likelihood
    vector[N_train] y_fit; //Fitted synthetic control unit in the pre-treatment
    vector[N_test] y_test; //Predicted synthetic control unit in the post-treatment
    vector[N_train] log_lik; //Log-likelihood
    y_fit = beta_0 + X_train * beta;
    for(i in 1:N_test){
       y_test[i] = normal_rng(beta_0 + X_test[i,] * beta, sigma); 
	   }
    for (t in 1:N_train) {
       log_lik[t] = normal_lpdf(y_train[t] | y_fit[t], sigma);
       }
}
