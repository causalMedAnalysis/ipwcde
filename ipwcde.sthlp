{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for ipwcde}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:ipwcde} {hline 2}}analysis of controlled direct effects using inverse probability weighting {p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:ipwcde} {depvar} {ifin}{cmd:,} 
{opt dvar(varname)} 
{opt mvar(varname)}
{opt d(real)}
{opt dstar(real)}
{opt m(real)} 
{opt cvars(varlist)}
{opt lvars(varlist)}
{opt sampwts(varname)} 
{opt censor}
{opt detail}
[{it:{help bootstrap##options:bootstrap_options}}]

{phang}{opt depvar} - this specifies the outcome variable.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable, which must be binary (0/1).

{phang}{opt mvar(varname)} - this specifies the mediator variable, which must be binary (0/1).

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{phang}{opt m(real)} - this specifies the level of the mediator at which the controlled direct effect is evaluated.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies a list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt lvars(varlist)} - this option specifies a list of post-treatment covariates (i.e., exposure-induced confounders) 
to be included in the mediator model. Categorical variables need to be coded as a series of dummy variables.

{phang}{opt sampwts(varname)} - this option specifies a variable containing sampling weights to include in the analysis.

{phang}{opt censor} - this option specifies that the inverse probability weights are censored at their 1st and 99th percentiles.

{phang}{opt detail} - this option prints the fitted models for the exposure, mediator, and outcome, and it also saves a new variable
containing the inverse probability weights used to fit the outcome model and compute the estimated CDE. {p_end}

{phang}{it:{help bootstrap##options:bootstrap_options}} - all {help bootstrap} options are available. {p_end}

{title:Description}

{pstd}{cmd:ipwcde} estimates controlled direct effects using inverse probability weighting, and it computes inferential statistics using the nonparametric bootstrap. {p_end}

{pstd}Two models are estimated to construct the weights: a logit model for the exposure conditional on the 
baseline covariates (if specified), and another logit model for the mediator conditional on the exposure, the 
baseline covariates, and any exposure-induced confounders (if specified). {p_end}

{pstd}{cmd:ipwcde} provides estimates of the controlled direct effect. It also generates a new variable containing the 
inverse probability weights used to compute these effect estimates, if requested with {opt detail}. {p_end}

{pstd}If using {opt sampwts} from a complex sample design that require rescaling to produce valid boostrap estimates, be sure to appropriately 
specify the strata(), cluster(), and size() options from the {help bootstrap} command so that Nc-1 clusters are sampled from each stratum 
with replacement, where Nc denotes the number of clusters per stratum. Failing to properly adjust the bootstrap procedure to account
for a complex sample design and its associated sampling weights could lead to invalid inferential statistics. {p_end}


{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

{pstd} percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ipwcde std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) m(0)} {p_end}

{pstd} percentile bootstrap CIs with 1000 replications and censored weights: {p_end}
 
{phang2}{cmd:. ipwcde std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) m(0) censor reps(1000)} {p_end}

{pstd} percentile bootstrap CIs with 1000 replications, censored weights, and detailed output: {p_end}
 
{phang2}{cmd:. ipwcde std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) m(0) censor detail reps(1000)} {p_end}

{pstd} percentile bootstrap CIs with 1000 replications, censored weights, and adjustment for an exposure-induced confounder: {p_end}
 
{phang2}{cmd:. ipwcde std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	lvars(cesd_1992) d(1) dstar(0) m(0) censor reps(1000) } {p_end}

{title:Saved results}

{pstd}{cmd:ipwcde} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing the effect estimate{p_end}


{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu


{title:References}

{pstd}Wodtke, GT and X Zhou. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp logit R}, {manhelp bootstrap R}
{p_end}
