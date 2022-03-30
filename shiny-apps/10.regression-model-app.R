library(shiny)
library(shinyWidgets)
library(palmerpenguins)
library(gtsummary)
library(gt)

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
      gt_output("tbl")
    )
  )
)

server <- function(input, output) {
  model <- reactive({
    form <- paste("bill_length_mm ~ ", paste(input$xvars, collapse = " + "))
    lm(as.formula(form), penguins)
  })

  output$tbl <- render_gt({
    as_gt(tbl_regression(model(), intercept = TRUE))
  })
}

shinyApp(ui = ui, server = server)
