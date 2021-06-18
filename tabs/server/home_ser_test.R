# tabs > server > home_ser_test.R


# change Tabs
observeEvent(input$navbar,{
  if (input$navbar=="plot"){
    updateNavbarPage(session=session,inputId='navbar',selected='plot')
    output$myplot<-renderPlot(hist(1:10))
  }
  else if(input$navbar=="bt"){
    updateNavbarPage(session=session,inputId='navbar',selected='bt')
    h3('test...!')
  }
  else if (input$navbar=='about'){
    updateTabsetPanel(session=session,inputId='navbar',selected='about')
    h3('this is about page...!')
  }
  
}
)
