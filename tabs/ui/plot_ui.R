library(tidyverse)


plot<-tabPanel("PLOT",value="plot",
               #br(),hr(),
               
               fluidPage(
                 titlePanel("Make a Histogram for IMa3 Result"),
                 
                 sidebarLayout(
                   sidebarPanel(
                     # file input
                     fileInput("file","Select your file"),
                     
                     
                     # select columns
                     selectInput('group_col',label=h3("Group column"),c("",q_columns='Q',m_columns='M',t_columns='T'),selected = NULL,multiple = FALSE),
                     checkboxGroupInput("combobox",label=h3("column for histogram"),choices=NULL),
                     
                     # download plot
                     radioButtons("down_opt","Download Option",list('png','jpeg','pdf')),
                     downloadButton(outputId = "download",label="Download the Plot")
                   ),
                   
                   
                   mainPanel(
                     uiOutput("tb")
                   )
                 )
               ))