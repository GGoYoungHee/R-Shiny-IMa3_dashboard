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
cores <- c("#0A043C", "#098ebb", "#fdc23a", "#e96449", "#D3BBAF", "#ddcdbf", "#e6c26c") # color range

# 경로설정.
volumes = c('wd'='.')

# 에러 대처용. shinythemes() 함수 동작하지 않음.
shinytheme <- function(theme = NULL) {
  # Check that theme exists
  if (is.null(theme) || !theme %in% allThemes()) {
    stop(theme, " is not an available theme. Valid themes are: ",
         paste(allThemes(), collapse = ", "), ".")
  }
  
  paste0("shinythemes/css/", theme, ".min.css")
}


# 해당 함수가 변경되었음.
allThemes <- function() {
  themes <- dir(system.file("shinythemes/css", package = "shinythemes"), ".min.css")
  sub(".min.css", "", themes)
}