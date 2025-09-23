****************************************************
* PARTE 2 – CÓDIGO COMPLETO ACTUALIZADO (P2.2.1–P2.2.5)
* Solo EXP2 (Herrmann et al. 2008): N = sin castigo, P = con castigo
* Incluye fix de postfile (expresiones entre paréntesis)
****************************************************

clear all
set more off
version 18

*---------------------------------------------------
* 0) RUTA DE DATOS
*---------------------------------------------------
local url_exp2 "https://raw.githubusercontent.com/fgsfhsgdfdg/Taller4-Haciendo-Economia-1/90383a615bc826f8e48d50cf631d3932aa0c35c1/Data/Raw/doing-economics-datafile-working-in-excel-project-2.xlsx"

****************************************************
* A) EXP2 – N (A2:Q12) y P (A16:Q26) -> formato long
****************************************************

* --- N: sin castigo ---
import excel using "`url_exp2'", sheet("Public goods contributions") cellrange(A2:Q12) firstrow clear
capture confirm numeric variable Period
if _rc destring Period, replace force
rename (Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne) ///
       (city_Copenhagen city_Dnipropetrovsk city_Minsk city_StGallen city_Muscat city_Samara city_Zurich city_Boston city_Bonn city_Chengdu city_Seoul city_Riyadh city_Nottingham city_Athens city_Istanbul city_Melbourne)
reshape long city_, i(Period) j(Ciudad) string
rename city_ contribucion
capture confirm numeric variable contribucion
if _rc destring contribucion, replace force
drop if missing(contribucion)
gen byte castigo = 0   // N
tempfile N_long
save `N_long', replace

* --- P: con castigo ---
import excel using "`url_exp2'", sheet("Public goods contributions") cellrange(A16:Q26) firstrow clear
capture confirm numeric variable Period
if _rc destring Period, replace force
rename (Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne) ///
       (city_Copenhagen city_Dnipropetrovsk city_Minsk city_StGallen city_Muscat city_Samara city_Zurich city_Boston city_Bonn city_Chengdu city_Seoul city_Riyadh city_Nottingham city_Athens city_Istanbul city_Melbourne)
reshape long city_, i(Period) j(Ciudad) string
rename city_ contribucion
capture confirm numeric variable contribucion
if _rc destring contribucion, replace force
drop if missing(contribucion)
gen byte castigo = 1   // P
tempfile P_long
save `P_long', replace

* Unir N y P
use `N_long', clear
append using `P_long'
label define castigo_lab 0 "Sin castigo (N)" 1 "Con castigo (P)"
label values castigo castigo_lab
tempfile NP_long
save `NP_long', replace


****************************************************
* B) P2.2.1 – Medias por período y gráfico líneas (N vs P)
****************************************************
use `NP_long', clear
collapse (mean) contribucion_promedio = contribucion, by(Period castigo)
tempfile means_all
save `means_all', replace

preserve
keep if castigo==0
rename contribucion_promedio N_mean
tempfile N_mean_by_period
save `N_mean_by_period', replace
restore

keep if castigo==1
rename contribucion_promedio P_mean
tempfile P_mean_by_period
save `P_mean_by_period', replace

use `N_mean_by_period', clear
merge 1:1 Period using `P_mean_by_period', nogen

twoway ///
    (line N_mean Period, lcolor(navy) lwidth(medthick) lpattern(solid)) ///
    (line P_mean Period, lcolor(maroon) lwidth(medthick) lpattern(solid)), ///
    title("Contribución promedio por período: N vs P") ///
    xtitle("Período (1–10)") ytitle("Contribución promedio") ///
    legend(order(1 "Sin castigo (N)" 2 "Con castigo (P)") pos(6) ring(0))


****************************************************
* C) P2.2.2 – Barras: promedio en P1 y P10 (N vs P)
****************************************************
use `N_mean_by_period', clear
keep if inlist(Period,1,10)
rename N_mean contribucion_promedio
gen str12 exp = "N"
tempfile N_p1p10
save `N_p1p10', replace

use `P_mean_by_period', clear
keep if inlist(Period,1,10)
rename P_mean contribucion_promedio
gen str12 exp = "P"
append using `N_p1p10'

graph bar contribucion_promedio, over(exp) over(Period) ///
 blabel(bar, format(%4.1f)) ///
 ytitle("Contribución promedio") ///
 title("Contribución promedio – Períodos 1 y 10 (N vs P)") ///
 ylabel(0(10)100, angle(0)) yscale(range(0 100)) ///
 graphregion(color(white)) plotregion(color(white))
graph export "P222_bar_p1p10_NvsP.png", replace width(2000)


****************************************************
* D) P2.2.3 y P2.2.4 – SD, min, max (P1 y P10) + regla ±2*SD
****************************************************

* --- N: descriptivos P1 y P10 (entre ciudades) ---
use `N_long', clear
keep if inlist(Period,1,10)
collapse (mean) mean=contribucion (sd) sd=contribucion (min) min=contribucion (max) max=contribucion, by(Period)
gen var   = sd^2
gen rango = max - min
gen str6 grupo = "N"
tempfile N_desc_p1p10
save `N_desc_p1p10', replace

* Regla ±2*SD para N (postfile con paréntesis)
tempname Npost
tempfile N_rule
postfile `Npost' int Period double prop_inside_2sd_N using "`N_rule'", replace
foreach p of numlist 1/10 {
    use `N_long', clear
    keep if Period==`p'
    quietly summarize contribucion
    scalar m = r(mean)
    scalar s = r(sd)
    gen byte inside = inrange(contribucion, m - 2*s, m + 2*s)
    quietly summarize inside
    post `Npost' (`p') (r(mean))
}
postclose `Npost'

* --- P: descriptivos P1 y P10 (entre ciudades) ---
use `P_long', clear
keep if inlist(Period,1,10)
collapse (mean) mean=contribucion (sd) sd=contribucion (min) min=contribucion (max) max=contribucion, by(Period)
gen var   = sd^2
gen rango = max - min
gen str6 grupo = "P"
tempfile P_desc_p1p10
save `P_desc_p1p10', replace

* Regla ±2*SD para P (postfile con paréntesis)
tempname Ppost
tempfile P_rule
postfile `Ppost' int Period double prop_inside_2sd_P using "`P_rule'", replace
foreach p of numlist 1/10 {
    use `P_long', clear
    keep if Period==`p'
    quietly summarize contribucion
    scalar m = r(mean)
    scalar s = r(sd)
    gen byte inside = inrange(contribucion, m - 2*s, m + 2*s)
    quietly summarize inside
    post `Ppost' (`p') (r(mean))
}
postclose `Ppost'

* (Opcional) mostrar proporciones de la regla práctica
use "`N_rule'", clear
format prop_inside_2sd_N %5.2f
sort Period
list Period prop_inside_2sd_N, noobs clean
use "`P_rule'", clear
format prop_inside_2sd_P %5.2f
sort Period
list Period prop_inside_2sd_P, noobs clean


****************************************************
* E) P2.2.5 – Tabla resumen (P1 y P10): media, var, SD, min, max, rango
****************************************************
use `N_desc_p1p10', clear
append using `P_desc_p1p10'
order grupo Period mean var sd min max rango
sort grupo Period
label var mean  "Media"
label var var   "Varianza"
label var sd    "Desviación estándar"
label var min   "Mínimo"
label var max   "Máximo"
label var rango "Rango"
export delimited using "P225_tabla_descriptivos_p1p10_N_P.csv", replace

* (Opcional) mostrar en consola con formatos
format mean %8.2f var %8.2f sd %6.2f min %6.1f max %6.1f rango %6.1f
list grupo Period mean var sd min max rango, noobs clean

****************************************************
* FIN
****************************************************
