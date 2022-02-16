# ui

library(shinyFiles)

ct <- tabPanel("Chisq-test",value='ct',
               #br(),hr(),
               
               fluidPage("Chisq-test", value='ct', 
                         
                         # Title setting 
                         titlePanel('Chisq-test'),
                         
                         # Input option by sidebar 
                         sidebarLayout(
                           sidebarPanel(
                             
                             h4(strong("Find your input data:")),
                             h5("(Maximum number of files available for upload: 5)"),
                             
                             # 파일 다중 선택

                             shinyFilesButton('ct_file', 'File select', 'Please select a file', multiple=TRUE),
                             
                             h4("Uploaded file:"),
                             verbatimTextOutput("ct_summary"),
                             
                             br(),
                             
                             actionButton("ct_Load", "Load Data"),
        
                             br(),
                             
                             # burn-thin
                            # h4(strong("Burn-in & Thinning")),
                             
                            # br(),
                             
                            # numericInput(inputId = 'Brnct',label='Burn-in',value=0),
                            # numericInput(inputId = 'Thnct',label='Thinning',value=0),
                             
                            # br(),
                             
                           )
                           ,
                           mainPanel(
                             uiOutput("cttb")
                             )
                         )
               )
)
