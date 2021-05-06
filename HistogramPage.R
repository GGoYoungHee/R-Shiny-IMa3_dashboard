library(shiny)
library(readxl)
library(tidyverse)


ui<-fluidPage(
  titlePanel("Make a Histogram for IMa3 Result"),
  
  sidebarLayout(
    sidebarPanel(
      # file input
      fileInput("file","Select your file"),
      selectInput('sep','Separator',c(Comma=',',Semicolon=";",Tab="\t",Xls="xls"),','),
      
      # select columns
      selectInput('group_col',label=h3("Group column"),c("",Q_columns='Q',M_columns='M',T_columns='T'),selected = NULL,multiple = FALSE),
      checkboxGroupInput("combobox",label=h3("column for histogram"),choices=NULL),
      downloadButton(outputId = "download",label="Download the Plot")
    ),
    
    mainPanel(
      uiOutput("tb")
    )
  )
)


server<-function(input,output,session){
  data<-reactive({
    
    file1<-input$file
    if (is.null(file1)){return()}
    
    dataSet<-if (input$sep!='xls'){
      read.csv(file=file1$datapath,skip=2, sep=input$sep)
    }
    else{
      read_xlsx(file1$datapath, sheet =  1,skip=2)
    }
    
    # L로 시작하는 컬럼은 선택박스에 안 들어가게! -> 짝수번째 컬럼만 넣음
    half_col<-length(colnames(dataSet))%/%2
    ch_col<-colnames(dataSet)[1:half_col*2]
    
    q.vec<-c()
    m.vec<-c()
    t.vec<-c()
  
    
    for (ch in ch_col){
      if (str_detect(ch,'q')){q.vec<-c(q.vec,ch)}
      if (str_detect(ch,'m')){m.vec<-c(m.vec,ch)}
      if (str_detect(ch,'t')) {t.vec<-c(t.vec,ch)}
    }
    #cat('q: ',q.vec,'\n')
    #cat('m: ',m.vec,'\n')
    #cat('t: ',t.vec,'\n')
    
    if (input$group_col=='Q'){
      updateCheckboxGroupInput(session,"combobox",choices=q.vec)
    }
    else if (input$group_col=='M'){
      updateCheckboxGroupInput(session,"combobox",choices=m.vec)
    }
    else if(input$group_col=='T'){
      updateCheckboxGroupInput(session,"combobox",choices=t.vec)
    }
    dataSet
  })
  
  output$table<-renderTable({
    if (is.null(input$group_col)){return ()}
    data()
  })
  
  
  output$myplot <-renderPlot({
      if (is.null(input$combobox)){
        plot.new()
      }    
      # 일변량
      else if (length(input$combobox==1)){
        #print("one variable...!")
        q_loc=which(colnames(data())==input$combobox)
        x<-data()[,c(q_loc,q_loc+1)]
        plot(x,type='l',ylab='Density')
      }
    
      # 다변량
      else if (length(input$combobox)>1){
        return()
      }
    })
    
  
  output$tb <-renderUI({
    if(is.null(data()))
      h5("No available data yet.")
    else
      tabsetPanel(tabPanel("data",tableOutput("table")),tabPanel("Histogram",plotOutput("myplot")))
  })
  
  output$download <-downloadHandler(
    filename=function(){paste("histogram_",input$combobox,".png",setp="")},
    content = function(file){
      png(file)
      q_loc=which(colnames(data())==input$combobox)
      x<-data()[,c(q_loc,q_loc+1)]
      plot(x,type='l')
      dev.off()
    }
  )
}


shinyApp(ui=ui,server = server)