#library(shiny)
#library(shinydashboard)
library(reticulate)
library(shinyFiles)

# setwd('C:/Users/rhtn2/OneDrive/Documents/연구조교/02. Rshiny project')
# source_python('./IMa3_BrnThn-master/IMa3_BrnThn-master/[Pycharm] IMa3_BrnThn2.py')

# load the python script to run this page 
source_python('./tabs/server/[Pycharm] IMa3_BrnThn2.py') 


options(shiny.maxRequestSize=30*1024^2)
volumes = getVolumes() # this makes the directory at the base of your computer.
  
observe({
    
  shinyFileChoose(input, "input_dir", roots = volumes, session = session)
  })
  
txt_file <- reactive({
  if(!is.null(input$input_dir)){
    # browser()
    file_selected<-parseFilePaths(volumes, input$input_dir)
    output$txt_file <- renderText(as.character(file_selected$datapath))
    }
    as.character(file_selected$datapath)
    })
  
save_dir <- reactive({
  slash <- gregexpr('/',txt_file())[[1]]
  substr(txt_file(), 1, slash[length(slash)])
  })
  
output_dir <- reactive({
  paste(save_dir(), input$output_name, sep='')
  })
  
  
observeEvent(input$go, {
  dupl <- sum(list.files(path=save_dir())==input$output_name)
  
    if(dupl==0){
      BrnThn(input_dir = txt_file(), out_dir=output_dir() ,Brn=input$Brn, Thn=input$Thn)
      
      output$out_dir <- renderText(input$output_dir)
      output$running_mes <- renderText("Check your file")
      
    }else if(dupl!=0){
      output$running_mes <- renderText("The data name you entered is duplicated. Please change the ouput data name")
    }
  })
