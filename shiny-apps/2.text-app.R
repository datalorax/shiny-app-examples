library(shiny)

ui <- fluidPage(

    # Application title
    titlePanel("Echo text"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show output
        mainPanel(
           textOutput("txt")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$txt <- renderText({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        print(input$bins)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
