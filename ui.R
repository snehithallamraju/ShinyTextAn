#---------------------------------------------------------------------#
#                 UDPipe Shiny App                               #
#---------------------------------------------------------------------#
library("shiny")

shinyUI(
  fluidPage(
    
    titlePanel("UDPipe Shiny App"),
    
    sidebarLayout(
      
      sidebarPanel(
      
      fileInput("file", "Select a file"),
      
      checkboxGroupInput("checkGroup", 
                         label = h6("Select the Universal part-of-speech tags (upos)"), 
                         choices = list("Adjective" = 'ADJ', 
                                        "Noun" = 'NOUN', 
                                        "Proper Noun" = 'PROPN',
                                        "Adverb" = 'ADV',
                                        "Verb" = 'VERB'),
                         selected = list('ADJ','NOUN','PROPN'))
      ),   # end of sidebar panel

    
    mainPanel(

      tabsetPanel(type = "tabs",
                  tabPanel("Overview",
                           h4("Introduction")
                  ),
                  tabPanel("Data",
                           h4('Annotated Document'),
                           dataTableOutput('tbl2'),
                           
                           # Button
                           downloadButton('downloadData', "Download Annotated Data")
                  ),
                  tabPanel("WordCloud",
                           h4('Noun WordCloud'),                           
                           plotOutput("cloud1"),
                           h4('Verb WordCloud'),                           
                           plotOutput("cloud2")
                  ),
                  tabPanel("Co-Occurence Plot",
                           plotOutput('plot')
                  )
                 
      ) # end of tabsetPanel
    )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI