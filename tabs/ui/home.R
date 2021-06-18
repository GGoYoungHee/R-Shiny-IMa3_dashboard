
home<-tabPanel(title='HOME',
               value="home",
               hr(),
               br(), br(),
               #HTML("<h1> <center> WELCOME! <b>hello!!<b> WEBPAGE </center> </h1>"), 
               p('WELCOME!',strong("HELLO!!"),'WEBPAGE.'),
               # 이거 html 이 아니라 p로 바꾸기!!!
               # 아니면 column으로 하던지~
               
               br(),br(),br(),br(),
               column(width=4,align='center',
                      tab_im(text="Plot",cor=cores[1],id="plot")),
               column(width=4,align='center',
                      tab_im(text="Burn & Thin",cor=cores[2],id="bt")),
               column(width=4,align='center',
                      tab_im(text="About us",cor=cores[3],id="about")),
               
               column(width=12,
                      br(),br(),br(),br(),
                      wellPanel("This Page is for ~~~. ")))


