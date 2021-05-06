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

  new.df<-reactive({
    test<-list()
    for (i in 1:length(input$combobox)){
      n<-which(colnames(data())==input$combobox[i])
      test[[input$combobox[i]]]<-c(n,n+1)
    }
    new.df<-data.frame(data()[,unname(unlist(test))])  
    new.df
  })
  
  
  
  output$myplot <-renderPlot({
    # Group columns 미 선택시 하얀 바탕만 보이기
    if (is.null(input$combobox)){
      plot.new()
    }    
    

    else{
      x.min=100 ; x.max=0 ; y.min=100 ; y.max=0
      
      for (col in 1:length(new.df())){
        # 홀수번째 컬럼 : x축
        if (col %%2==1){
          if (x.min > min(new.df()[col])){
            x.min<-min(new.df()[col])
          }
          if(x.max<max(new.df()[col])){
            x.max<-max(new.df()[col])
          }
          
          
        }
        
        # 짝수번째 컬럼 : y축
        else{
          if (y.min > min(new.df()[col])){
            y.min<-min(new.df()[col])
          }
          if (y.max < max(new.df()[col])){
            y.max<-max(new.df()[col])
          }
        }
      }
      
      
      # 그래프 그리기
      
      plot.col<-1:8 # 그래프 색상 지정 순서
      
      for (col in 1:length(new.df())){
        # 홀수번째 컬럼: x축
        if (col%%2==1){
          if (col==1){
            
            plot(new.df()[,c(col,col+1)],xlim=c(x.min,x.max),ylim=c(y.min,y.max),type='l',xlab=input$group_col,ylab='Density')
          }
          else{
            lines(new.df()[,c(col,col+1)],col=plot.col[(col+1)%/%2])
          }
        }
      }
      legend('topright',input$combobox,col=plot.col[1:length(input$combobox)],lty=1)
      
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