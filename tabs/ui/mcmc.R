# UI file

library(shinythemes)
library(shinyFiles)

mcmc = tabPanel("MCMC",value='mcmc',
            fluidPage("MCMC", value='mcmc', 
                  titlePanel(em("MCMC"),windowTitle = "MCMC-test"),
                  
                  sidebarLayout(
                      sidebarPanel(
                        # CSS를 어떻게 건드려야할지 감이 안옵니다.
                        tags$head(
                          tags$style(HTML('
                            .form-group shiny-input-checkboxgroup shiny-input-container shiny-bound-input {
                              font-size:50px;
                              height:10px;
                            }
      
                            .form-group shiny-input-container {
                              font-size:12.5px;
                            }
                        '))),
                        # CSS 부분 끝.
                          shinyFilesButton("File_input", "Choose a file" ,
                                            title = "Please select a file:", multiple = FALSE,
                                            buttonType = "default", class = NULL, icon(name="file-upload")),
                          
                          verbatimTextOutput('filechosen'),
                          
                          hr(),
                          checkboxInput('ViewAll', 'Select all'),
                          checkboxGroupInput("print_out",label="Select methods",choiceNames =
                                               list("Trace Plot", "Density Plot", "Autocorrelation and ESS", "Geweke's convergence diagnostic",
                                                    "Heidelberger and Welch's convergence diagnostic", "Raftery and Lewis's diagnostic"),
                                             choiceValues = list("TP","DP","CORR","GE","HE","RA"),choices=NULL),
                          # actionButton("go","Run", icon(name="fas fa-play"))
                          
                      ),
                      mainPanel(
                        conditionalPanel(
                          condition = "input.print_out.includes('TP')",
                          tags$h2("Trace Plot"),
                          tags$h4("1. likelihood"),
                          plotOutput("TracePlot_LH"),
                          tags$h4("2. splitting times"),
                          plotOutput("TracePlot_SP"),
                          hr(),
                        ),
                        conditionalPanel(
                          condition = "input.print_out.includes('DP')",
                          tags$h2("Density Plots"),
                          tags$p(HTML("t0 and t1 \n OR One less Tn than 'Number of populations'")),
                          plotOutput("DensityPlot"),
                          hr(),
                        ),
                        conditionalPanel(
                          condition = "input.print_out.includes('CORR')",
                          tags$h2("Autocorrelation and ESS"),
                          tags$h4("1. Summary"),
                          verbatimTextOutput('MCMC_summary'),
                          tags$h4("2. Auto correlation"),
                          verbatimTextOutput('MCMC_corrdiag'),
                          tags$h4("3. Correlation Plot"),
                          plotOutput("MCMC_corrplot"),
                          tags$h4("4. Cross corelation"),
                          verbatimTextOutput('MCMC_Crosscorr'),
                          tags$h4("5. Effective size"),
                          verbatimTextOutput('MCMC_effect'),
                          hr(),
                        ),
                        conditionalPanel(
                          condition = "input.print_out.includes('GE')",
                          tags$h2("Geweke's convergence diagnostic"),
                          tags$p(HTML("A test for equality of the means of the first and last part of \n
                                    a Markov chain (by default the first 10% and the last 50%).")),
                          column(width=6,sliderInput("GewekeFrac1", "Geweke convergence diagnostic [Frac1] :" , min = 0 , max = 0.5, value = 0.1 )),
                          column(width=6,sliderInput("GewekeFrac2", "Geweke convergence diagnostic [Frac2] :" , min = 0 , max = 0.5, value = 0.5 )),
                          verbatimTextOutput('Geweke'),
                          hr(),
                        ),
                        conditionalPanel(
                          condition = "input.print_out.includes('HE')",
                          tags$h2("Heidelberger and Welch's convergence diagnostic"),
                          tags$p(HTML("heidel.diag is a run length control diagnostic based on a criterion of \n
                          relative accuracy for the estimate of the mean. The default setting corresponds to \n
                          a relative accuracy of two significant digits. \n
                          heidel.diag also implements a convergence diagnostic, and removes up to half \n
                          the chain in order to ensure that the means are estimated from a chain that has converged.")),
                          verbatimTextOutput('Heidel.welch'),
                          hr(),
                        ),
                        conditionalPanel(
                          condition = "input.print_out.includes('RA')",
                          tags$h2("Raftery and Lewis's diagnostic"),
                          tags$p(HTML("raftery.diag is a run length control diagnostic based on a criterion of accuracy of
                        estimation of the quantile q (default: 0.025). It is intended for use on a short pilot run of 
                        a Markov chain. The number of iterations required to estimate the quantile q to within an accuracy
                        of +/- r with probability p is calculated. Separate calculations are performed for each variable
                        within each chain.
                        If the number of iterations in data is too small, an error message is printed indicating the minimum
                        length of pilot run. The minimum length is the required sample size for a chain with no correlation
                        between consecutive samples. Positive autocorrelation will increase the required sample size above
                        this minimum value. An estimate I (the 'dependence factor') of the extent to which autocorrelation
                        inflates the required sample size is also provided. Values of I larger than 5 indicate strong
                        autocorrelation which may be due to a poor choice of starting value, high posterior correlations
                        or 'stickiness' of the MCMC algorithm.
                        The number of 'burn in' iterations to be discarded at the beginning of the chain is also calculated.")),
                          verbatimTextOutput('Raftery.Lewis'),
                        ),
 
                        # tableOutput("datatable") # TableCheck
                      )
                  )
            )
      )




# icon(name="fab fa-apple") 옵션을 지정하기 위해 등장한 라이브러리.
# ?icon을 친다음 나오는 링크에서 아이콘 종류 체크 가능. https://fontawesome.com/v5.15/icons?d=gallery&p=2
# 접속한뒤 아이콘 선택, start using 클릭, <i class="fas fa-angle-double-down"></i>에서 ""안에 내용 참조.

