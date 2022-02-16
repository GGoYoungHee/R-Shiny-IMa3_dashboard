library(shinyFiles)

bt <- tabPanel("Brn-Thn",value='bt',
  #br(),hr(),
              
  fluidPage("Brn-Thn", value='bt', 
                         
  # Title setting 
  titlePanel('Burn-in & Thinning'),
  
  # Input option by sidebar 
  sidebarLayout(
    sidebarPanel(
      
      strong("Find your input data"),
      br(),
      shinyFilesButton("bt_file", "Choose a file" ,
                       title = "Please select a file:", multiple = FALSE,
                       buttonType = "default", class = NULL),
      #input 파일명 추출
      br(),
      h5("Uploaded file:"),
      verbatimTextOutput("file_name"),

      textInput(inputId = 'output_name',
                label = 'output data name',
                value='rename.ti'),
      "Output data will be saved in the input data directory",
      
      br(),
      br(),
      
      numericInput(inputId = 'Brn',
                   label='Burn-in',
                   value=0),
      
      numericInput(inputId = 'Thn',
                   label='Thinning',
                   value=0),
      
      actionButton("go","Run")
      
      
    ),
    mainPanel(
      strong("Output data file : "),
      #textOutut("text_file"), #input directory
      textOutput('out_dir'),#output directory
      br(),
      
      span(textOutput('running_mes'), style="color:red")
      
    )
  )
)
)

