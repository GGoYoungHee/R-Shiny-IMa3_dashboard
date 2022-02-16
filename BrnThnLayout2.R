library(shiny)
library(shinydashboard)
library(reticulate)

source_python('C:/Users/rhtn2/OneDrive/바탕 화면/연구조교/02. Rshiny project/IMa3_BrnThn-master/IMa3_BrnThn-master/[Pycharm] IMa3_BrnThn.py')
source_python('C:/Users/rhtn2/OneDrive/바탕 화면/연구조교/02. Rshiny project/IMa3_BrnThn-master/IMa3_BrnThn-master/[Pycharm] IMa3_BrnThn2.py')



ui <- fluidPage(
  # Title setting 
  titlePanel('Burn-in & Thinning'),
  
  # Input option by sidebar 
  sidebarLayout(
    sidebarPanel(
      
      textInput(inputId = 'input_dir',
                label = 'input data directory',
                value='dir/data.ti'),
      
      textInput(inputId = 'output_dir',
                label = 'output data directory',
                value='dir/rename.ti'),
      
      br(),
      
      numericInput(inputId = 'Brn',
                   label='Burn-in',
                   value=0),
      
      numericInput(inputId = 'Thn',
                   label='Thinning',
                   value=0),
      
      actionButton("go","Start")
      
      
    ),
    mainPanel()
  )
)


server <- function(input, output){
  observeEvent(input$go, {
    BrnThn(input_dir = input$input_dir, out_dir=input$output_dir ,Brn=input$Brn, Thn=input$Thn)
  })
  
}
shinyApp(ui, server)

