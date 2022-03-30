library(shiny)
library(ggplot2)

ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        ggplot(faithful, aes(waiting)) +
          geom_histogram(
            bins = input$bins,
            fill = "cornflowerblue",
            color = "white",
            alpha = 0.8
          ) +
          labs(title = paste0("Number of bins: ", input$bins)) +
          theme_minimal(30)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
