library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(reactable)
d <- forcats::gss_cat

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Plot", tabName = "plot", icon = icon("chart-bar")),
      menuItem("Table", tabName = "tbl", icon = icon("table")),
      radioButtons(
        "var",
        "Variable:",
        choices = names(select_if(d, is.factor)),
        selected = "marital"
      )
    )
  ),
  dashboardBody(
    fluidRow(
      tabItems(
        tabItem(
          "plot",
          box(
            title = "Distributions",
            plotOutput("boxplots", height = 900)
          ),
          box(
            title = "Counts",
            plotOutput("counts", height = 410)
          ),
          box(
            title = "Proportions",
            plotOutput("props", height = 410)
          )
        ),
        tabItem(
          "tbl",
          box(reactableOutput("reactbl", height = 500))
        )
      )
    )
  )
)

server <- function(input, output) {
  output$boxplots <- renderPlot({
    ggplot(d, aes(tvhours, !!sym(input$var))) +
      geom_boxplot(
        aes(fill = !!sym(input$var)),
        color = "gray"
      ) +
      scico::scale_fill_scico_d() +
      guides(fill = "none") +
      theme_minimal(30) +
      labs(x = "TV Hours Watched",
           y = "")
  })

  output$counts <- renderPlot({
    p <- d %>%
      count(!!sym(input$var)) %>%
      ggplot(aes(n, !!sym(input$var))) +
        geom_col(fill = "cornflowerblue") +
        scale_x_continuous("Counts", expand = c(0, 0)) +
        theme_minimal(30) +
        labs(y = "")

    if (input$var == "denom") {
      p <- p +
        theme(axis.text.y = element_text(size = 10))
    }
    p
  })

  output$props <- renderPlot({
    p <- d %>%
      count(!!sym(input$var)) %>%
      mutate(Proportion = n/sum(n)) %>%
      ggplot(aes(Proportion, !!sym(input$var))) +
      geom_col(fill = "#A111DA") +
      scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
      labs(y = "") +
      theme_minimal(30)

    if (input$var == "denom") {
      p <- p +
        theme(axis.text.y = element_text(size = 10))
    }
    p
  })

  output$reactbl <- renderReactable({
    d %>%
      group_by(!!sym(input$var)) %>%
      summarize(
        n = n(),
        mean = mean(tvhours, na.rm = TRUE),
        sd = sd(tvhours, na.rm = TRUE),
        min = min(tvhours, na.rm = TRUE),
        max = max(tvhours, na.rm = TRUE)
      ) %>%
      mutate_if(is.numeric, round, 2) %>%
      reactable()
  })
}

shinyApp(ui, server)
