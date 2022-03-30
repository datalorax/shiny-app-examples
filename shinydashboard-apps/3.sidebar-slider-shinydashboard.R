library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Histogram", tabName = "histo", icon = icon("chart-bar")),
      sliderInput("slider", "Number of observations:", 1, 100, 50)
    )
  ),
  dashboardBody(
    fluidRow(
      box(plotOutput("plot1", height = 250))
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)
