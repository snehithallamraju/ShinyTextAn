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
                           h4("Introduction"),
                           p("This app aims to read text and using UDPipe's tokenization, tagging, lemmatization and dependency parsing functionality, it aims to provide inputs on the text file "),
                           br(),
                           
                           strong("Note : This app works only for *.TXT files"),
                           br(),
                           br(),
                           p("This app has three tabs "),
                           p("a. Data : This provides the Annotated document using UDPipe's English Repo. This shows only 100 lines by default. Click the 'Download Annotated Data' button to download the full table "),
                           p("b. WordCloud : This provides the wordclouds of most used Nouns and Verbs from your input Text "),
                           code("Minimum frequency for occurence is defined as 2. Maximum number of words are 100"),
                           br(),
                           p("c. Co-Occurence plot : This provides the plot for the selected parts of speech. The input for this is the selection of Universal Parts of Speech(upos) on the left. Check for multiple selections to analyze how the co-occurence changes"),
                           br(),
                           code("To get started, browse & upload a text file in the file upload section on the left")
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
