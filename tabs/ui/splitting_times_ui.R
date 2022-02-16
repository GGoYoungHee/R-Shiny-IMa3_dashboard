#ui

st <- tabPanel("Splitting times",value='st',
    
    fluidPage(
    
        titlePanel("Splitting times"),
    
        sidebarLayout(
            sidebarPanel(
                shinyFilesButton('st_file', 'SELECT FILE', 'Please select files', multiple=TRUE),
                br(),
                h4("Uploaded file:"),
                verbatimTextOutput("st_summary"),
                br(),
                actionButton("st_load", "LOAD DATA")
            ),
            mainPanel(
                
                uiOutput("st")
        )
))
)

