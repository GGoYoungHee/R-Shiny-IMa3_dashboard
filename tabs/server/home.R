# tabs > server > home.R


# change Tabs
observeEvent(input$plot,{
  #updateNavbarPage(session=session,inputId='navbar',selected='plot')
  updateTabsetPanel(session=session,inputId='navbar',selected='plot')
  #output$myplot<-renderPlot(hist(1:10))
  #output$myplot<-renderPlot(hist(1:10))
})

observeEvent(input$bt,{
  #updateTabsetPanel(session=session,inputId='navbar',selected='bt_tb')
  updateNavbarPage(session=session,inputId='navbar',selected='bt')
})

observeEvent(input$about,{
  updateTabsetPanel(session=session,inputId='navbar',selected='about')
  #closeSweetAlert(session = session)
})


