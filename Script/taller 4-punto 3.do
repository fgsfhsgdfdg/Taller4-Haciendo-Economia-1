*periodo 1 

*sin castigo
import excel using "https://raw.githubusercontent.com/fgsfhsgdfdg/Taller4-Haciendo-Economia-1/90383a615bc826f8e48d50cf631d3932aa0c35c1/Data/Raw/doing-economics-datafile-working-in-excel-project-2.xlsx", sheet("Public goods contributions") cellrange(A2:Q12) firstrow clear

* Renombrar variable
rename Period Periodo

* filtar por Periodo 1
keep if Periodo == 1

* Renombrar todas las variables con prefijo ciudad_
rename (Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)(ciudad_Copenhagen ciudad_Dnipropetrovsk ciudad_Minsk ciudad_StGallen ciudad_Muscat ciudad_Samara ciudad_Zurich ciudad_Boston ciudad_Bonn ciudad_Chengdu ciudad_Seoul ciudad_Riyadh ciudad_Nottingham ciudad_Athens ciudad_Istanbul ciudad_Melbourne)

* pivor longer
reshape long ciudad_, i(Period) j(Ciudad) string

* Cambiar el nombre de la variable de valores
rename ciudad_ contribucion

* indentificador de sin castigo (0)
gen castigo = 0

* Guardar
save sin_castigo1, replace


* con castigo
import excel using "https://raw.githubusercontent.com/fgsfhsgdfdg/Taller4-Haciendo-Economia-1/90383a615bc826f8e48d50cf631d3932aa0c35c1/Data/Raw/doing-economics-datafile-working-in-excel-project-2.xlsx", sheet("Public goods contributions") cellrange(A16:Q26) firstrow clear
rename Period Periodo

* filtar por Periodo 1
keep if Periodo == 1

* Renombrar todas las variables con prefijo ciudad_
rename (Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)(ciudad_Copenhagen ciudad_Dnipropetrovsk ciudad_Minsk ciudad_StGallen ciudad_Muscat ciudad_Samara ciudad_Zurich ciudad_Boston ciudad_Bonn ciudad_Chengdu ciudad_Seoul ciudad_Riyadh ciudad_Nottingham ciudad_Athens ciudad_Istanbul ciudad_Melbourne)

* pivor longer
reshape long ciudad_, i(Period) j(Ciudad) string

* Cambiar el nombre de la variable de valores
rename ciudad_ contribucion

* indentificador de con castigo (1)
gen castigo = 1

* Guardar 
save con_castigo1, replace


* Abrir base de sin castigo
use sin_castigo1, clear

* Unir bases
append using con_castigo1

* Prueba t
ttest contribucion, by(castigo)


*##########################################################

*perido 10



*sin castigo
import excel using "https://raw.githubusercontent.com/fgsfhsgdfdg/Taller4-Haciendo-Economia-1/90383a615bc826f8e48d50cf631d3932aa0c35c1/Data/Raw/doing-economics-datafile-working-in-excel-project-2.xlsx", sheet("Public goods contributions") cellrange(A2:Q12) firstrow clear

* Renombrar variable
rename Period Periodo

* filtar por Periodo 10
keep if Periodo == 10

* Renombrar todas las variables con prefijo ciudad_
rename (Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)(ciudad_Copenhagen ciudad_Dnipropetrovsk ciudad_Minsk ciudad_StGallen ciudad_Muscat ciudad_Samara ciudad_Zurich ciudad_Boston ciudad_Bonn ciudad_Chengdu ciudad_Seoul ciudad_Riyadh ciudad_Nottingham ciudad_Athens ciudad_Istanbul ciudad_Melbourne)

* pivor longer
reshape long ciudad_, i(Period) j(Ciudad) string

* Cambiar el nombre de la variable de valores
rename ciudad_ contribucion

* indentificador de sin castigo (0)
gen castigo = 0

* Guardar
save sin_castigo10, replace


* con castigo
import excel using "https://raw.githubusercontent.com/fgsfhsgdfdg/Taller4-Haciendo-Economia-1/90383a615bc826f8e48d50cf631d3932aa0c35c1/Data/Raw/doing-economics-datafile-working-in-excel-project-2.xlsx", sheet("Public goods contributions") cellrange(A16:Q26) firstrow clear
rename Period Periodo

* filtar por Periodo 10
keep if Periodo == 10

* Renombrar todas las variables con prefijo ciudad_
rename (Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)(ciudad_Copenhagen ciudad_Dnipropetrovsk ciudad_Minsk ciudad_StGallen ciudad_Muscat ciudad_Samara ciudad_Zurich ciudad_Boston ciudad_Bonn ciudad_Chengdu ciudad_Seoul ciudad_Riyadh ciudad_Nottingham ciudad_Athens ciudad_Istanbul ciudad_Melbourne)

* pivor longer
reshape long ciudad_, i(Period) j(Ciudad) string

* Cambiar el nombre de la variable de valores
rename ciudad_ contribucion

* indentificador de con castigo (1)
gen castigo = 1

* Guardar 
save con_castigo10, replace


* Abrir base de sin castigo
use sin_castigo10, clear

* Unir bases
append using con_castigo10

* Prueba t
ttest contribucion, by(castigo)

