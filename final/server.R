server <- function(input, output) {
  
  #.......
  #select data, get the table
  type <- table(food$Results)
  TT <- data.frame(type)
  colnames(TT) <- c("Types","Freq")
  newfood = filter(food,food$`License #`!="0")
  type2 = table(newfood$`License #`)
  LL = data.frame(type2)
  colnames(LL) <- c("License","Freq")
  #.......
  #create map
  color <- colorFactor(topo.colors(7), food$Risk)
  
  output$map <- renderLeaflet({
    map <- leaflet(food) %>%
      
      setView(lng = -87.6298, lat = 41.8781, zoom = 10) %>%
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE)) %>%
      addCircleMarkers(
        lng=~Longitude,
        lat=~Latitude,
        radius=~Risk,
        stroke=FALSE,
        fillOpacity=0.5,
        color=~color(Risk),
        popup=~paste(
          "<b>", Risk, "</b><br/>",
          "count: ", as.character(Risk), "<br/>"
        ),
        clusterOptions = markerClusterOptions()
      ) %>%
      addLegend(
        "bottomleft", # Legend position
        pal=color, # color palette
        values=~Risk, # legend values
        opacity = 1,
        title="The Risk Levels"
      )
  })
  
  #..............2...........................
  d <- hash()
  for (i in 1:63) {
    
    d[[as.character(i)]] = 0
  }
  violation = food$Violations
  for (i in 1:length(violation)) {
    x = violation[i]
    m <- gregexpr('[0-9]+[.]+ ',x)
    go = regmatches(x,m)
    l = as.character(gsub(". ","",go[[1]][1]))
    i = is.na(l)
    if (identical(i, TRUE)) {
      
    } else {
      for (j in 1:length(go[[1]])) {
        l = as.character(gsub(". ","",go[[1]][j]))
        o = nchar(l) >= 3
        if (identical(o, TRUE)) {
          
        } else {
          d[[l]] = d[[l]] + 1
        }
        
      }
    }
    
  }
  
  v1 = c(1:63)
  v2 = c()
  for (i in 1:63) {
    v2 = c(v2, as.integer(d[[as.character(i)]]))
  }
  VV = as.data.frame(cbind(v1,v2))
  colnames(VV) <- c("violation","Freq")
  
  
  output$plot2 <- renderPlot({
    ggplot(VV, aes(x=violation, y=Freq)) + geom_bar(stat = "identity")+
      geom_text(aes(label=Freq), vjust=-0.3, size=2.5)+
      theme_minimal()
  })
  
  #....................2....................
  #....................3....................
  
  h <- hash()
  rand <- eventReactive(input$goButton,{
    my_table <- as.data.frame(sample(LL$License, 50))
    names(my_table) <- "x"
    return(my_table)
  })
  output$plotvio <- renderPlot({
    my_table <- rand()
    if(is.null(my_table)){
      return(NULL)
    }else{
      
      for (i in 1:length(LL$License)) {
        
        h[[as.character(LL$License[i])]] = LL$Freq[i]
        
      }
      myL1 = c(my_table$x[1:50])
      as.character(my_table$x[1])
      myL2 = c()
      for (i in 1:50) {
        myL2 = c(myL2, as.integer(h[[as.character(my_table$x[i])]]))
      }
      
      please <- do.call(rbind, Map(data.frame, A=myL1, B=myL2))
      colnames(please) <- c("License","Freq")
      #............
      
      
      ggplot(please,aes(x=License,y=Freq)) + geom_bar(stat="identity") + theme_minimal();
    }})
  
  
  
  
  output$table1 <- renderTable({
    my_table <- rand()
    
    if(is.null(my_table)){
      return(NULL)
    }else{
      my_table
    }
  });
}