# tabs > ui > plot.R

plot<-tabPanel("PLOT",value='plot',
               br(),hr(),
               
               # Buttons
               column(width=11,
                      column(width=3,fileInput("file",'Upload')),
                      column(width=4,
                             selectInput('group_col',label='Group Column',c("",Q_columns='Q',M_columns='M',T_columns='T'),selected=NULL,multiple=FALSE)),
                      column(width=4,
                             checkboxGroupInput('combobox',label="column for histogram",choices=NULL)
                             )
                      ),
               
                      
                 #width=6,
                      # file input
                      #column(width=3,
                      #      fileInput("file","Select file")),
                      # sep?(x)
                      #column(width=3,
                      #       selectInput('sep','Separator',c(Comma=',',Semicolon=";",Tab="\t",Xls="xls"),','),)
               #),
               #column(width=6,
                      # Columns
              #        column(width=3,
              #              selectInput('group_col',label='Group Column',c("",Q_columns='Q',M_columns='M',T_columns='T'),selected=NULL,multiple=FALSE)),
              #        column(width = 3,
              #               checkboxGroupInput('combobox',label="column for histogram",choices=NULL))
              # ),
             
               mainPanel(
                 fluidRow(column(width=10,plotOutput('myplot')),
                          column(width=2,downloadButton(outputId = "download",label="Download the Plot")))
                 ),
              column(width=12,
                     br(),br(),
                     wellPanel('This histogram is for ~~ .'))
               
)

#server<-function(input,output,session){
#  output$myplot<-renderPlot(hist(1:10))
#} 

#shinyApp(ui,server)

#plot<-tabPanel('PLOT',fluidRow(column(3,uiOutput('file',container=span)),
#                               column(3,uiOutput('sep',container = span)))
#                              )
               


# column으로 바꾸기!!
