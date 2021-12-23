
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
               
               column(width=12,
                      br(),br(),br(),br(),
                      wellPanel("This Page is for ~~~. ")),
               
               
               column(width=12,align='center',tags$img(src=base64enc::dataURI(file="www/MCMC.jpg", mime="image/png"),height = '500px'))
               
               
)


