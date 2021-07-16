about<-tabPanel("ABOUT US",value='about',
                fluidRow(
                  h3('Yujin Chung',align='center'),
                  column(1),
                  column(10,
                         wellPanel("Hello!",br(),"test")),
                  column(1)
                  #wellPanel("Hello! :)",br(),'Test')
                  ),
                
                fluidRow(
                  h3('YoungHee Go',align='center'),
                  column(1),
                  column(10,
                         wellPanel("test1")),
                  column(1)
                  ),
                
                fluidRow(
                  h3('SuYoung Ko',align='center'),
                  column(1),
                  column(10,
                         wellPanel("description")),
                  column(1)
                ),
                
                
                br(),br(),hr(),
                
                
                column(4,p(icon('envelope'),"    ",' yujinchung@kyonggi.ac.kr')),
                column(5,p(icon('phone-alt'), "       ",'031-249-8774')),
                column(3,img(src='https://kmug.co.kr/data/file/design/data_logo_kgu2006.jpg',height=50)),
                
    
  

              )


