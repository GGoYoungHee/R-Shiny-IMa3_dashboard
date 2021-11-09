
home<-tabPanel(title='HOME',
               value="home",
               #hr(),
               br(), br(),
               
               p('WELCOME!',strong("HELLO!!"),'WEBPAGE.'),
              
               
               br(),br(),br(),br(),
               column(width=4,align='center',
                      tab_im(text="Plot",cor=cores[1],id="plot")),
               
               column(width=4,align='center',
                      tab_im(text="Burn & Thin",cor=cores[2],id="bt")),
               
               column(width=4,align='center',
                      tab_im(text="ABOUT",cor=cores[3],id="about")),
               br(),br(),
               column(width=4,align='center',
                      tab_im(text="MCMC",cor=cores[4],id="mcmc")),
               br(),
               column(width=12,
                      br(),br(),br(),br(),
                      wellPanel("This Page is for ~~~. ")))


