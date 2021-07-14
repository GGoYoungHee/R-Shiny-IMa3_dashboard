#setwd("C:/Users/koh99/ë°”íƒ• ?™”ë©?/Labs_KGU/IMa3")
getwd()
library(shiny)
library(shinythemes)
#install.packages('shinythemes')

# file load
source("func.R")
source("tabs/ui/home.R",local=T)
source("tabs/ui/plot.R",local=T)
source("tabs/ui/bt.R",local=T)

#install.packages('shinyFiles')

ui<-fluidPage(
  navbarPage(title="HELLO!!",
               id='navbar',
               theme=shinytheme("superhero"),
               #theme="styles.css",
               selected='home',
               fluid=T,
               
               # tabs
               home,
               plot,
               bt,              
               #tabPanel("PLOT",value='plot',hr(),plotOutput('myplot')),
               #tabPanel("PLOT",plotOutput('myplot'),value='plot'),
               #tabPanel("BRUN&THIN",value='bt'),
               tabPanel("ABOUT US",value='about')
               ))

server<-function(input,output,session){
  source("tabs/server/home.R",local=T)
  source("tabs/server/plot.R",local=T)
  source("tabs/server/bt.R",local=T)
  
}

shinyApp(ui,server)




'''
ì§ˆë¬¸
1. HELLO ê°€? œ ??€?‹  ?›¹ ?˜?´ì§€ ?´ë¦„ì´ ?•„?š”?•´?š”!
2. ?˜?´ì§€ ?ƒ?„¸ ?„¤ëª? ?•„?š”?•´?š”!
'''

'''
ë³´ì™„? 
1. tabpanel uië¶€ë¶? ì¶©ëŒ  ---?•´ê²?...! (?›„ ?›?¸ ì°¾ê¸° ?˜?“¤?—ˆ?”°...^_^)
  -> ì¶©ëŒë¬¸ì œ ?•„?‹ˆê³? html ë¬¸ì œ??€?Œ
2. plot ?ƒ­ ë¶€ë¶? ?°?´?„° ë³€ê²½ìœ¼ë¡? ?¸?•œ ì½”ë“œ ë³€ê²?
3. plot ?ƒ­: download ë²„íŠ¼ pdf ~~ ë­? ê¸°í?€ ?“±?“±?œ¼ë¡? ?„ ?ƒ ê°€?Š¥?•˜ê²?
'''


# ?•ˆ?— ?ˆ?Š” ?‚´?š©??€ ?˜‘ê°™ìŒ
# 


