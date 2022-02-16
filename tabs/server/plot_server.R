source_python('./tabs/server/IMa3_data.py')

data<-reactive({
  # file input
  file1<-input$file
  if (is.null(file1)){return()}
  
  dataSet<-ExData(file1$datapath)
  
  
  # Extract X-axis data and classify to Group columns
  ch_col<-c()
  col.vec<-colnames(dataSet)
  
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
  
  if (input$group_col=='Q'){
    if (length(q.vec)==0){updateCheckboxGroupInput(session,"combobox",choices=NA)}
    else{updateCheckboxGroupInput(session,"combobox",choices=q.vec)}
  }
  
  else if (input$group_col=='M'){
    if (length(m.vec)==0){updateCheckboxGroupInput(session,"combobox",choices=NA)}
    else{updateCheckboxGroupInput(session,"combobox",choices=m.vec)}
    }
    
  else if(input$group_col=='T'){
    if (length(t.vec)==0){updateCheckboxGroupInput(session,"combobox",choices=NA)}
    else{updateCheckboxGroupInput(session,"combobox",choices=t.vec)}
  }
  

  dataSet
})

# data frame for histogram 
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


## Making Histogram ##
plot_obj <-function(){
  if (is.null(input$combobox)){
    plot.new()
  }    
  else{
    if (input$combobox==""){
      plot.new()
      text(x=0.5, y=0.9, cex=2,paste('No Group column: ', input$group_col, 'column'))
    }
    
    else{
      # Set Initial Values
      x.min=100 ; x.max=0 ; y.min=100 ; y.max=0
      
      for (col in 1:length(new.df())){
        
        # X-axis : odd columns 
        if (col %%2==1){
          if (x.min > min(new.df()[col])){
            x.min<-min(new.df()[col])
          }
          if(x.max<max(new.df()[col])){
            x.max<-max(new.df()[col])
          }
          
          
        }
        
        # Y-axis : even columns
        else{
          if (y.min > min(new.df()[col])){
            y.min<-min(new.df()[col])
          }
          if (y.max < max(new.df()[col])){
              y.max<-max(new.df()[col])
          }
        }
      }
      
      
      # Set color in Histogram 
      plot.col<-1:8  
      # black -> red -> green -> blue -> turquoise -> magenta -> yellow -> gray
      
      for (col in 1:length(new.df())){
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
}

output$myplot<-renderPlot(plot_obj())

output$table<-renderTable(head(data(),15))

## Tab Set : data, Histogram
output$tb <-renderUI({
  if(is.null(data()))
    h5("No available data yet.")
  else
    tabsetPanel(id='tabSet',
                tabPanel("data",tableOutput("table")),
                tabPanel("Histogram",plotOutput("myplot")))
})

# Update Tab
observeEvent(length(input$combobox)>0,{
  updateTabsetPanel(session=session,inputId = 'tabSet',selected='Histogram')
})

## Histogram Down
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
