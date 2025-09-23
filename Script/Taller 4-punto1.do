* Nathalie Arboleda, David Catral, Isaac Suarez
**#PARTE 1
* 1) Importar
import excel using "https://raw.githubusercontent.com/nathaliearboleda/Taller4-Haciendo-Economia/ea6d54cce6a80e2fe6e930548a54f4e00dea52b3/Data/Raw/juego20252%20haciendo%20econ%20(1).xlsx", sheet("Hoja1") firstrow clear


* 2) Renombrar variables
rename Playerscontri~s  contribucion

* Convertir a numérico (solo si describe muestra que es string)
destring contribucion, replace force
destring Round, replace force

replace Round = Round[_n-1] if missing(Round)

* Promedio por ronda
collapse (mean) contribucion_promedio = contribucion, by(Round)

* Gráfico
twoway connected contribucion_promedio Round, ///
    xtitle("Periodo") ytitle("Contribución promedio") ///
    title("Contribución promedio por ronda")