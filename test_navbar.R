setwd("C:/Users/koh99/바탕 화면/Labs_KGU/IMa3")
getwd()
library(shiny)



library(shinythemes)
# file load
source("func.R")
source("tabs/ui/home.R",local=T)
source("tabs/ui/plot.R",local=T)


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
               #tabPanel("PLOT",value='plot',hr(),plotOutput('myplot')),
               #tabPanel("PLOT",plotOutput('myplot'),value='plot'),
               tabPanel("BRUN&THIN",value='bt'),
               tabPanel("ABOUT US",value='about')
               ))

server<-function(input,output,session){
  source("tabs/server/home.R",local=T)
  source("tabs/server/plot.R",local=T)
  
}

shinyApp(ui,server)




'''
질문
1. HELLO 가제 대신 웹 페이지 이름이 필요해요!
2. 페이지 상세 설명 필요해요!
'''

'''
보완점
1. tabpanel ui부분 충돌  ---해결...! (후 원인 찾기 힘들었따...^_^)
  -> 충돌문제 아니고 html 문제였음
2. plot 탭 부분 데이터 변경으로 인한 코드 변경
3. plot 탭: download 버튼 pdf ~~ 뭐 기타 등등으로 선택 가능하게
'''


# 안에 있는 내용은 똑같음
# 


