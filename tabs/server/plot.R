source_python('./tabs/server/IMa3_data.py')

data<-reactive({
  
  file1<-input$file
  if (is.null(file1)){return()}
  
  dataSet<-ExData(file1$datapath)
  
  
  # L?? ?????ϴ? ?÷?�� ???ùڽ??? ?? ???�???! -> ¦????° ?÷??? ??��
  ch_col<-c()
  col.vec<-colnames(dataSet)
  #print(col.vec)
  for ( k in 1:length(col.vec)){
    if (k%%2==1){
      ch_col<-c(ch_col,col.vec[k])
    }
  }  
  
  q.vec<-c()
  m.vec<-c()
  t.vec<-c()
  
  
  for (ch in ch_col){
    if (str_detect(ch,'q')){q.vec<-c(q.vec,ch)}
    if (str_detect(ch,'m')){m.vec<-c(m.vec,ch)}
    if (str_detect(ch,'t')) {t.vec<-c(t.vec,ch)}
  }
  cat('q: ',q.vec,'\n')
  cat('m: ',m.vec,'\n')
  cat('t: ',t.vec,'\n')
  
  if (input$group_col=='Q'){
    updateCheckboxGroupInput(session,"combobox",choices=q.vec)
  }
  else if (input$group_col=='M'){
    updateCheckboxGroupInput(session,"combobox",choices=m.vec)
  }
  else if(input$group_col=='T'){
    updateCheckboxGroupInput(session,"combobox",choices=t.vec)
  }
  
  dataSet
})

new.df<-reactive({
  
  test<-list()
  for (i in 1:length(input$combobox)){
    n<-which(colnames(data())==input$combobox[i])
    test[[input$combobox[i]]]<-c(n,n+1)
  }
  new.df<-data.frame(data()[,unname(unlist(test))])  
  
  for (j in colnames(new.df)){
    new.df[[j]]<-as.numeric(new.df[[j]])
  }
  
  new.df
})



plot_obj <-function(){
  # Group columns ?? ???ý? ?Ͼ? ???��? ???̱?
  if (is.null(input$combobox)){
    plot.new()
  }    
  
  
  else{
    x.min=100 ; x.max=0 ; y.min=100 ; y.max=0
    
    for (col in 1:length(new.df())){
      # Ȧ????° ?÷? : x??
      if (col %%2==1){
        if (x.min > min(new.df()[col])){
          x.min<-min(new.df()[col])
        }
        if(x.max<max(new.df()[col])){
          x.max<-max(new.df()[col])
        }
        
        
      }
      
      # ¦????° ?÷? : y??
      else{
        if (y.min > min(new.df()[col])){
          y.min<-min(new.df()[col])
        }
        if (y.max < max(new.df()[col])){
          y.max<-max(new.df()[col])
        }
      }
    }
    
    
    # ?׷??? ?׸???
    
    plot.col<-1:8 # ?׷??? ???? ??�� ????
    
    for (col in 1:length(new.df())){
      # Ȧ????° ?÷?: x??
      if (col%%2==1){
        if (col==1){
          
          plot(new.df()[,c(col,col+1)],xlim=c(x.min,x.max),ylim=c(y.min,y.max),type='l',xlab=input$group_col,ylab='Density')
        }
        else{
          lines(new.df()[,c(col,col+1)],col=plot.col[(col+1)%/%2])
        }
      }
    }
    legend('topright',input$combobox,col=plot.col[1:length(input$combobox)],lty=1)
    
  }
}

output$myplot<-renderPlot(plot_obj())

output$table<-renderTable(
  head(data(),15)
)

output$tb <-renderUI({
  if(is.null(data()))
    h5("No available data yet.")
  else
    tabsetPanel(tabPanel("data",tableOutput("table")),tabPanel("Histogram",plotOutput("myplot")))
})


output$download <-downloadHandler(
  filename=function(){paste0("histogram_",input$group_col,".",input$down_opt,setp="")},
  content = function(file){
    if (input$down_opt=='png'){
      png(file)
    }else if(input$down_opt=='jpeg'){
      jpeg(file)
    }else{
      pdf(file)
    }
    plot_obj()
    dev.off()
  }
)