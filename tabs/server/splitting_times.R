library(shinyFiles)
library(data.table) 
library(dplyr)

options(shiny.maxRequestSize=10000*1024^2)
volumes = c('wd'='.')
  
## python file load
source_python('./tabs/server/splitting_times_data.py')
  
## file choose
observe({shinyFileChoose(input, 'file1', roots=volumes, defaultPath='', defaultRoot='wd')})
  
## uploaded file
observe({
    
  values <- reactiveValues(
      upload_state = NULL
  )
    
  observeEvent(input$file1, {
    values$upload_state <- 'uploaded'
  })
    
  file_selected<-reactive({parseFilePaths(volumes, input$file1)})
    
  output$summary <- renderText({
    return(paste(file_selected()$name,"\n"))
  })
    
})
  
  
## Data path ( list() data )
lst <- eventReactive(input$file1, 
                      {
                       lst1 <- list( )
                       if (length(parseFilePaths(volumes, input$file1)$datapath)>=1){
                         for(i in 1:length(parseFilePaths(volumes, input$file1)$datapath)){
                           lst1[[i]] <- parseFilePaths(volumes, input$file1)$datapath[i]
                         }
                       }
                       lst1
                      })
  
## Data Load
run1 <- reactive({
  pop1 <- get_data(as.character(lst()[[1]]))
  pop1
})

run2 <- reactive({
  pop1 <- get_data(as.character(lst()[[2]]))
  pop1
})
  
run3 <- reactive({
  pop1 <- get_data(as.character(lst()[[3]]))
  pop1
})

run4 <- reactive({
  pop1 <- get_data(as.character(lst()[[4]]))
  pop1
})
  
run5 <- reactive({
  pop1 <- get_data(as.character(lst()[[5]]))
  pop1
})
  
## file name list    
names <- reactive({
  lst1 <- list()
  file_selected<-parseFilePaths(volumes, input$file1)
  nfiles <- length(file_selected$datapath)
  for(i in 1:nfiles){
    lst1[[i]] <- file_selected$name[i]
  }
  lst1 
})

## set names
setnames <- reactive({
  txt = list()
  
  if(length(lst())>=1){txt[[1]] = paste("1", names()[[1]], sep=" : ")}
  if(length(lst())>=2){txt[[2]] = paste("2", names()[[2]], sep=" : ")}
  if(length(lst())>=3){txt[[3]] = paste("3", names()[[3]], sep=" : ")}
  if(length(lst())>=4){txt[[4]] = paste("4", names()[[4]], sep=" : ")}
  if(length(lst())>=5){txt[[5]] = paste("5", names()[[5]], sep=" : ")}
  
  txt
})

output$datanames1 <- renderText({return(paste(setnames(),"\n"))})
output$datanames2 <- renderText({return(paste(setnames(),"\n"))})
  

##################
## density plot ##
##################

max_t0 <- reactive({
  lst_t0 <- list()
  for (i in seq(length(lst()))){
    switch(as.character(i),
            '1' = {lst_t0[[1]] <- max(density(as.double(run1()$t0))$y)},
            '2' = {lst_t0[[2]] <- max(density(as.double(run2()$t0))$y)},
            '3' = {lst_t0[[3]] <- max(density(as.double(run3()$t0))$y)},
            '4' = {lst_t0[[4]] <- max(density(as.double(run4()$t0))$y)},
            '5' = {lst_t0[[5]] <- max(density(as.double(run5()$t0))$y)}
    )
  }
  max_t0 <- which.max(lst_t0)
  lst_t0[[max_t0]]
})

  
max_t1 <- reactive({
  lst_t1 <- list()
  for (i in seq(length(lst()))){
    switch(as.character(i),
            '1' = {lst_t1[[1]] <- max(density(as.double(run1()$t1))$y)},
            '2' = {lst_t1[[2]] <- max(density(as.double(run2()$t1))$y)},
            '3' = {lst_t1[[3]] <- max(density(as.double(run3()$t1))$y)},
            '4' = {lst_t1[[4]] <- max(density(as.double(run4()$t1))$y)},
            '5' = {lst_t1[[5]] <- max(density(as.double(run5()$t1))$y)}
    )
  }
  max_t1 <- which.max(lst_t1)
  lst_t1[[max_t1]]
})
  
## plot colors
plot.col <- 1:675
  
  
## t0 density plot
output$distPlot_t0 <-renderPlot({
    
  nfiles <- length(lst())
    
  if (nfiles < 2){
    plot.new()
    text(x=0.5, y=0.9, cex=2, 'Please select two or more files.')
  } else {
    for (i in seq(nfiles)){
      switch(as.character(i),
              '1' = {plot(density(as.double(run1()$t0)), ylim=c(0, (max_t0()+0.5)), col=plot.col[1], main="t0")},
              '2' = {lines(density(as.double(run2()$t0)), col=plot.col[2])},
              '3' = {lines(density(as.double(run3()$t0)), col=plot.col[3])},
              '4' = {lines(density(as.double(run4()$t0)), col=plot.col[4])},
              '5' = {lines(density(as.double(run5()$t0)), col=plot.col[5])}
      )
    }
  legend("topright",legend=names(), fill =plot.col[1:nfiles])
  }  
})
  
  
## t1 density plot    
output$distPlot_t1 <- renderPlot({
  nfiles <- length(lst())
    
  if (nfiles < 2){
    plot.new()
  } else {
    for (i in seq(nfiles)){
      switch(as.character(i),
              '1' = {plot(density(as.double(run1()$t1)), ylim=c(0, (max_t1()+0.1)), col=plot.col[1], main="t1")},
              '2' = {lines(density(as.double(run2()$t1)), col=plot.col[2])},
              '3' = {lines(density(as.double(run3()$t1)), col=plot.col[3])},
              '4' = {lines(density(as.double(run4()$t1)), col=plot.col[4])},
              '5' = {lines(density(as.double(run5()$t1)), col=plot.col[5])}
      )
    }
    legend("topright",legend=names(), fill =plot.col[1:nfiles])
  }
})
  
  
####################
### kruskal test ###
####################
  
## total_data
ti_total <- reactive({
  switch(as.character(length(lst())),
         "1" = {ti_total <- run1()},
         "2" = {ti_total <- rbindlist(list(run1(), run2()), idcol='run')},
         "3" = {ti_total <- rbindlist(list(run1(), run2(), run3()), idcol='run')},
         "4" = {ti_total <- rbindlist(list(run1(), run2(), run3(), run4()), idcol='run')},
         "5" = {ti_total <- rbindlist(list(run1(), run2(), run3(), run4(), run5()), idcol='run')}
    )
  ti_total
})
  

## t0 kruskal test
output$kruskal_t0 <- renderTable({
  
  if (length(lst()) >= 2){
    k_test <- kruskal.test(t0 ~ run, data = ti_total())
    kr_t0 <- data.frame(k_test$data.name, k_test$statistic, k_test$parameter, k_test$p.value)
    names(kr_t0) <- c("data name", "chi-squared", "df", "pvalue")
    kr_t0
    }
  }, bordered = TRUE, digits = 6)
  
  
## t1 kruskal test
output$kruskal_t1 <- renderTable({
  if (length(lst()) >= 2){
    k_test <- kruskal.test(t1 ~ run, data = ti_total())
    kr_t1 <- data.frame(k_test$data.name, k_test$statistic, k_test$parameter, k_test$p.value)
    names(kr_t1) <- c("data name", "chi-squared", "df", "pvalue")
    kr_t1
    }
  }, bordered = TRUE, digits = 6)

  
###################
### wilcox test ###
###################
  
## t0 wilcox test
output$wilcox_t0 <- renderTable({
  if (length(lst()) >= 2){
    set1 <- list()
    set2 <- list()
    pvalue <- list()
      
    n <- 1
      
    for(i in 1:(length(lst())-1)){
      for(j in (i+1):length(lst())){
        test.res = wilcox.test(as.double(ti_total()$t0[ti_total()$run==i]), as.double(ti_total()$t0[ti_total()$run==j]))
        set1[n] <- as.character(i)
        set2[n] <- as.character(j)
        pvalue[n] <- test.res$p.value
          
        n <- n + 1
      }
    }
    w_t0 <- cbind(set1, set2, pvalue)
    names(w_t0) <- c("set1", "set2", "pvalue")
    w_t0
    }
  }, bordered = TRUE, digits = 6)
  
  
## t1 wilcox test
output$wilcox_t1 <- renderTable({
  
  if (length(lst()) >= 2){
    set1 <- list()
    set2 <- list()
    pvalue <- list()
      
    n <- 1
      
    for(i in 1:(length(lst())-1)){
      for(j in (i+1):length(lst())){
        test.res = wilcox.test(as.double(ti_total()$t1[ti_total()$run==i]), as.double(ti_total()$t1[ti_total()$run==j]))
        set1[n] <- as.character(i)
        set2[n] <- as.character(j)
        pvalue[n] <- test.res$p.value
          
        n <- n + 1
      }
    }
    w_t1 <- cbind(set1, set2, pvalue)
    names(w_t1) <- c("set1", "set2", "pvalue")
    w_t1
    }
  }, bordered = TRUE, digits = 6)


###############################
### Kolmogorov-smirnov test ###
###############################

## t0 ks test output
output$ks_t0 <- renderTable({
  
  if (length(lst()) >= 2){
    set1 <- list()
    set2 <- list()
    pvalue <- list()
      
    n <- 1
      
    for(i in 1:(length(lst())-1)){
      for(j in (i+1):length(lst())){
        test.res =ks.test(as.double(ti_total()$t0[ti_total()$run==i]), as.double(ti_total()$t0[ti_total()$run==j]))
        set1[n] <- as.character(i)
        set2[n] <- as.character(j)
        pvalue[n] <- test.res$p.value
          
        n <- n + 1
      }
    }
    k_t0 <- cbind(set1, set2, pvalue)
    names(k_t0) <- c("set1", "set2", "pvalue")
    k_t0
    }
  }, bordered = TRUE, digits = 6)
  
  
## t1 ks test output
output$ks_t1 <- renderTable({
  
  if (length(lst()) >= 2){
    set1 <- list()
    set2 <- list()
    pvalue <- list()
  
    n <- 1
      
    for(i in 1:(length(lst())-1)){
      for(j in (i+1):length(lst())){
        test.res =ks.test(as.double(ti_total()$t1[ti_total()$run==i]), as.double(ti_total()$t1[ti_total()$run==j]))
        set1[n] <- as.character(i)
        set2[n] <- as.character(j)
        pvalue[n] <- test.res$p.value
          
        n <- n + 1
      }
    }
    k_t1 <- cbind(set1, set2, pvalue)
    names(k_t1) <- c("set1", "set2", "pvalue")
    k_t1
    }
  }, bordered = TRUE, digits = 6)
  
  
#tab panel
output$st <- renderUI({
  if(is.null(input$file1) | input$Load==0){
    h5("No available data yet.")
  }
  else{
    tabsetPanel(id='tabSet',
                tabPanel("Density plot",
                          plotOutput("distPlot_t0"),
                          plotOutput("distPlot_t1")
                ),
                tabPanel("Kruskal-Wallis test",
                          br(),
                          verbatimTextOutput("datanames1"),
                          h3("1. t0"),
                          h3("Kruskal test"),
                          tableOutput("kruskal_t0"),
                          h3("Wilcox test"),
                          tableOutput("wilcox_t0"),
                          h3("2. t1"),
                          h3("Kruskal test"),
                          tableOutput("kruskal_t1"),
                          h3("Wilcox test"),
                          tableOutput("wilcox_t1"),
                ),
                tabPanel("Kolmogorov-smirnov test",
                          br(),
                          verbatimTextOutput("datanames2"),
                          h3("1. t0"),
                          tableOutput("ks_t0"),
                          h3("2. t1"),
                          tableOutput("ks_t1")
                )
      )
    }
  })

