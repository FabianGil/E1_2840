*******Trabajo 1

**** Combinar los archivos de datos para crear una base de datos con todos los registros y variables del estudio
        *Importar la base uno en formato xls a dta

     import excel "Base1(4).xls", sheet("base1") firstrow

     save "Base1.1.dta"

     clear

    *Importar la base dos en formato csv a dta

     import delimited Base2.csv, delimiter(comma)
     save "Base2.1.dta"
	 
     clear

    *Combinar las bases uno y dos

     use "Base1.1.dta"

     append using "Base2.1.dta"
     save "Base4.dta"

    *Arreglar la fecha de la base combinada

     gen fnac =date(var7, "MDY")

     save "Base4.dta", replace

     clear
   
    *Arreglar la fecha de la base tres

     use "Base3.dta"

     gen fac = date(var9, "DMY")

     save "Base3.dta", replace

     clear

    *Combinar la base combinada con la base tres
 
    use "Base4.dta"

     merge 1:1 var1 using "Base3.dta"

     save "Base4.dta", replace 



**** Nombrar y rotular variables

    *Nombrar y rotular variable uno
 
     rename var1 paid

      label variable paid "Id paciente"

    *Nombrar y rotular variable dos

      rename var2 sexo

      la var sexo "Sexo del paciente"

    *Nombrar y rotular variable tres

      rename var3 dolpecho

      la var dolpecho "Tipo de dolor de pecho"
    *Nombrar y rotular variable cuatro
      rename var4 pss

      la var pss "Presión sanguínea sistólica"

    *Nombrar y rotular variable cinco

      rename var5 colse

      la var colse "Colesterol sérico"

    *Nombrar y rotular variable seis

      rename var6 resel

      la var resel "Resultados electrocardiográficos en reposo"
    *Nombrar y rotular variable siete

      rename var7 fnaci

      la var fnaci "Fecha de nacimiento inicial"

    *Rotular fnac (variable con el formato de fecha corregido)

      la var fnac "Fecha de nacimiento"
	
    *Nombrar y rotular variable ocho

      rename var8 estenf
	  
      la var estenf "Diagnóstico de la enfermedad cardíaca (Estado de la enfermedad angiográfica)"

    *Nombrar y rotular variable siete

      rename var9 faci
	 
      la var faci "Fecha de la angiografía inicial"
	
    *Rotular fac (variable con el formato de fecha corregido)
	  
      la var fac "Fecha de la angiografía coronaria"
  
*Guardar los cambios realizados
  
save "Base4.dta", replace




**** Rotular variables categóricas

   *Rotular variable sexo
     la define lblsexo 0 "Femenino" 1 "Masculino"
     la values sexo lblsexo
 
      *Revisar rótulo generado
      
        tab sexo
   
   *Rotular variable dolpecho
     la define lbldolpecho 1 "Angina típica" 2 "Angina atípica" 3 "Dolor no anginal" 4 "Asintomático"
	  
     la values dolpecho lbldolpecho

      *Revisar rótulo generado

       tab dolpecho
    
   *Rotular variable resel

     la define lblresel 0 "Normal" 1 "Anomalía de la onda ST-T" 2 "Mostrando hipertrofia ventricular izquierda probable o  definida"
	   
     la values resel lblresel

      *Revisar rótulo generado

        tab resel
   *Rotular variable estenf
     la define lblestenf 0 "<50% de estrechez del diámetro" 1 ">50% de estrechez del diámetro"

     la values estenf lblestenf

      *Revisar rótulo generado

        tab estenf
  
 *Guardar los cambios realizados
  save "Base4.dta", replace
		


**** Categorizar la presión arterial sistólica
 
    *Cambiar variable str a int

      destring pss, replace force float

    *Categorizar la presión arterial sistólica
 
     egen float pss1 = cut(pss), at(0 90 130 140 160 180) icodes

       *Rotular variable generada
 
      la define lblpss1 1"Hipotensión" 2 "Deseada/Normal" 3 "Prehipertensión" 4 "Hipertensión grado 1" 5 "Hipertensión grado 2" 6 "Crisis hipertensiva"
     
       la values pss1 lblpss1

        *Revisar variable generada

          tab pss1
	
	

**** Generar una variable con la edad de los pacientes al momento de la angiografía coronaria
     
     *Utilizar el comando int para que  se presenten números enteros, no decimales
     
     gen edadpac =int(((fac-fnac)/365.25))

     *Revisar variable generada

        tab edadpac
     *Guardar los cambios realizados

      save "Base4.dta", replace



**** Describir los pacientes del estudio de acuerdo a la edad y sexo
 
     *Describir los pacientes del estudio de acuerdo a la edad
 
        summarize edadpac, detail

      *Describir los pacientes del estudio de acuerdo al sexo
        tab sexo

      *Generar un gráfico

       *Generar un diagrama de cajas y bigotes 
	    
         graph box edadpac, ytitle(Edad paciente) by(, title(Edad de los pacientes respecto al sexo)) by(sexo)

	 *Generar un histograma

	   histogram edadpac, normal by (, title(Distribución de la edad respecto al sexo)) by (sexo)
		


****Describir el diagnóstico de enfermedad coronaria de acuerdo al tipo de dolor torácico presentado 
	 
     tabulate estenf dolpecho, chi2 column
	 
	 

     *Guardar los cambios realizados

      save "Base4.dta", replace	
		
		
		
		
		
		
