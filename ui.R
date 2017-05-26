library(shiny)
library(jsonlite)

fluidPage(
  titlePanel("ML Log"),
  
  ### INPUTS ###
  sidebarPanel(
    selectInput(inputId = "projectSelect", label = "Project", choices = projects_list), 
    #textOutput("project_description"),
    verbatimTextOutput("project_description"),
    selectInput(inputId = "expGroupSelect", label = "Experiment Group", choices = "")
  ),
  ### OUTPUTS ###
  mainPanel(
    fluidRow(
      column(width = 5,
             plotOutput("lineChart_errorByTrainSize")
      ),
      column(width = 5,
             plotOutput("lineChart_errorByRegFactor")
      )
    ),
    fluidRow(
      plotOutput("lineChart_errorByModelComplex")
    ),
    fluidRow(
      selectInput(inputId = "expSelect", label = "Experiment", choices = "")
    ),
    fluidRow(
      column(width = 5,
             plotOutput("lineChart_errorByTrainStep")
      )
    )
  )
  
)
