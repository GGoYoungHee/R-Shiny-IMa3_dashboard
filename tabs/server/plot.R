# tabs > server > plot.R

#getwd()
#setwd("C:/Users/koh99/바탕 화면/Labs_KGU/IMa3/tabs/server")

observeEvent(input$plot,{
  output$myplot<-renderPlot({hist(rnorm(100,mean=0,sd=1))})
})

