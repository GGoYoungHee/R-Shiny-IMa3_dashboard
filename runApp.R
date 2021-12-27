### install packages ###
list.of.packages<-c('shiny','shinythemes','tidyverse','reticulate','shinyFiles','coda','dplyr')
new.packages<-list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

### library packages ###
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
source("tabs/ui/about.R",local=T)
source("tabs/ui/mcmc.R",local=T)

#### Code ####
ui<-fluidPage(
  navbarPage(title="HELLO!!",
               id='navbar',
               theme=shinytheme("sandstone"),
               selected='home',
               fluid=T,
               
               # tabs
               home,
               plot,
               bt,
               mcmc, # NEW CODE
               about
               #tabPanel("ABOUT US",value='about')
               ))

server<-function(input,output,session){
  source("tabs/server/home.R",local=T)
  source("tabs/server/plot.R",local=T)
  source("tabs/server/bt.R",local=T)
  source("tabs/server/mcmc.R",local=T)
}

shinyApp(ui,server)




