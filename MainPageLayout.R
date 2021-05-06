library(shiny)
library(shinydashboard)
#library(DT)
library(readxl)
library(tidyverse)



ui<-dashboardPage(
                  dashboardHeader(title="Test Dashboard"),
                  dashboardSidebar(
                    sidebarMenu(
                      menuItem("Main",tabName = "main",icon=icon("home")),
                      menuItem("Brun-in & Thining",tabName = "BrnThn",icon=icon("filter")),
                      menuItem("Histogram",tabName = "hist",icon=icon("chart-line"))
                    )
                  ),
                  
                  dashboardBody(
          
                    
                    tabItems(
                      tabItem("main",
                              h1("This is main page")),
                      
                      tabItem("BrnThn",
                              h1("Show your data"),
                              dataTableOutput("aft_brnthn")
                              ),
                      
                      tabItem("hist",fluidPage(
                        
                        
                        # layout 조정하기
                        fluidRow(
                          column(4,
                                 fileInput("hist_file","Select your file"),
                                 selectInput('sep','Separator',c(Comma=',',Semicolon=";",Tab="\t",Xls="xls"),','),),
                          column(3,
                                 selectInput("group_col","Group Columns",c("",Q_columns='Q',M_columns='M',T_columns='T'),selected = NULL,multiple = FALSE),),
                          
                          column(5,box(checkboxGroupInput("combobox","Specific Columns",choices=NULL)))
                        
                          
                          ),
                        
                        box(downloadButton(outputId = "download",label="Download the Plot")),
                      
                        
                        
                        
                        
                        #box(fileInput("hist_file","Select your file"),
                        #    selectInput('sep','Separator',c(Comma=',',Semicolon=";",Tab="\t",Xls="xls"),','),),
                        #    selectInput("group_col","Group Columns",c("",Q_columns='Q',M_columns='M',T_columns='T'),selected = NULL,multiple = FALSE),
                        #    checkboxGroupInput("combobox",label=h3("column for histogram"),choices=NULL)
                        #),

                            
                        
                        box(plotOutput("myhist"))
                        
                        
                      )
                    ))
                    
                  )
)


server<-function(input,output,session){
  
  #### hist 관련 코드 ####
  
  data<-reactive({
    
    file1<-input$hist_file
    if (is.null(file1)){return()}
    
    dataSet<-if (input$sep!='xls'){
      read.csv(file=file1$datapath,skip=2, sep=input$sep)
    }
    else{
      read_xlsx(file1$datapath, sheet =  1,skip=2)
    }
    print(head(dataSet))
    print('Read the data...!')
    
    # L로 시작하는 컬럼은 선택박스에 안 들어가게! -> 짝수번째 컬럼만 넣음
    half_col<-length(colnames(dataSet))%/%2
    ch_col<-colnames(dataSet)[1:half_col*2]
    
    q.vec<-c()
    m.vec<-c()
    t.vec<-c()
    
    # print(length(ch_col)) #15개
    
    for (ch in ch_col){
      if (str_detect(ch,'q')){q.vec<-c(q.vec,ch)}
      if (str_detect(ch,'m')){m.vec<-c(m.vec,ch)}
      if (str_detect(ch,'t')) {t.vec<-c(t.vec,ch)}
    }
    cat('q: ',q.vec,'\n')
    cat('m: ',m.vec,'\n')
    cat('t: ',t.vec,'\n')
    
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
}


shinyApp(ui,server)


'''
[문제점]
1. 데이터 업로드 안됨
'''