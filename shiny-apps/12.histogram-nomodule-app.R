library(shiny)

ui <- fluidPage(
  selectInput("var", "Variable", names(mtcars)),
  numericInput("bins", "bins", 10, min = 1),
  plotOutput("hist")
)

server <- function(input, output, session) {
  data <- reactive(mtcars[[input$var]])

  output$hist <- renderPlot({
    hist(
      x = data(),
      breaks = input$bins,
      main = input$var
    )
  })
}

shinyApp(ui = ui, server = server)
