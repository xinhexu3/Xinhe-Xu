ui <- fluidPage(titlePanel("FDA strategic inspection plan of Chicago area in year 2020"),
                tabsetPanel(id='my_tabsetPanel',
                            tabPanel("Risk Map",leafletOutput("map", width = "155%", height = 710)),
                            tabPanel("Amount of Each Violation",plotOutput("plot2", width = "155%", height = 710)),
                            tabPanel("Random Merchants & Violations",fluid=TRUE,
                                     sidebarLayout(
                                       sidebarPanel(
                                         actionButton("goButton","GO 385!"),width = 2),
                                       mainPanel(
                                         tabsetPanel(
                                           tabPanel("License # of 50 Random Merchants",tableOutput("table1")),
                                           tabPanel("Their Violations",plotOutput("plotvio"))
                                         ),width = 10
                                         )))))