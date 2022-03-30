library(shiny)
library(ggplot2)
library(reactable)
library(dplyr)

ui <- fluidPage(

    # Application title
    titlePanel("Highway MPG"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(width = 2,
        sliderInput("bins",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 30),
        radioButtons(
          inputId = "var",
          label = "Facet by:",
          choices = c("year", "trans", "class"),
          selected = "year",
          inline = TRUE
        )
      ),

      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel(
            title = "Plot",
            plotOutput("distPlot", height = "800px")
          ),
          tabPanel(
            title = "Table",
            reactableOutput("distTable")
          )
        )
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        ggplot(mpg, aes(hwy)) +
          geom_histogram(
            bins = input$bins,
            fill = "cornflowerblue",
            color = "white",
            alpha = 0.8
          ) +
          facet_wrap(input$var) +
          labs(title = paste0("Number of bins: ", input$bins)) +
          theme_minimal(30)
    })

    output$distTable <- renderReactable({
      mpg %>%
        group_by(!!sym(input$var)) %>%
        summarize(
          mean = mean(hwy),
          sd = sd(hwy),
          min = min(hwy),
          max = max(hwy)
        ) %>%
        mutate_if(is.numeric, round, 2) %>%
        reactable()
    })
}

# Run the application
shinyApp(ui = ui, server = server)
