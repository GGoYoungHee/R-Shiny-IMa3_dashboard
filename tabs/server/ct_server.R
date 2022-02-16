#server

library(shinyFiles)
library(shinyWidgets)


source_python('./tabs/server/writepop.py')

options(shiny.maxRequestSize=500*1024^2)


observe({shinyFileChoose(input, 'ct_file', roots=volumes, defaultPath='', defaultRoot='wd')})


########################## ???별로 ??? ????????? 지??? ##########################

ct_file_list <- eventReactive(input$ct_file, 
                      {req(input$ct_Load!=0)
                        lst <- list( )
                        file_selected<-parseFilePaths(volumes, input$ct_file)
                        for(i in 1:5){
                          lst[[i]] <- file_selected$datapath[i]
                        }
                        lst 
                      })


##########################  ????????? 로드  ##########################

ct_run1 <- reactive({
  req(!is.null(input$ct_file) & input$ct_Load!=0)
  pop1 <- popvals(as.character(ct_file_list()[[1]]))
  
  # burn-thin ?????? ????????? ???처리
  run1 = scan(text= pop1, what = " ")
  run1 = as.numeric(run1)
  run1
})
ct_nrun1 <- reactive({
  nrun1 = ct_run1()[1]
  nrun1
})

ct_run2 <- reactive({
  req(!is.null(input$ct_file) & input$ct_Load!=0)
  pop1 <- popvals(as.character(ct_file_list()[[2]]))
  
  # burn-thin ?????? ????????? ???처리
  run2 = scan(text= pop1, what = " ")
  run2 = as.numeric(run2)
  run2
})
ct_nrun2 <- reactive({
  nrun2 = ct_run2()[1]
  nrun2
})


ct_run3 <- reactive({
  req(!is.null(input$ct_file) & input$ct_Load!=0)
  pop1 <- popvals(as.character(ct_file_list()[[3]]))
  
  # burn-thin ?????? ????????? ???처리
  run3 = scan(text= pop1, what = " ")
  run3 = as.numeric(run3)
  run3
})
ct_nrun3 <- reactive({
  nrun3 = ct_run3()[1]
  nrun3
})


ct_run4 <- reactive({
  req(!is.null(input$ct_file) & input$ct_Load!=0)
  pop1 <- popvals(as.character(ct_file_list()[[4]]))
  
  # burn-thin ?????? ????????? ???처리
  run4 = scan(text= pop1, what = " ")
  run4 = as.numeric(run4)
  run4
})
ct_nrun4 <- reactive({
  nrun4 = ct_run4()[1]
  nrun4
})


ct_run5 <- reactive({
  req(!is.null(input$ct_file) & input$ct_Load!=0)
  pop1 <- popvals(as.character(ct_file_list()[[5]]))
  
  # burn-thin ?????? ????????? ???처리
  run5 = scan(text= pop1, what = " ")
  run5 = as.numeric(run5)
  run5
})
ct_nrun5 <- reactive({
  nrun5 = ct_run5()[1]
  nrun5
})


########################## ????????? 출력?????? ########################## 

observe({
  values <- reactiveValues(
    upload_state = NULL
  )
  observeEvent(input$ct_file, {
    values$upload_state <- 'uploaded'
  })
  file_selected<-reactive({parseFilePaths(volumes, input$ct_file)})
  output$ct_summary <- renderText({
    return(paste(file_selected()$name,"\n"))
  })
})


########################## 첫번??? ?????????  ##########################

#samplesize

output$sample1<- renderText({

  burnin = input$Brnct1
  if(burnin >= length(ct_nrun1()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct1/10
  
  if(burnin>0){
    run.afterB = ct_run1()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run1()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
})

#table
output$table1 <- renderTable({
  
  # burn-thin
  burnin = input$Brnct1
  if(burnin >= length(ct_nrun1()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct1/10
  
  if(burnin>0){
    run.afterB = ct_run1()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run1()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  #df1 <- data.frame(addmargins(prop.table(table(run.afterBT))))
  df1 <- data.frame(addmargins(cbind(table(run.afterBT),prop.table(table(run.afterBT)))))
  colnames(df1) <- c("topology","ratio","sample size")
  t(df1) 
  },
  bordered=T)
  

#plot
output$plot1 <- renderPlot({
  
  # burn-thin
  burnin = input$Brnct1
  if(burnin >= length(ct_nrun1()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct1/10
  
  
  if(burnin>0){
    run.afterB = ct_run1()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run1()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)

  plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
  yat=seq(0,2,by=1)
  axis(side=2,at=yat)
  
})


# 그래??? ??????로드
output$downloadct1 <-downloadHandler(
  filename=function(){paste0("traceplot_tab1.",input$ct_down_opt_1,setp="")},
  content = function(filect){
    if (input$ct_down_opt_1=='png'){
      png(filect)
    }else if(input$ct_down_opt_1=='jpeg'){
      jpeg(filect)
    }else{
      pdf(filect)
    }
    # burn-thin
    burnin = input$Brnct1
    if(burnin >= length(ct_nrun1()) ){ 
      burnin = 0
    }
    thinning =  input$Thnct1/10
    
    if(burnin>0){
      run.afterB = ct_run1()[-c(1:burnin)]
    }else if(burnin==0){
      run.afterB = ct_run1()
    }
    nrun.afterB = length(run.afterB)
    
    if(thinning>0){
      run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
    }else if(thinning==0){
      run.afterBT = run.afterB
    }
    nrun.afterBT= length(run.afterBT)
    
    plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
    yat=seq(0,2,by=1)
    axis(side=2,at=yat)
    
    dev.off()
  }
)

#chisq
output$chisq1 <- renderTable({

  # burn-thin
  
  burnin = input$Brnct1
  if(burnin >= length(ct_nrun1()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct1/10
  
  if(burnin>0){
    run.afterB = ct_run1()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run1()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  nset1 = round(nrun.afterBT*(input$chisqhead1/100))
  nset2 = round(nrun.afterBT*(input$chisqtail1/100))
  set1 = run.afterBT[1:nset1]
  set2 = run.afterBT[(nrun.afterBT-nset2+1):nrun.afterBT]
  
  chisq1 <- chisq.test(rbind(table(set1),table(set2)))
  
  name <- rbind("Test Statistic", "P-Value","Degrees Of Freedom" )
  t <- rbind(round(chisq1$statistic,6), chisq1$p.value, chisq1$parameter)
  cbind(name,t)
  },striped=T, bordered=T, hover=T, colnames=F, width="100%", spacing="l", align="c")

########################## ???번째 ?????????  ########################## 

#samplesize
output$sample2 <- renderText({
  
  burnin = input$Brnct2
  if(burnin >= length(ct_nrun2()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct2/10
  
  if(burnin>0){
    run.afterB = ct_run2()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run2()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)

})

#table
output$table2 <- renderTable({
  
  burnin = input$Brnct2
  if(burnin >= length(ct_nrun2()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct2/10
  
  if(burnin>0){
    run.afterB = ct_run2()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run2()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  addmargins(prop.table(table(run.afterBT)))
  
  df2 <- data.frame(addmargins(prop.table(table(run.afterBT))))
  colnames(df2) <- c("topology","ratio")
  df2
},
  bordered=T)

#plot
output$plot2 <- renderPlot({
  
  # burn-thin
  burnin = input$Brnct2
  if(burnin >= length(ct_nrun2()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct2/10
  
  if(burnin>0){
    run.afterB = ct_run2()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run2()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
  yat=seq(0,2,by=1)
  axis(side=2,at=yat)  
})


# 그래??? ??????로드
output$downloadct2 <-downloadHandler(
  filename=function(){paste0("traceplot_tab2.",input$ct_down_opt_2,setp="")},
  content = function(filect){
    if (input$ct_down_opt_2=='png'){
      png(filect)
    }else if(input$ct_down_opt_2=='jpeg'){
      jpeg(filect)
    }else{
      pdf(filect)
    }
    
    # burn-thin
    burnin = input$Brnct2
    if(burnin >= length(ct_nrun2()) ){ 
      burnin = 0
    }
    thinning =  input$Thnct2/10
    
    if(burnin>0){
      run.afterB = ct_run2()[-c(1:burnin)]
    }else if(burnin==0){
      run.afterB = ct_run2()
    }
    nrun.afterB = length(run.afterB)
    
    if(thinning>0){
      run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
    }else if(thinning==0){
      run.afterBT = run.afterB
    }
    nrun.afterBT= length(run.afterBT)
    
    plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
    yat=seq(0,2,by=1)
    axis(side=2,at=yat)
    
    dev.off()
  }
)


#chisq
output$chisq2 <- renderTable({
  
  # burn-thin
  burnin = input$Brnct2
  if(burnin >= length(ct_nrun2()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct2/10
  
  if(burnin>0){
    run.afterB = ct_run2()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run2()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  nset1 = round(nrun.afterBT*(input$chisqhead2/100))
  nset2 = round(nrun.afterBT*(input$chisqtail2/100))
  set1 = run.afterBT[1:nset1]
  set2 = run.afterBT[(nrun.afterBT-nset2+1):nrun.afterBT]
  
  chisq2 <-  chisq.test(rbind(table(set1),table(set2)))
  
  name <- rbind("Test Statistic", "P-Value","Degrees Of Freedom" )
  t <- rbind(round(chisq2$statistic,6), chisq2$p.value, chisq2$parameter)
  cbind(name,t)
  #output$ks_t1 <- renderTable({cbind(name,t)}, bordered = TRUE, digits = 6)
},striped=T, bordered=T, hover=T, colnames=F, width="100%", spacing="l", align="c")


########################## ???번째 ?????????  ########################## 

#samplesize
output$sample3 <- renderText({
  
  # burn-thin
  burnin = input$Brnct3
  if(burnin >= length(ct_nrun3()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct3/10
  
  if(burnin>0){
    run.afterB = ct_run3()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run3()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
})

#table
output$table3 <- renderTable({
  
  # burn-thin
  burnin = input$Brnct3
  if(burnin >= length(ct_nrun3()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct3/10
  
  if(burnin>0){
    run.afterB = ct_run3()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run3()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  addmargins(prop.table(table(run.afterBT)))
  
  df3 <- data.frame(addmargins(prop.table(table(run.afterBT))))
  colnames(df3) <- c("topology","ratio")
  df3
  
}, bordered=T)

#plot
output$plot3 <- renderPlot({
  
  # burn-thin
  burnin = input$Brnct3
  if(burnin >= length(ct_nrun3()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct3/10
  
  if(burnin>0){
    run.afterB = ct_run3()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run3()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
  yat=seq(0,2,by=1)
  axis(side=2,at=yat)  
})

## Download plot
output$downloadct3 <-downloadHandler(
  filename=function(){paste0("traceplot_tab3.",input$ct_down_opt_3,setp="")},
  content = function(filect){
    if (input$ct_down_opt_3=='png'){
      png(filect)
    }else if(input$ct_down_opt_3=='jpeg'){
      jpeg(filect)
    }else{
      pdf(filect)
    }
    
    # burn-thin
    burnin = input$Brnct3
    if(burnin >= length(ct_nrun3()) ){ 
      burnin = 0
    }
    thinning =  input$Thnct3/10
    
    if(burnin>0){
      run.afterB = ct_run3()[-c(1:burnin)]
    }else if(burnin==0){
      run.afterB = ct_run3()
    }
    nrun.afterB = length(run.afterB)
    
    if(thinning>0){
      run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
    }else if(thinning==0){
      run.afterBT = run.afterB
    }
    nrun.afterBT= length(run.afterBT)
    
    plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
    yat=seq(0,2,by=1)
    axis(side=2,at=yat) 
    
    dev.off()
  }
)

#chisq
output$chisq3 <- renderTable({
  
  # burn-thin
  burnin = input$Brnct3
  if(burnin >= length(ct_nrun3()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct3/10
  
  if(burnin>0){
    run.afterB = ct_run3()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run3()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  nset1 = round(nrun.afterBT*(input$chisqhead3/100))
  nset2 = round(nrun.afterBT*(input$chisqtail3/100))
  set1 = run.afterBT[1:nset1]
  set2 = run.afterBT[(nrun.afterBT-nset2+1):nrun.afterBT]
  
  chisq3 <- chisq.test(rbind(table(set1),table(set2)))
  
  name <- rbind("Test Statistic", "P-Value","Degrees Of Freedom" )
  t <- rbind(round(chisq3$statistic,6), chisq3$p.value, chisq3$parameter)
  cbind(name,t)
},striped=T, bordered=T, hover=T, colnames=F, width="100%", spacing="l", align="c")


########################## ???번째 ?????????  ########################## 

#samplesize
output$sample4 <- renderText({
  
  # burn-thin
  burnin = input$Brnct4
  if(burnin >= length(ct_nrun4()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct4/10
  
  if(burnin>0){
    run.afterB = ct_run4()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run4()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
})

#table
output$table4 <- renderTable({
  
  # burn-thin
  burnin = input$Brnct4
  if(burnin >= length(ct_nrun4()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct4/10
  
  if(burnin>0){
    run.afterB = ct_run4()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run4()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  addmargins(prop.table(table(run.afterBT)))
  
  df4 <- data.frame(addmargins(prop.table(table(run.afterBT))))
  colnames(df4) <- c("topology","ratio")
  df4
},
  bordered=T)

#plot
output$plot4 <- renderPlot({
  
  # burn-thin
  burnin = input$Brnct4
  if(burnin >= length(ct_nrun4()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct4/10
  
  if(burnin>0){
    run.afterB = ct_run4()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run4()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
  yat=seq(0,2,by=1)
  axis(side=2,at=yat)  
})

## Download plot
output$downloadct4 <-downloadHandler(
  filename=function(){paste0("traceplot_tab4.",input$ct_down_opt_4,setp="")},
  content = function(filect){
    if (input$ct_down_opt_4=='png'){
      png(filect)
    }else if(input$ct_down_opt_4=='jpeg'){
      jpeg(filect)
    }else{
      pdf(filect)
    }
    
    # burn-thin
    burnin = input$Brnct4
    if(burnin >= length(ct_nrun4()) ){ 
      burnin = 0
    }
    thinning =  input$Thnct4/10
    
    if(burnin>0){
      run.afterB = ct_run4()[-c(1:burnin)]
    }else if(burnin==0){
      run.afterB = ct_run4()
    }
    nrun.afterB = length(run.afterB)
    
    if(thinning>0){
      run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
    }else if(thinning==0){
      run.afterBT = run.afterB
    }
    nrun.afterBT= length(run.afterBT)
    
    plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
    yat=seq(0,2,by=1)
    axis(side=2,at=yat) 
    
    dev.off()
  }
)

#chisq
output$chisq4 <- renderTable({
  
  # burn-thin
  burnin = input$Brnct4
  if(burnin >= length(ct_nrun4()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct4/10
  
  if(burnin>0){
    run.afterB = ct_run4()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run4()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  nset1 = round(nrun.afterBT*(input$chisqhead4/100))
  nset2 = round(nrun.afterBT*(input$chisqtail4/100))
  set1 = run.afterBT[1:nset1]
  set2 = run.afterBT[(nrun.afterBT-nset2+1):nrun.afterBT]
  
  chisq4 <- chisq.test(rbind(table(set1),table(set2))) 
  
  name <- rbind("Test Statistic", "P-Value","Degrees Of Freedom" )
  t <- rbind(round(chisq4$statistic,6), chisq4$p.value, chisq4$parameter)
  cbind(name,t)
},striped=T, bordered=T, hover=T, colnames=F, width="100%", spacing="l", align="c")


########################## ??????번째 ?????????  ########################## 

#samplesize
output$sample5 <- renderText({
  
  # burn-thin
  burnin = input$Brnct5
  if(burnin >= length(ct_nrun5()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct5/10
  
  if(burnin>0){
    run.afterB = ct_run5()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run5()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
})

#table
output$table5 <- renderTable({
  
  # burn-thin
  burnin = input$Brnct5
  if(burnin >= length(ct_nrun5()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct5/10
  
  if(burnin>0){
    run.afterB = ct_run5()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run5()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  addmargins(prop.table(table(run.afterBT)))
  
  df5 <- data.frame(addmargins(prop.table(table(run.afterBT))))
  colnames(df5) <- c("topology","ratio")
  df5
},
  bordered=T)

#plot
output$plot5 <- renderPlot({
  
  # burn-thin
  burnin = input$Brnct5
  if(burnin >= length(ct_nrun5()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct5/10
  
  if(burnin>0){
    run.afterB = ct_run5()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run5()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
  yat=seq(0,2,by=1)
  axis(side=2,at=yat)  
})

## Download plot
output$downloadct5 <-downloadHandler(
  filename=function(){paste0("traceplot_tab5.",input$ct_down_opt_5,setp="")},
  content = function(filect){
    if (input$ct_down_opt_5=='png'){
      png(filect)
    }else if(input$ct_down_opt_5=='jpeg'){
      jpeg(filect)
    }else{
      pdf(filect)
    }
    
    # burn-thin
    burnin = input$Brnct5
    if(burnin >= length(ct_nrun5()) ){ 
      burnin = 0
    }
    thinning =  input$Thnct5/10
    
    if(burnin>0){
      run.afterB = ct_run5()[-c(1:burnin)]
    }else if(burnin==0){
      run.afterB = ct_run5()
    }
    nrun.afterB = length(run.afterB)
    
    if(thinning>0){
      run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
    }else if(thinning==0){
      run.afterBT = run.afterB
    }
    nrun.afterBT= length(run.afterBT)
    
    plot(run.afterBT~c(1:nrun.afterBT), xlab="iterations" , ylab = "Topology", yaxt="n", col="grey")
    yat=seq(0,2,by=1)
    axis(side=2,at=yat) 
    
    dev.off()
  }
)

#chisq
output$chisq5 <- renderTable({
  
  # burn-thin
  burnin = input$Brnct5
  if(burnin >= length(ct_nrun5()) ){ 
    burnin = 0
  }
  thinning =  input$Thnct5/10
  
  if(burnin>0){
    run.afterB = ct_run5()[-c(1:burnin)]
  }else if(burnin==0){
    run.afterB = ct_run5()
  }
  nrun.afterB = length(run.afterB)
  
  if(thinning>0){
    run.afterBT = run.afterB[1:floor(nrun.afterB/thinning)*thinning]
  }else if(thinning==0){
    run.afterBT = run.afterB
  }
  nrun.afterBT= length(run.afterBT)
  
  nset1 = round(nrun.afterBT*(input$chisqhead5/100))
  nset2 = round(nrun.afterBT*(input$chisqtail5/100))
  set1 = run.afterBT[1:nset1]
  set2 = run.afterBT[(nrun.afterBT-nset2+1):nrun.afterBT]
  
  chisq5 <- chisq.test(rbind(table(set1),table(set2)))
  
  name <- rbind("Test Statistic", "P-Value","Degrees Of Freedom" )
  t <- rbind(round(chisq5$statistic,6), chisq5$p.value, chisq5$parameter)
  cbind(name,t)
},striped=T, bordered=T, hover=T, colnames=F, width="100%", spacing="l", align="c")



#### ????????? 출력?????? 
observe({
  values <- reactiveValues(
    upload_state = NULL
  )
  observeEvent(input$ct_file, {
    values$upload_state <- 'uploaded'
  })
  file_selected<-reactive({parseFilePaths(volumes, input$ct_file)})
  output$ct_summary <- renderText({
    return(paste(file_selected()$name,"\n"))
  })
})


#tabpanel(cttb)
output$cttb <-renderUI({
  if(is.null(ct_file_list()))
    h5("No available data yet.")
  else
    tabsetPanel(id='tabSet',
                tabPanel("File 1",hr(),
                         ######
                         #column(width=6, numericInput("Brnct1", "Burn-in",value = 0)),
                         column(width=3, h3("Burn-in : ")),#br(),#br(),
                         column(width=2, numericInput("Brnct1","",value = 0)),
                         #column(width=6, numericInput("Thnct1", "Thinning",value = 0)),
                         column(width=3, h3("Thinning : ")),#br(),br(),
                         column(width=2, numericInput("Thnct1", "",value = 0)),
                         hr(),
                         ######
                         br(),
                         column(width=3, h3("Sample size : ")),br(),br(),
                         column(width=9, h3(textOutput("sample1"))),br(),br(),br(),
                         hr(),h3("Proportion table"),tableOutput("table1"),
                         hr(),h3("Trace plot"),
                         plotOutput("plot1"),
                         radioGroupButtons(inputId = "ct_down_opt_1",label ="Download Option",choices = c('png','jpeg','pdf'),individual = TRUE,
                                           checkIcon = list(yes = tags$i(class = "fa fa-circle", style = "color: steelblue"), no = tags$i(class = "fa fa-circle-o", style = "color: steelblue"))),
                         downloadButton(outputId = "downloadct1",label="Download the Plot"),
                         hr(),h3("Chisq test"),
                         column(width=6, sliderInput("chisqhead1", "fraction to use from beginning of chain", min = 0, max = 50, value = 10)),
                         column(width=6, sliderInput("chisqtail1", "fraction to use from end of chain", min = 0, max = 50, value = 10)),
                         br(),br(),
                         tableOutput("chisq1"),
                         hr(),
                ),
                
                tabPanel("File 2",hr(),
                         ######
                         #column(width=6, numericInput("Brnct2", "Burn-in",value = 0)),
                         #column(width=6, numericInput("Thnct2", "Thinning",value = 0)),
                         #column(width=3, h3("Burn-in : ")),#br(),br(),
                         #column(width=9, numericInput("Brnct2","",value = 0)),
                         #column(width=3, h3("Thinning : ")),br(),br(),
                         #column(width=9, numericInput("Thnct2", "",value = 0)),
                         column(width=3, h3("Burn-in : ")),#br(),#br(),
                         column(width=2, numericInput("Brnct2","",value = 0)),
                         #column(width=6, numericInput("Thnct1", "Thinning",value = 0)),
                         column(width=3, h3("Thinning : ")),#br(),br(),
                         column(width=2, numericInput("Thnct2", "",value = 0)),
                         hr(),
                         ######
                         br(),
                         column(width=3, h3("Sample size : ")),br(),br(),
                         column(width=9, h3(textOutput("sample2"))),br(),br(),br(),
                         hr(),h3("Proportion table"),tableOutput("table2"),
                         hr(),h3("Trace plot"),plotOutput("plot2"),
                         radioGroupButtons(inputId = "ct_down_opt_2",label ="Download Option",choices = c('png','jpeg','pdf'),individual = TRUE,
                                           checkIcon = list(yes = tags$i(class = "fa fa-circle", style = "color: steelblue"), no = tags$i(class = "fa fa-circle-o", style = "color: steelblue"))),
                         downloadButton(outputId = "downloadct2",label="Download the Plot"),
                         hr(),h3("Chisq test"),
                         column(width=6, sliderInput("chisqhead2", "fraction to use from beginning of chain", min = 0, max = 50, value = 10)),
                         column(width=6, sliderInput("chisqtail2", "fraction to use from end of chain", min = 0, max = 50, value = 10)),
                         br(),br(),
                         tableOutput("chisq2"),
                         hr(),
                ),
                
                tabPanel("File 3",hr(),
                         ######
                         #column(width=6, numericInput("Brnct3", "Burn-in",value = 0)),
                         #column(width=6, numericInput("Thnct3", "Thinning",value = 0)),
                         column(width=3, h3("Burn-in : ")),#br(),#br(),
                         column(width=2, numericInput("Brnct3","",value = 0)),
                         #column(width=6, numericInput("Thnct1", "Thinning",value = 0)),
                         column(width=3, h3("Thinning : ")),#br(),br(),
                         column(width=2, numericInput("Thnct3", "",value = 0)),
                         hr(),
                         ######
                         br(),
                         column(width=3, h3("Sample size : ")),br(),br(),
                         column(width=9, h3(textOutput("sample3"))),br(),br(),br(),
                         hr(),h3("Proportion table"),tableOutput("table3"),
                         hr(),h3("Trace plot"),plotOutput("plot3"),
                         radioGroupButtons(inputId = "ct_down_opt_3",label ="Download Option",choices = c('png','jpeg','pdf'),individual = TRUE,
                                           checkIcon = list(yes = tags$i(class = "fa fa-circle", style = "color: steelblue"), no = tags$i(class = "fa fa-circle-o", style = "color: steelblue"))),
                         downloadButton(outputId = "downloadct3",label="Download the Plot"),
                         hr(),h3("Chisq test"),
                         column(width=6, sliderInput("chisqhead3", "fraction to use from beginning of chain", min = 0, max = 50, value = 10)),
                         column(width=6, sliderInput("chisqtail3", "fraction to use from end of chain", min = 0, max = 50, value = 10)),
                         br(),br(),
                         tableOutput("chisq3"),
                         hr(),
                ),
                
                tabPanel("File 4",hr(),
                         ######
                         #column(width=6, numericInput("Brnct4", "Burn-in",value = 0)),
                         #column(width=6, numericInput("Thnct4", "Thinning",value = 0)),
                         column(width=3, h3("Burn-in : ")),#br(),#br(),
                         column(width=2, numericInput("Brnct4","",value = 0)),
                         #column(width=6, numericInput("Thnct1", "Thinning",value = 0)),
                         column(width=3, h3("Thinning : ")),#br(),br(),
                         column(width=2, numericInput("Thnct4", "",value = 0)),
                         hr(),
                         ######
                         br(),
                         column(width=3, h3("Sample size : ")),br(),br(),
                         column(width=9,h3(textOutput("sample4"))),br(),br(),br(),
                         hr(),h3("Proportion table"),tableOutput("table4"),
                         hr(),h3("Trace plot"),plotOutput("plot4"),
                         radioGroupButtons(inputId = "ct_down_opt_4",label ="Download Option",choices = c('png','jpeg','pdf'),individual = TRUE,
                                           checkIcon = list(yes = tags$i(class = "fa fa-circle", style = "color: steelblue"), no = tags$i(class = "fa fa-circle-o", style = "color: steelblue"))),
                         downloadButton(outputId = "downloadct4",label="Download the Plot"),
                         hr(),h3("Chisq test"),
                         column(width=6, sliderInput("chisqhead4", "fraction to use from beginning of chain", min = 0, max = 50, value = 10)),
                         column(width=6, sliderInput("chisqtail4", "fraction to use from end of chain", min = 0, max = 50, value = 10)),
                         br(),br(),
                         tableOutput("chisq4"),
                         hr(),
                ),
                
                tabPanel("File 5",hr(),
                         ######
                         #column(width=6, numericInput("Brnct5", "Burn-in",value = 0)),
                         #columnwidth=6, numericInput("Thnct5", "Thinning",value = 0)),
                         column(width=3, h3("Burn-in : ")),#br(),#br(),
                         column(width=2, numericInput("Brnct5","",value = 0)),
                         #column(width=6, numericInput("Thnct1", "Thinning",value = 0)),
                         column(width=3, h3("Thinning : ")),#br(),br(),
                         column(width=2, numericInput("Thnct5", "",value = 0)),
                         hr(),
                         br(),
                         ######
                         column(width=3, h3("Sample size : ")),br(),br(),
                         column(width=9, h3(textOutput("sample5"))),br(),br(),br(),
                         hr(),h3("Proportion table"),tableOutput("table5"),
                         hr(),h3("Trace plot"),plotOutput("plot5"),
                         radioGroupButtons(inputId = "ct_down_opt_5",label ="Download Option",choices = c('png','jpeg','pdf'),individual = TRUE,
                                           checkIcon = list(yes = tags$i(class = "fa fa-circle", style = "color: steelblue"), no = tags$i(class = "fa fa-circle-o", style = "color: steelblue"))),
                         downloadButton(outputId = "downloadct5",label="Download the Plot"),
                         hr(), h3("Chisq test"),
                         column(width=6, sliderInput("chisqhead5", "fraction to use from beginning of chain", min = 0, max = 50, value = 10)),
                         column(width=6, sliderInput("chisqtail5", "fraction to use from end of chain", min = 0, max = 50, value = 10)),
                         br(),br(),
                         tableOutput("chisq5"),
                         hr(),
                )
    )
})