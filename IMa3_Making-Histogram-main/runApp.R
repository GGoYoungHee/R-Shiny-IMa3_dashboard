### install packages ###
list.of.packages<-c('shiny','shinythemes','tidyverse','reticulate','shinyFiles')
new.packages<-list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

library(shiny)
library(shinythemes)
library(reticulate)


### Miniconda ###
install_miniconda()
py_install('pandas')


### file load ###
source("func.R")
source("tabs/ui/home.R",local=T)
source("tabs/ui/plot.R",local=T)
source("tabs/ui/bt.R",local=T)


ui<-fluidPage(
  navbarPage(title="HELLO!!",
               id='navbar',
               theme=shinytheme("superhero"),
               selected='home',
               fluid=T,
               
               # tabs
               home,
               plot,
               bt,              
               tabPanel("ABOUT US",value='about')
               ))

server<-function(input,output,session){
  source("tabs/server/home.R",local=T)
  source("tabs/server/plot.R",local=T)
  source("tabs/server/bt.R",local=T)
}

shinyApp(ui,server)




