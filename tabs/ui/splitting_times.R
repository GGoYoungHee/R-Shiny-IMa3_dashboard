#ui

st <- tabPanel("Splitting times",value='st',
    
    fluidPage(
    
        titlePanel("Splitting times"),
    
        sidebarLayout(
            sidebarPanel(
                shinyFilesButton('file1', 'SELECT FILE', 'Please select files', multiple=TRUE),
                br(),
                h4("Uploaded file:"),
                verbatimTextOutput("summary"),
                br(),
                actionButton("Load", "LOAD DATA")
            ),
            mainPanel(
                
                uiOutput("st")
        )
))
)

