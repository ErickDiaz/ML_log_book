library(shiny)
library(curl)
library(jsonlite)
library(DT)

source("backendFunctions.R")

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
    tabsetPanel(
      tabPanel("Plot",
        wellPanel(
          fluidRow(
            column(width = 2,checkboxInput("showTrainingData","Training", T)),
            column(width = 2,checkboxInput("showvalidationData","Cross Validation", T)),
            column(width = 2,checkboxInput("showTestData","Test ", T))
          )
        ),
        wellPanel(
          fluidRow(
            column(width = 2,checkboxInput("gridLines","Grid Lines ", T))
          )
        ),  
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
      ),## end of Plot tab
      tabPanel("Tabular data",
               fluidRow(
                   column(width = 5,
                          div(DT::dataTableOutput("table_errorByTrainSize"), style = "font-size: 75%; width: 75%")
                   )
               ),   
               fluidRow(     
                 column(width = 5,
                        div(DT::dataTableOutput("table_errorByRegFactor"), style = "font-size: 75%; width: 75%")
                 )
               )
      )## end of Tablular data 
    )## end of tab panel
  )
  
)


