library(reticulate)
library(shinyFiles)

# load the python script to run this page 
source_python('./tabs/server/[Pycharm] IMa3_BrnThn2.py') 


options(shiny.maxRequestSize=30*1024^2)
volumes = getVolumes() # this makes the directory at the base of your computer.
#volumes = c(Documents = "C:/Users")
volumes=c('wd'='.')




observe({
  #shinyFileChoose(input, "bt_file",  roots = c(Documents = "C:/Users"), session = session) 이렇게 하면 C:Users에서 시작 
  #shinyFileChoose(input, "bt_file", roots = volumes, session = session) #,filetype=c('ti') 
  shinyFileChoose(input, "bt_file", roots=volumes, session = session)  
  })
  
txt_file <- reactive({
  if(!is.null(input$bt_file)){
    # browser()
    file_selected<-parseFilePaths(volumes, input$bt_file)
    output$txt_file <- renderText(as.character(file_selected$datapath))
    }
    as.character(file_selected$datapath)
    })

#파일명 추출
file_selected<-reactive({parseFilePaths(volumes, input$bt_file)
})

output$file_name <- renderText({
  return(paste(as.character(file_selected()$name)))
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
      
      #output$out_dir <- renderText(input$output_dir) #input directory
      output$out_dir <- renderText(output_dir()) #output directory
      output$running_mes <- renderText("Check your file")
      
    }else if(dupl!=0){
      output$running_mes <- renderText("The data name you entered is duplicated. Please change the ouput data name")
    }
  })
