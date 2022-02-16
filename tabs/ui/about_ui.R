about<-tabPanel("ABOUT",value='about',
                
                fluidRow(
                  h3('About Us',align='center'),
                  column(1),
                  column(10,
                         wellPanel(p("We are in professor Yujin Chung's lab at Kyunggi University majoring in applied Statistics."),
                                   p("This lab is where BioStatistics is studied."),
                                   p('Here is a little information about dashboard\'s contributors.'),
                                   p('~~~~~~~~~~~~')
                                   )),
                  column(1)
                  
                ),
                br(),
               
           
                ### Contributors ###
                fluidRow(
                  column(1),
                  column(10,
                         wellPanel(p(strong("Yujin Chung"),' - Project Leader ~~~~'),
                                   p(strong("YoungHee Go")," - Developing basic code, Making home and plot tab"),
                                   p(strong("SuYoung Ko")," - Making burn & thin tab ~~~ "),
                                   p(strong("KaYeoung Kim")," - Editing ct tab & Debugging"),
                                   p(strong("JaeHyung Jeong")," - Making MCMC tab, Editing splitting_times tabs, code optimization"),
                                   p(strong("SuBin Kim")," - Making Splitting_times tab ~~~"),
                                   p(strong("JiSu Lee")," - Making ct tab ~~~ "),
                                   )),
                  column(1)
                  ),
                
                
                ### contact ###
                column(1),
                column(1,strong('Contact')),
                column(5,p(icon('envelope'),"    ",' yujinchung@kyonggi.ac.kr')),
                column(1),
                column(4,img(src='https://kmug.co.kr/data/file/design/data_logo_kgu2006.jpg',height=50)),
               
              )


