library("RSelenium")
library(stringi)

remDr = RSelenium::rsDriver(browser = "firefox")

client = remDr$client

baseURL = "http://www.portaltransparencia.gov.br/downloads/mensal.asp?c=FavorecidosGastosDiretos"

client$navigate(baseURL)

exercicios = 2011:2017
exercicios = paste0("exercicios",exercicios)

meses = 1:12
meses = stri_pad_left(meses,2,'0')
meses = paste0("meses", meses)

lapply(exercicios, function(exercicioId){
  welExercicio = client$findElement(using = 'id', value = exercicioId)
  welExercicio$clickElement()
  
  lapply(meses, function(mesesId){
    welMeses = client$findElement(using = 'id', value = mesesId) 
    welMeses$clickElement()
    
    Sys.sleep(1)
  })
})




