tab_im <- function(text, cor,id){
  HTML(paste0('<a id="', id,'" href="#" class="action-button">
                  <div class = "voronoys-block" style = "background-color:', cor, '; padding:25px; color:white;"> 
                  <span class = "name">', text, '</span>
                  <div class="img_block">
                    <div class="img_block_conteiner">
                    </div>
                  </div>
              </div></a>'))
}

#<img src="img/',icon,'">

#cores <- c("#098ebb", "#fdc23a", "#e96449") #"#818286"
#cores<-cores<-c('#025ab8','#00a053','#ea5504') #06bf66

# dark green
cores<-cores<-c('#025ab8','#018c49','#ea5504')