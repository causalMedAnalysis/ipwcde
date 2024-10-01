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
		[cvars(varlist numeric) ///
		lvars(varlist numeric) ///
		sampwts(varname numeric) ///
		censor(numlist min=2 max=2) ///
		detail * ]

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

	if ("`censor'" != "") {
		local censor1: word 1 of `censor'
		local censor2: word 2 of `censor'

		if (`censor1' >= `censor2') {
			di as error "The first number in the censor() option must be less than the second."
			error 198
		}

		if (`censor1' < 1 | `censor1' > 49) {
			di as error "The first number in the censor() option must be between 1 and 49."
			error 198
		}

		if (`censor2' < 51 | `censor2' > 99) {
			di as error "The second number in the censor() option must be between 51 and 99."
			error 198
		}
	}
	
	if ("`detail'" != "") {
		
		ipwcdebs `varlist' if `touse', dvar(`dvar') mvar(`mvar') d(`d') dstar(`dstar') m(`m') ///
			cvars(`cvars') lvars(`lvars') sampwts(`sampwts') censor(`censor') `detail'
	
		label var sw4_r001 "IPW for estimating E(Y(d,m))"
		}
	
	bootstrap ///
		CDE=r(cde), ///
			`options' noheader notable: ///
				ipwcdebs `varlist' if `touse', dvar(`dvar') mvar(`mvar') d(`d') dstar(`dstar') m(`m') ///
					cvars(`cvars') lvars(`lvars') sampwts(`sampwts') censor(`censor')
			
	estat bootstrap, p noheader
	
end ipwcde
