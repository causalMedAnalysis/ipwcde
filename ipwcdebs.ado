*!TITLE: IPWCDE - analysis of controlled direct effects using inverse probability weighting	
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!

program define ipwcdebs, rclass
	
	version 15	

	syntax varname(numeric) [if][in], ///
		dvar(varname numeric) ///
		mvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		m(real) ///
		[cvars(varlist numeric)] ///
		[lvars(varlist numeric)] ///
		[sampwts(varname numeric)] ///
		[censor] ///
		[detail]
	
	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
		local N = r(N)
		}
			
	local yvar `varlist'

	tempvar wts
	qui gen `wts' = 1 if `touse'
	
	if ("`sampwts'" != "") {
		qui replace `wts' = `wts' * `sampwts'
		qui sum `wts'
		qui replace `wts' = `wts' / r(mean)
		}
	
	di ""
	di "Model for `dvar' conditional on cvars:"
	logit `dvar' `cvars' [pw=`wts'] if `touse'
	tempvar phat_D1_C phat_D0_C
	qui predict `phat_D1_C' if e(sample), pr
	qui gen `phat_D0_C'=1-`phat_D1_C' if `touse'
	
	di ""
	di "Model for `mvar' conditional on {cvars, `dvar', `lvars'}:"
	logit `mvar' `dvar' `cvars' `lvars' [pw=`wts'] if `touse'
	tempvar phat_M1_CDL phat_M0_CDL
	qui predict `phat_M1_CDL' if e(sample), pr
	qui gen `phat_M0_CDL'=1-`phat_M1_CDL' if `touse'
	
	qui logit `dvar' [pw=`wts'] if `touse'
	tempvar phat_D1 phat_D0
	qui predict `phat_D1' if e(sample), pr
	qui gen `phat_D0'=1-`phat_D1' if `touse'
	
	qui logit `mvar' `dvar' [pw=`wts'] if `touse'
	tempvar phat_M1_D phat_M0_D
	qui predict `phat_M1_D' if e(sample), pr
	qui gen `phat_M0_D'=1-`phat_M1_D' if `touse'

	tempvar sw4
		
	qui gen `sw4' = (`phat_D`d'' / `phat_D`d'_C') if `dvar'==`d' & `touse'
	qui replace `sw4' = (`phat_D`dstar'' / `phat_D`dstar'_C') if `dvar'==`dstar' & `touse'
	qui replace `sw4' = `sw4' * ///
		(((`mvar'*`phat_M1_D')+((1-`mvar')*`phat_M0_D')) / ((`mvar'*`phat_M1_CDL')+((1-`mvar')*`phat_M0_CDL'))) if `touse'
		
	if ("`censor'"!="") {
		qui centile `sw4' if `sw4'!=. & `touse', c(1 99) 
		qui replace `sw4' = r(c_1) if `sw4'<r(c_1) & `sw4'!=. & `touse'
		qui replace `sw4' = r(c_2) if `sw4'>r(c_2) & `sw4'!=. & `touse'
		}
	
	qui replace `sw4' = `sw4' * `wts' if `touse'
	
	tempvar inter
	qui gen `inter' = `dvar' * `mvar' if `touse'
	
	di ""
	di "Model for Y(d,m) fit using IPWs:"
	reg `yvar' `dvar' `mvar' `inter' [pw=`sw4'] if `touse'		
	return scalar cde=(_b[`dvar']+(_b[`inter']*`m'))*(`d'-`dstar')
		
	if ("`detail'"!="") {
		local ipw_var_names "sw4_r001"
		foreach name of local ipw_var_names {
			capture confirm new variable `name'
			if _rc {
				display as error "{p 0 0 5 0}The command needs to create a weight variable"
				display as error "with the following name: `ipw_var_names', "
				display as error "but this variable has already been defined.{p_end}"
				error 110
				}
			}
		qui gen sw4_r001 = `sw4'
		}

end ipwcdebs
