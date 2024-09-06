*!TITLE: IPWCDE - analysis of controlled direct effects using inverse probability weighting	
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!

program define ipwcde, eclass

	version 15	

	syntax varlist(min=1 max=1 numeric) [if][in], ///
		dvar(varname numeric) ///
		mvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		m(real) ///
		[cvars(varlist numeric)] ///
		[lvars(varlist numeric)] ///
		[sampwts(varname numeric)] ///
		[reps(integer 200)] ///
		[strata(varname numeric)] ///
		[cluster(varname numeric)] ///
		[level(cilevel)] ///
		[seed(passthru)] ///
		[saving(string)] ///
		[censor] ///
		[detail]

	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
	}
	
	foreach i in `dvar' `mvar' {
		confirm variable `i'
		qui levelsof `i', local(levels)
		if "`levels'" != "0 1" & "`levels'" != "1 0" {
			display as error "The variable `i' is not binary and coded 0/1"
			error 198
		}
	}

	/***REPORT MODELS AND SAVE WEIGHTS IF REQUESTED***/
	if ("`detail'" != "") {
		
		ipwcdebs `varlist' if `touse', ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') lvars(`lvars') ///
			d(`d') dstar(`dstar') m(`m') sampwts(`sampwts') `censor' `detail'
	
		label var sw4_r001 "IPW for estimating E(Y(d,m))"
		}
	
	/***COMPUTE POINT AND INTERVAL ESTIMATES***/
	if ("`saving'" != "") {
		bootstrap CDE=r(cde), ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			saving(`saving', replace) noheader notable: ///
			ipwcdebs `varlist' if `touse', ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') lvars(`lvars') ///
			d(`d') dstar(`dstar') m(`m') sampwts(`sampwts') `censor' 
		}

	if ("`saving'" == "") {
		bootstrap CDE=r(cde), ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			noheader notable: ///
			ipwcdebs `varlist' if `touse', ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') lvars(`lvars') ///
			d(`d') dstar(`dstar') m(`m') sampwts(`sampwts') `censor' 
		}
			
	estat bootstrap, p noheader
	
end ipwcde
