library(shiny)
library(shinyWidgets)
library(palmerpenguins)
library(gtsummary)
library(gt)

ui <- fluidPage(
  titlePanel("Regression Example"),
  withMathJax(),
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
      gt_output("tbl"),
      eqOutput("equation")
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

  output$equation <- renderEq(
    extract_eq(
      model(),
      wrap = TRUE,
      terms_per_line = 2,
      use_coefs = TRUE,
      font_size = "Large"
    )
  )
}

shinyApp(ui = ui, server = server)
