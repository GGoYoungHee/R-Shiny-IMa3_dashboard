
home<-tabPanel(title='HOME',
               value="home",
               #hr(),
               br(),
               
               p(strong("HELLO!!"),'R-Shiny-IMa3_dashboard - WEBPAGE.'),
               
               br(),
               
               column(width=12, wellPanel("This Page is for ~~~. ")),
               
               br(),
               
               column(width=12,align='center',tags$img(src=base64enc::dataURI(file="www/MCMC.jpg", mime="image/png"),height = '500px'))
               
               
)

# selector removed
#column(width=3,align='center',
#       tab_im(text="Plot",cor=cores[1], id="plot")),
#
#column(width=3,align='center',
#       tab_im(text="Burn & Thin",cor=cores[1], id="bt")),
#
#column(width=3,align='center',
#       tab_im(text="ABOUT",cor=cores[1], id="about")),
#
#column(width=3,align='center',
#       tab_im(text="MCMC",cor=cores[1], id="mcmc")),
#
#br(), br(),



