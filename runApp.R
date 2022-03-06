### install packages ###
list.of.packages<-c('shiny','shinythemes','tidyverse','reticulate','shinyFiles','coda','dplyr','shinyWidgets','htmltools','data.table','foreach','doParallel','parallel','bigstatsr')
new.packages<-list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {for (i in new.packages) {install.packages(i)}}

### library packages ###
library(shiny)
library(shinythemes)
library(reticulate) # python
library(foreach)    # multicore
library(doParallel) # multicore
library(parallel)   # multicore
library(bigstatsr)  # multicore

### Miniconda ###
install_miniconda()
py_install('pandas')

### multi core ###
multicore = detectCores() - 1 # 자신의 코어_doParallel 패키지 include
cluster = makeCluster(spec = multicore) # 클러스터 제작.
registerDoParallel(cl = cluster) # 클러스터 등록

### file load ###
source("func.R")
source("tabs/ui/home_ui.R",local=T)
source("tabs/ui/plot_ui.R",local=T)
source("tabs/ui/bt_ui.R",local=T)
source("tabs/ui/mcmc_ui.R",local=T)
source("tabs/ui/splitting_times_ui.R",local=T)
source("tabs/ui/ct_ui.R",local=T)
source("tabs/ui/about_ui.R",local=T)

#### Code ####
ui<-fluidPage(
  navbarPage(title="HELLO!!",
               id='navbar',
               theme=shinytheme("sandstone"),
               tags$head(tags$style(HTML('.navbar-static-top {background-color: #334257;}',' .navbar-default { #334257;}',
                                         '.well {background-color: #F2F1ED;}','.navbar-default .navbar-nav>li>a {color: #ffffff;}',
                                         '.navbar-default .navbar-nav>.active>a, .navbar-default .navbar-nav>.active>a:hover, 
                                         .navbar-default .navbar-nav>.active>a:focus  {background-color: #11324D;}',
                                         '.btn-default {background-color: #11324D;}',
                                         '.btn-default.active {background-color: #11324D;}', 
                                         '.btn-default:focus, .btn-default.focus {background-color: #11324D;}',
                                         '.btn-default:hover {background-color: #11324D;}',
                                         '.btn-default:active:hover, .btn-default.active:hover, .open>.dropdown-toggle.btn-default:hover, .btn-default:active:focus, .btn-default.active:focus, .open>.dropdown-toggle.btn-default:focus, .btn-default:active.focus, .btn-default.active.focus, .open>.dropdown-toggle.btn-default.focus {background-color: #4B6587;}',
                                         '.btn-default:active, .btn-default.active, .open>.dropdown-toggle.btn-default {background-color: #4B6587;}',
                                         '.well {background-color: #f0e9df;}',
                                         '.btn-default .irs--shiny .irs-bar .label-info {background-color: #F7F6F2;}'))),
  
               selected='home',
               fluid=T,
               
               # tabs
               home,
               plot,
               bt,
               mcmc, # NEW CODE
               st,
               ct,
               about
               #tabPanel("ABOUT US",value='about')
               ))

server<-function(input,output,session){
  source("tabs/server/home_server.R",local=T)
  source("tabs/server/plot_server.R",local=T)
  source("tabs/server/bt_server.R",local=T)
  source("tabs/server/mcmc_server.R",local=T)
  source("tabs/server/splitting_times_server.R",local=T)
  source("tabs/server/ct_server.R",local=T)
}

### RunApp ###
shinyApp(ui,server)




### Process END ###
### Stop Cluster ###
stopCluster(cluster)
# 기존에 실행중인 클러스터를 종료시킴, 없으면 에러메세지 나오고 계속실행.
# 문장 맨뒤에 넣고 실행시, 한번에 실행시킬때 중간에 프로세스가 종료됨.



