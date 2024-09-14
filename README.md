# `ipwcde`: A Stata Module to Estimate Controlled Direct Effects Using Inverse Probability Weighting

The `ipwcde` command estimates controlled direct effects using inverse probability weighting.

## Syntax

```stata
ipwcde depvar [if] [in], dvar(varname) mvar(varname) d(real) dstar(real) m(real) [options]
```

### Parameters

- `depvar`: Specifies the outcome variable.
- `dvar(varname)`: Treatment (exposure) variable, must be binary (0/1).
- `mvar(varname)`: Mediator variable, must be binary (0/1).
- `d(real)`: Reference level of treatment.
- `dstar(real)`: Alternative level of treatment, defining the treatment contrast.
- `m(real)`: Level of the mediator at which the controlled direct effect is evaluated.

### Options

- `cvars(varlist)`: List of baseline covariates; categorical variables must be dummy coded.
- `lvars(varlist)`: List of post-treatment covariates, dummy coded if categorical.
- `sampwts(varname)`: Specifies sampling weights.
- `censor`: Censors the inverse probability weights at the 1st and 99th percentiles.
- `detail`: Prints the fitted models for the exposure, mediator, and outcome, and saves the inverse probability weights in a new variable.

## Description

`ipwcde` estimates controlled direct effects using inverse probability weights, and it computes inferential statistics using the nonparametric bootsrtap. To compute the weights, `ipwcde` fits the following models:

1. **Exposure Model**: A logit model for exposure conditional on baseline covariates.
2. **Mediator Model**: A logit model for the mediator conditional on both the exposure and baseline covariates, plus any specified post-treatment covariates.

These models are used to generate inverse probability weights, which are then applied to fit an outcome model and estimate the controlled direct effect.

## Examples

### Basic Usage
```stata
. use nlsy79.dta
. ipwcde std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(0)
```

### Censoring the Weights and Using 1000 Bootstrap Replications
```stata
. ipwcde std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(0) censor reps(1000)
```

### Reporting Detailed Output
```stata
. ipwcde std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(0) rcensor detail reps(1000) 
```

### Adjusting for Exposure-Induced Confounders
```stata
. ipwcde std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) lvars(cesd_1992) d(1) dstar(0) m(0) censor detail reps(1000) 
```

## Saved Results

`ipwcde` saves the estimated controlled direct effect in `e(b)`:

## Author

**Geoffrey T. Wodtke**  
Department of Sociology  
University of Chicago  
Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

Wodtke GT, and Zhou X. *Causal Mediation Analysis*. In preparation.

## Also See

- [manhelp logit](#)
- [manhelp bootstrap](#)
