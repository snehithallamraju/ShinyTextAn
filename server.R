# UDPipe Server file
shinyServer(function(input, output) 
{
  # Define a reactive variable named `input_file`  
  input_file <- reactive({
    if (is.null(input$file)) {
      return("")
    }
    else
    {
      # Read the text in the uploaded file
      input <- readLines(input$file$datapath)
      input <- str_replace_all(input, "<.*?>", "")
      input <- input[input != ""]
    }
  })
  
  #Download Udpip English model and load it  
  udmodel_eng = reactive({
#    d1 <- udpipe_download_model(language = "english")
    udmodel_eng <- udpipe_load_model("english-ud-2.0-170801.udpipe")
    return(udmodel_eng)
    
  })
  
  #Task1 - Annotate
  annotate = reactive({
    t1 <- udpipe_annotate(udmodel_eng(), x = input_file())
    t1 <- as.data.frame(t1)
    t1$sentence <- NULL
    return(t1)
    
  })
  #print(t1)
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      #paste(t1, ".csv", sep = "")
      "data.csv"
    },
    content = function(file) {
      write.csv(annotate(), file, row.names = FALSE)
    }
  )
  
  #Render Datatable output for Annotated document
  output$tbl2 <- renderDataTable({ 
    out = head(annotate(), 100)
    options = list(pageLength = 25)
    return(out)
  })
  
  #WordCloud for Nouns
  output$cloud1 = renderPlot({
    nouns = annotate() %>% subset(., upos %in% "NOUN") 
    top_nouns = txt_freq(nouns$lemma)  # txt_freq() calcs noun freqs in desc order
    
    wordcloud(words = top_nouns$key, 
              freq = top_nouns$freq, 
              min.freq = 2, 
              max.words = 100,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"))
  })
  #WordCloud for Verbs

  output$cloud2 = renderPlot({
    verbs = annotate() %>% subset(., upos %in% "VERB") 
    top_verbs = txt_freq(verbs$lemma)
    
    wordcloud(words = top_verbs$key, 
              freq = top_verbs$freq, 
              min.freq = 3, 
              max.words = 100,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"))
  })
  
  #Co-occurence Plot
  output$plot = renderPlot({
    # Sentence Co-occurrences for nouns or adj only
    t1_cooc <- cooccurrence(   	# try `?cooccurrence` for parm options
      x = subset(annotate(), upos %in% input$checkGroup), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
    # str(nokia_cooc)
    head(t1_cooc)
    
    wordnetwork <- head(t1_cooc, 50)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "lightgreen") +  
      geom_node_text(aes(label = name), col = "darkred", size = 5) +
      
      theme_graph(base_family = "Helvetica") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences within 3 words distance")
  })
}
)
#shinyApp(ui,server)

