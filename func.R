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

## origin version ##
cores <- c("#2d2d2d", "#098ebb", "#fdc23a", "#e96449", "#D3BBAF", "#ddcdbf", "#e6c26c") # 카이제곱의 "#818286"이 겹쳐서 수정하였음.
