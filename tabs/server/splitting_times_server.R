library(shinyFiles)
library(data.table) 
library(dplyr)

options(shiny.maxRequestSize=10000*1024^2)

  
### python load ###
source_python('./tabs/server/splitting_times_data.py')
  
### file choose ###
observe({shinyFileChoose(input, "st_file", roots=c(wd='.'), session = session)})
#observe({shinyFileChoose(input, 'st_file', roots=volumes, defaultPath='', defaultRoot='wd')})
  
### uploaded file ###
observe({
  values <- reactiveValues(
      upload_state = NULL
  )
    
  observeEvent(input$st_file, {
    values$upload_state <- 'uploaded'
  })
    
  file_selected<-reactive({parseFilePaths(volumes, input$st_file)})
    
  output$st_summary <- renderText({
    return(paste(file_selected()$name,"\n"))
  })
    
})
  
  
### Data path ( list() data ) ###
st_file_list <- eventReactive(input$st_file, 
                      {
                       lst <- list()
                       if (length(parseFilePaths(volumes, input$st_file)$datapath)>=1){
                         for(i in 1:length(parseFilePaths(volumes, input$st_file)$datapath)){
                           lst[[i]] <- parseFilePaths(volumes, input$st_file)$datapath[i]
                         }
                       }
                       lst
                      })
  
### DataSet Load ###

st_run1 <- reactive({
  pop1 <- get_data(as.character(st_file_list()[[1]]))
  cat('Set1 Load \n')
  pop1
})

st_run2 <- reactive({
  pop1 <- get_data(as.character(st_file_list()[[2]]))
  cat('Set2 Load \n')
  pop1
})
  
st_run3 <- reactive({
  pop1 <- get_data(as.character(st_file_list()[[3]]))
  cat('Set3 Load \n')
  pop1
})

st_run4 <- reactive({
  pop1 <- get_data(as.character(st_file_list()[[4]]))
  cat('Set4 Load \n')
  pop1
})
  
st_run5 <- reactive({
  pop1 <- get_data(as.character(st_file_list()[[5]]))
  cat('Set5 Load \n')
  pop1
})
  
## file name list    
names <- reactive({
  lst <- list()
  file_selected<-parseFilePaths(volumes, input$st_file)
  nfiles <- length(file_selected$datapath)
  for(i in 1:nfiles){
    lst[[i]] <- file_selected$name[i]
  }
  lst
})

## set names
setnames <- reactive({
  txt = list()
  if(length(st_file_list())>=1){txt[[1]] = paste("1", names()[[1]], sep=" : ")}
  if(length(st_file_list())>=2){txt[[2]] = paste("2", names()[[2]], sep=" : ")}
  if(length(st_file_list())>=3){txt[[3]] = paste("3", names()[[3]], sep=" : ")}
  if(length(st_file_list())>=4){txt[[4]] = paste("4", names()[[4]], sep=" : ")}
  if(length(st_file_list())>=5){txt[[5]] = paste("5", names()[[5]], sep=" : ")}
  txt
})

output$datanames1 <- renderText({return(paste(setnames(),"\n"))})
output$datanames2 <- renderText({return(paste(setnames(),"\n"))})
  

##################
## density plot ##
##################

max_t0 <- reactive({
  cat('max_t0 calculate \n')
  lst_t0 <- list()
  for (i in seq(length(st_file_list()))){
    switch(as.character(i),
            '1' = {lst_t0[[1]] <- max(density(as.double(st_run1()$t0))$y)},
            '2' = {lst_t0[[2]] <- max(density(as.double(st_run2()$t0))$y)},
            '3' = {lst_t0[[3]] <- max(density(as.double(st_run3()$t0))$y)},
            '4' = {lst_t0[[4]] <- max(density(as.double(st_run4()$t0))$y)},
            '5' = {lst_t0[[5]] <- max(density(as.double(st_run5()$t0))$y)}
    )
  }
  max_t0 <- which.max(lst_t0)
  cat('max_t0 calculate END \n')
  lst_t0[[max_t0]]
})

  
max_t1 <- reactive({
  cat('max_t1 calculate \n')
  lst_t1 <- list()
  for (i in seq(length(st_file_list()))){
    switch(as.character(i),
            '1' = {lst_t1[[1]] <- max(density(as.double(st_run1()$t1))$y)},
            '2' = {lst_t1[[2]] <- max(density(as.double(st_run2()$t1))$y)},
            '3' = {lst_t1[[3]] <- max(density(as.double(st_run3()$t1))$y)},
            '4' = {lst_t1[[4]] <- max(density(as.double(st_run4()$t1))$y)},
            '5' = {lst_t1[[5]] <- max(density(as.double(st_run5()$t1))$y)}
    )
  }
  max_t1 <- which.max(lst_t1)
  cat('max_t1 calculate END \n')
  lst_t1[[max_t1]]
})
  
## plot colors
plot.col <- 1:675
  
## t0 density plot
output$distPlot_t0 <-renderPlot({
  cat('t0_plot Render START \n')
  nfiles <- length(st_file_list())
  if (nfiles < 2){
    plot.new()
    text(x=0.5, y=0.9, cex=2, 'Please select two or more files.')
  } else {
    for (i in seq(nfiles)){
      switch(as.character(i),
              '1' = {plot(density(as.double(st_run1()$t0)), ylim=c(0, (max_t0()+0.5)), col=plot.col[1], main="t0")},
              '2' = {lines(density(as.double(st_run2()$t0)), col=plot.col[2])},
              '3' = {lines(density(as.double(st_run3()$t0)), col=plot.col[3])},
              '4' = {lines(density(as.double(st_run4()$t0)), col=plot.col[4])},
              '5' = {lines(density(as.double(st_run5()$t0)), col=plot.col[5])}
      )
    }
  legend("topright",legend=names(), fill =plot.col[1:nfiles])
  }  
  cat('t0_plot Render END \n')
})
  
  
## t1 density plot    
output$distPlot_t1 <- renderPlot({
  cat('t1_plot Render START \n')
  nfiles <- length(st_file_list())
  if (nfiles < 2){
    plot.new()
  } else {
    for (i in seq(nfiles)){
      switch(as.character(i),
              '1' = {plot(density(as.double(st_run1()$t1)), ylim=c(0, (max_t1()+0.1)), col=plot.col[1], main="t1")},
              '2' = {lines(density(as.double(st_run2()$t1)), col=plot.col[2])},
              '3' = {lines(density(as.double(st_run3()$t1)), col=plot.col[3])},
              '4' = {lines(density(as.double(st_run4()$t1)), col=plot.col[4])},
              '5' = {lines(density(as.double(st_run5()$t1)), col=plot.col[5])}
      )
    }
    legend("topright",legend=names(), fill =plot.col[1:nfiles])
  }
  cat('t1_plot Render END \n')
})
  
  
####################
### kruskal test ###
####################


kruscal_test <- reactive({
  cat('ks_data_make \n')
  stime = Sys.time()
  switch(as.character(length(st_file_list())),
         "1" = {ti_total <- run1()},
         "2" = {ti_total <- rbindlist(list(st_run1(), st_run2()), idcol='run')},
         "3" = {ti_total <- rbindlist(list(st_run1(), st_run2(), st_run3()), idcol='run')},
         "4" = {ti_total <- rbindlist(list(st_run1(), st_run2(), st_run3(), st_run4()), idcol='run')},
         "5" = {ti_total <- rbindlist(list(st_run1(), st_run2(), st_run3(), st_run4(), st_run5()), idcol='run')})
  ti_total = bigstatsr::as_FBM(ti_total)
  etime = Sys.time() - stime; cat(paste0('DataSet_make \t make time(continued) : ', etime, '\n'))
  cat('ks_test start \n')
  if (length(st_file_list()) >= 2){
    test_data = foreach(i = 1:2, .combine=rbind) %dopar% {
      switch(as.character(i),
             "1" = {k_test = kruskal.test(ti_total[,5] ~ ti_total[,1]); cat('kruskal_t0_end \n')},
             "2" = {k_test = kruskal.test(ti_total[,6] ~ ti_total[,1]); cat('kruskal_t1_end \n')})
      c(k_test$data.name, k_test$statistic, k_test$parameter, k_test$p.value)
    }
    test_data = as.data.frame(test_data)
    names(test_data) <- c("data name", "chi-squared", "df", "pvalue")
    
    # ti_total colnames-> 'run' / 'logPosterior' / 'logLik' /'logPrior' / 't0' / 't1' 
    # varname change (ti_total[,5] ~ ti_total[,1] => t0 ~ run,  ti_total[,6] ~ ti_total[,1] => t1 ~ run)
    test_data$`data name` = c('t0 by run', 't1 by run') 
    test_data$pvalue = sprintf("%.6f", as.double(test_data$pvalue)) # chr change (digit = 6)
    
    etime = Sys.time() - stime
    cat(paste0('ks_test end \t work time(Full time) : ', etime, '\n'))
  }
  test_data
})

# ks_test output
output$kruskal_t0 <- renderTable({kruscal_test()[1,]}, bordered = TRUE, digits = 6)
output$kruskal_t1 <- renderTable({kruscal_test()[2,]}, bordered = TRUE, digits = 6)



###############################
######### wilcox test #########
### Kolmogorov-smirnov test ###
###############################

wilcox_ks_data <- reactive({
  cat('wilcox_data_make \n')
  stime = Sys.time()
  switch(as.character(length(st_file_list())),
         "1" = {ti_total <- run1()},
         "2" = {ti_total <- rbindlist(list(st_run1(), st_run2()), idcol='run')},
         "3" = {ti_total <- rbindlist(list(st_run1(), st_run2(), st_run3()), idcol='run')},
         "4" = {ti_total <- rbindlist(list(st_run1(), st_run2(), st_run3(), st_run4()), idcol='run')},
         "5" = {ti_total <- rbindlist(list(st_run1(), st_run2(), st_run3(), st_run4(), st_run5()), idcol='run')})
  
  ti_total = bigstatsr::as_FBM(ti_total)
  etime = Sys.time() - stime; cat(paste0('DataSet_make \t make time(continued) : ', etime, '\n'))
  if (length(st_file_list()) >= 2){
    cat('wilcox_ks_test start \n')
    
    test_data = list()
    
    t0_wilcox = data.frame() 
    t1_wilcox = data.frame()
    t0_ks = data.frame()
    t1_ks = data.frame()
    calculate = data.frame()
    # ti_total colnames-> 'run' / 'logPosterior' / 'logLik' /'logPrior' / 't0' / 't1' 
    # as_fbm's ti_total[,] ==> same features, values, orders
    for(i in 1:(length(st_file_list())-1)){
      calc = foreach(j = (i+1):length(st_file_list()), .combine=rbind) %dopar% c(as.character(i),
                                                                        as.character(j),
                                                                        sprintf("%.6f",round(as.double(wilcox.test(ti_total[c(ti_total[,1]==i),5],ti_total[c(ti_total[,1]==j),5])$p.value),6)),
                                                                        sprintf("%.6f",round(as.double(wilcox.test(ti_total[c(ti_total[,1]==i),6],ti_total[c(ti_total[,1]==j),6])$p.value),6)),
                                                                        sprintf("%.6f",round(as.double(ks.test(ti_total[c(ti_total[,1]==i),5], ti_total[c(ti_total[,1]==j),5])$p.value),6)),
                                                                        sprintf("%.6f",round(as.double(ks.test(ti_total[c(ti_total[,1]==i),6], ti_total[c(ti_total[,1]==j),6])$p.value),6)))
      calculate = rbind(calculate, calc)
    }
    cat('wilcox_ks_test end \n')
    t0_wilcox = calculate %>% select(c('V1', 'V2','V3'))
    t1_wilcox = calculate %>% select(c('V1', 'V2','V4'))
    t0_ks = calculate %>% select(c('V1', 'V2','V5'))
    t1_ks = calculate %>% select(c('V1', 'V2','V6'))
    
    names(t0_wilcox) <- c("set1", "set2", "pvalue")
    names(t1_wilcox) <- c("set1", "set2", "pvalue")
    names(t0_ks) <- c("set1", "set2", "pvalue")
    names(t1_ks) <- c("set1", "set2", "pvalue")
    
    test_data$t0_wilcox = t0_wilcox
    test_data$t1_wilcox = t1_wilcox
    test_data$t0_ks = t0_ks
    test_data$t1_ks = t1_ks
    etime = Sys.time() - stime
    cat(paste0('wilcox_ks_data_split_end \t work time(Full time) : ', etime, '\n'))
    
    test_data
  }
})

## t0, t1 wilcox test output
output$wilcox_t0 <- renderTable(wilcox_ks_data()$t0_wilcox, bordered = TRUE, digits = 6)
output$wilcox_t1 <- renderTable(wilcox_ks_data()$t1_wilcox, bordered = TRUE, digits = 6)

## t0, t1 ks test output
output$ks_t0 <- renderTable(wilcox_ks_data()$t0_ks, bordered = TRUE, digits = 6)
output$ks_t1 <- renderTable(wilcox_ks_data()$t1_ks, bordered = TRUE, digits = 6)


#tab panel
output$st <- renderUI({
  if(is.null(input$st_file) | input$st_load==0){
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

