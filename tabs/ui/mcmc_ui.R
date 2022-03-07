# UI file

library(shinythemes)
library(shinyFiles)
library(shinyWidgets)

mcmc = tabPanel("MCMC",value='mcmc',
            fluidPage("MCMC", value='mcmc', 
                  titlePanel(em("MCMC"),windowTitle = "MCMC-test"),
                  
                  sidebarLayout(
                      sidebarPanel(
                          shinyFilesButton("mcmc_file", "Choose a file" ,
                                            title = "Please select a file:", multiple = FALSE,
                                            buttonType = "default", class = NULL, icon(name="file-upload")),
                          
                          verbatimTextOutput('filechosen'),
                          
                          hr(),
                          materialSwitch(inputId = 'ViewAll', label = h4('Select all'), value = FALSE, status = "info" ),
                          checkboxGroupButtons("print_out",label= h4("Select methods"),choiceNames =
                                             list("Trace Plot", "Density Plot", "Autocorrelation and ESS", "Geweke's convergence diagnostic",
                                                  "Heidelberger and Welch's convergence diagnostic", "Raftery and Lewis's diagnostic"),
                                           choiceValues = list("TP","DP","CORR","GE","HE","RA"),choices=NULL ,
                                           direction = "vertical", justified = TRUE), # size = 'lg' 매개변수 주면 칸에 안맞음.

                          
                          width = 3),
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
                          column(width=6,sliderInput("GewekeFrac1", h5("fraction to use from beginning of chain :") , min = 0 , max = 0.5, value = 0.1 )),
                          column(width=6,sliderInput("GewekeFrac2", h5("fraction to use from end of chain :") , min = 0 , max = 0.5, value = 0.5 )),
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
                        width = 9)
                  )
            )
      )
