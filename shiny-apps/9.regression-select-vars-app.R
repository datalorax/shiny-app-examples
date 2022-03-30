library(shiny)
library(shinyWidgets)
library(palmerpenguins)

ui <- fluidPage(
  titlePanel("Regression Example"),
  sidebarLayout(
    sidebarPanel(
      multiInput(
        inputId = "xvars",
        label = "Select predictor variables :",
        choices = names(penguins)[-3],
        selected = "island"
      )
    ),
    mainPanel(

    )
  )
)

server <- function(input, output) {

}

shinyApp(ui = ui, server = server)
