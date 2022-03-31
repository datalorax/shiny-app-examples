library(shiny)
library(ggplot2)
library(palmerpenguins)

numeric_vars <- names(dplyr::select_if(penguins, is.numeric))
non_numeric_vars <- setdiff(names(penguins), numeric_vars)

ui <- fluidPage(
  titlePanel("Palmer Penguins Relationships"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectInput(
        inputId = "xvar",
        label = "Select the x-axis variable",
        choices = numeric_vars,
        selected = "body_mass_g"
      ),
      selectInput(
        inputId = "yvar",
        label = "Select the y-axis variable",
        choices = numeric_vars,
        selected = "bill_length_mm"
      ),
      selectInput(
        inputId = "colorby",
        label = "Color points by:",
        choices = c("None", non_numeric_vars),
        selected = "None"
      )
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {

  output$plot <- renderPlot({
    p <- ggplot(penguins, aes(!!sym(input$xvar), !!sym(input$yvar)))

    if (input$colorby == "None") {
      p <- p +
        geom_point(size = 3)
    } else {
      p <- p +
        geom_point(
          aes(color = !!sym(input$colorby)),
          size = 3
        )
    }
    p +
      geom_smooth(size = 2) +
      theme_minimal(25)
  })

}

shinyApp(ui = ui, server = server)
