library(coda)
library(dplyr)

# python code
source_python('./tabs/server/MCMC_retrun.py') 

observe({shinyFileChoose(input, "mcmc_file", roots=c(wd='.'), session = session)})

# file setting
mcmc_file = reactive({input$mcmc_file}) # path check
allPath = reactive({as.character(parseFilePaths(c(wd='.'),mcmc_file())$datapath)}) # file name
mcmc_data = reactive({ Readti(allPath()) }) # file read

# path output
output$filechosen <- renderText({
  if(length(allPath())!=0) {
    return (tail(strsplit(allPath(), '/', fixed = TRUE)[[1]], 1))
  } 
})

# all select, unselect button
observe({
  updateCheckboxGroupButtons(
    session, 'print_out', choiceNames =
      list("Trace Plot", "Density Plot", "Autocorrelation and ESS", "Geweke's convergence diagnostic",
           "Heidelberger and Welch's convergence diagnostic", "Raftery and Lewis's diagnostic"),
    choiceValues = list("TP","DP","CORR","GE","HE","RA"),
    selected = if (input$ViewAll) as.character(list("TP","DP","CORR","GE","HE","RA"))
  )
})

# 전부 해제되면 선택 해제되게.
observe({
  updateMaterialSwitch(session, 'ViewAll', value = if (length(input$print_out) == 0) {FALSE} else if (length(input$print_out) == 6) {TRUE})
})


# Trace Plot likelihood
output$TracePlot_LH = renderPlot({
  if(length(input$mcmc_file) <= 1) return({})
  par(mfrow=c(1,3))
  layout(matrix(1:3,3,1))
  par(mar=c(2,6,1,1), cex.lab=2)
  plot(mcmc_data()$loglikelihood~c(1:nrow(mcmc_data())), type='l',  ylab = "loglikelihood")
  par(mar=c(2,6,1,1), cex.lab=2)
  plot(mcmc_data()$logprior~c(1:nrow(mcmc_data())), type='l',  ylab = "log(prior)")
  par(mar=c(4,6,1,1), cex.lab=2)
  plot(mcmc_data()$loglikelihood + mcmc_data()$logprior~c(1:nrow(mcmc_data())), type='l',  xlab = "MCMC iteration", ylab = "likeli+prior")
})

# Trace Plot splitting times
output$TracePlot_SP = renderPlot({
  if(length(input$mcmc_file) <= 1) return({}) # 값을 안받을때는 공백 반환.
  
  # 일단 2개는 확정으로 출력.
  layout(matrix(1:(ncol(mcmc_data())-2),ncol(mcmc_data())-2,1))
  counter = 0 # t0, t1계속 증가시키기 위한 카운터터
  for (i in mcmc_data()[,-c(1,2)]) {
    par(mar=c(2,4,1,0.5), cex.lab=1.5)
    label = paste0('t', counter); counter = counter + 1
    # ex. t0이면 한칸뒤에 t1이 더 있는지 물어봅니다.
    if (paste0('t',counter) %in% colnames(mcmc_data())) {
      plot(i~c(1:nrow(mcmc_data())), type='l', ylab = label)
    }
    else {
      par(mar=c(4,4,1,0.5), cex.lab=1.5)
      plot(i~c(1:nrow(mcmc_data())), type='l',xlab = "MCMC iteration", ylab = label)
    }
  }
})

# Density plots, t0과 t1... 다수의 tn에 대해 구현함.
output$DensityPlot = renderPlot({
  if(length(input$mcmc_file) <= 1) return({}) 
  
  layout(matrix(1:(ncol(mcmc_data())-2),1,ncol(mcmc_data())-2))
  counter = 0 # t0, t1계속 증가시키기 위한 카운터터
  for (i in mcmc_data()[,-c(1,2)]) {
    par(mar=c(4,4,1,.1), cex.lab=1.5)
    label = paste0('t', counter); counter = counter + 1
    plot(density(i), xlab = label, main='')
  }
})

# Autocorrelation and ESS, Creating MCMC object
ti.mcmc = reactive({
  if(length(input$mcmc_file) <= 1) return({})
  line = mcmc_data()
  line$logPosterior = line$loglikelihood + line$logprior
  line = line %>% relocate(c("logPosterior", "loglikelihood", 'logprior'))
  mcmc(line)
})

# MCMC summary
output$MCMC_summary = renderPrint({
  if(is.null(ti.mcmc())) {return ()}
  summary(ti.mcmc())
})

# MCMC Autocorrelation - matrix
output$MCMC_corrdiag = renderPrint({
  if(is.null(ti.mcmc())) {return ()}
  autocorr.diag(ti.mcmc())
})

# MCMC Autocorrelation - plot
output$MCMC_corrplot = renderPlot({
  if(is.null(ti.mcmc())) {return ()}
  line = as.data.frame(ti.mcmc())
  if (ncol(line) %% 3 == 0) {
    mtxlen = ncol(line) %/% 3 # 행 개수
  } else {
    mtxlen = (ncol(line) %/% 3) + 1 # 행 개수
  }
  layout(matrix(1:(mtxlen * 3), nrow = mtxlen, ncol = 3, byrow = T))
  par(cex.lab=1.8)
  title.label = c("logPosterior",colnames(line)) # 이유를 알수없지만, logposterior 의 열이름이 추출이 안됨.
  counter = 1
  for (i in line){
    if (ncol(line) > (counter + 2)) {
      counter = counter + 1
      autocorr.plot(i, auto.layout = FALSE, ann =F)
      title(main = title.label[counter], cex.main = 2, ylab = "Autocorelation")
      next
    } else {
      counter = counter + 1
      autocorr.plot(i, auto.layout = FALSE)
      title(main = title.label[counter], cex.main = 2)
    }
  }
})



# MCMC Autocorrelation - crosscorr
output$MCMC_Crosscorr = renderPrint({
  if(is.null(ti.mcmc())) {return ()}
   crosscorr(ti.mcmc()) 
})


# MCMC Effective size
output$MCMC_effect = renderPrint({
  if(is.null(ti.mcmc())) {return ()}
  effectiveSize(ti.mcmc())
})

# Geweke's convergence diagnostics
output$Geweke = renderPrint({
  if(is.null(ti.mcmc())) {return ()}
  geweke.diag(ti.mcmc(), input$GewekeFrac1, input$GewekeFrac2)
})

# Heidelberger and Welch's convergence diagnostic
output$Heidel.welch = renderPrint({
  if(is.null(ti.mcmc())) {return ()}
  heidel.diag(ti.mcmc())
})

# Raftery and Lewis's diagnostic
output$Raftery.Lewis = renderPrint({
  if(is.null(ti.mcmc())) {return ()}
  raftery.diag(ti.mcmc())
})


# TableCheck
#output$datatable = renderTable(
#  if(length(allPath())!=0) {
#    return (head(mcmc_data(),20))
#})


# Filename return Type2
#mist_file <- reactive(input$mist_input)
#output$filechosen <- renderText({
#  allPath = as.character(parseFilePaths(c(wd='.'),mist_file())$datapath)
#  tail(strsplit(allPath, '/', fixed = TRUE)[[1]], 1)
#})
