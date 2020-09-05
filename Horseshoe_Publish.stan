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
    vector[p] beta_raw; //Control unit weights (will be transformed)
    //Hyperparameters prior
    vector<lower=0, upper=pi()/2>[p] lambda_unif;
    real<lower=0> tau; //Global shrinkage
}
transformed parameters{
    vector[p] beta; //Control unit weights
    real<lower=0> sigma; //Error term sd
    vector<lower=0>[p] lambda; //Local shrinkage
    vector[N_train] X_beta; //Synthetic control unit prediction in the pre-treatment period 
    lambda = tau * tan(lambda_unif); // => lambda ~ cauchy(0, tau)
    for(j in 1:p){
	    beta[j] = lambda[j] * beta_raw[j];
        }
    sigma = sqrt(sigma2);
    X_beta = beta_0 + X_train*beta;
}
model{
    //Pre-treatment estimation
    beta_raw ~ normal(0, 1); //=> beta ~ normal(0, lambda^2)
    tau ~ cauchy(0, sigma);
    sigma ~ cauchy(0,10);
    beta_0 ~ cauchy(0,10);
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
