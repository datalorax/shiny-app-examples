library(shiny)

uiHist <- function(id) {
  tagList(
    selectInput(NS(id, "var"), "Variable", names(mtcars)),
    numericInput(NS(id, "bins"), "bins", 10, min = 1),
    plotOutput(NS(id, "hist"))
  )
}

serverHist <- function(id) {
  moduleServer(id, function(input, output, session) {
    data <- reactive(mtcars[[input$var]])

    output$hist <- renderPlot({
      hist(
        x = data(),
        breaks = input$bins,
        main = input$var
      )
    })
  })
}


# Note - the functions above would normally go in their own .R files

ui <- fluidPage(
  uiHist("histo")
)

server <- function(input, output, session) {
  serverHist("histo")
}

shinyApp(ui = ui, server = server)
