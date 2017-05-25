### Load libraries
library(shiny)
library(jsonlite)


source("backendFunctions.R")

#### INITIAL VALUES ####
## Load Poject Data
projects_dt <- getAllProjects()
projects_list <- getAllProjects_list(projects_dt)



if (interactive()) {
#################################
########## UI ###################
#################################
ui <- fluidPage(
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


#################################
########## SERVER ###############
#################################
server <- function(input, output, session) {
  
  lineChart_height <- 300
  lineChart_width <- 400
  
  expGroup_list <- reactive({
    expGroup <- getExperimentGroup(input$projectSelect)
    getExperimentGroup_list(expGroup)
  })
  
  classificationExperiments_dt <- reactive({
    getClassificationExperiments(input$expGroupSelect)
  })
  
  experimentSteps_dt <- reactive({
    getExperimentSteps(input$expSelect)
  })
  
  
  observe({
      pkproject <- input$projectSelect
      
      # Can use character(0) to remove all choices
      if (is.null(pkproject)){
          output$text1 <- renderText({ 
            "ERROR You have to select a project"
          })
      }else{
           output$project_description <- renderText({ 
             project_index = which(projects_list == pkproject, useNames = F)
             description = projects_dt[['body']][['projects']][['Description']][project_index]
             name = projects_dt[['body']][['projects']][['Name']][project_index]
             
             paste0(name,": ",description,"   --->",pkproject)
          })
           
           updateSelectInput(session, "expGroupSelect",
                             choices = expGroup_list()) 
           
      }  
  }, priority = 5)
 
  observe({ 
        ####### lineChart_errorByTrainSize ##########
        output$lineChart_errorByTrainSize <- renderPlot({  
          errorData <- getClassificationExperimentsError(classificationExperiments_dt())
          
          trainSize <- errorData[, 'TrainSize']
          yrange <- range(getAccuracyRate(errorData))
          xrange <- range(trainSize,na.rm=TRUE)
          
          plot(xrange,yrange,type="n",xlab="By Training Size",ylab="Accuracy Rate",cex.lab=1.5)
          lines(trainSize,errorData[, 'ValidationAccuracyRate'],col="green",lwd=3)
          lines(trainSize,errorData[, 'TrainAccuracyRate'],col="blue",lwd=3)
          lines(trainSize,errorData[, 'TestAcurracyRate'],col="red",lwd=3)
          
        },height = lineChart_height, width = lineChart_width)
      
        ####### lineChart_errorByRegFactor ##########
        output$lineChart_errorByRegFactor <- renderPlot({  
          errorData <- getClassificationExperimentsError(classificationExperiments_dt())
          
          RegularizationFactor <- errorData[, 'RegularizationFactor']
          yrange <- range(getAccuracyRate(errorData))
          xrange <- range(RegularizationFactor,na.rm=TRUE)
          
          plot(xrange,yrange,type="n",xlab="By Regularization Factor",ylab="Accuracy Rate",cex.lab=1.5)
          lines(RegularizationFactor,errorData[, 'ValidationAccuracyRate'],col="green",lwd=3)
          lines(RegularizationFactor,errorData[, 'TrainAccuracyRate'],col="blue",lwd=3)
          lines(RegularizationFactor,errorData[, 'TestAcurracyRate'],col="red",lwd=3)
          
        },height = lineChart_height, width = lineChart_width)
        
        ####### lineChart_errorByModelComplex ##########
        output$lineChart_errorByModelComplex <- renderPlot({  
          errorData <- getClassificationExperimentsError(classificationExperiments_dt())
          
          modelComplexity <- errorData[, 'Complexity']
          yrange <- range(getAccuracyRate(errorData))
          xrange <- range(modelComplexity,na.rm=TRUE)
          
          plot(xrange,yrange,type="n",xlab="By Model Complexity",ylab="Accuracy Rate",cex.lab=1.5)
          lines(modelComplexity,errorData[, 'ValidationAccuracyRate'],col="green",lwd=3)
          lines(modelComplexity,errorData[, 'TrainAccuracyRate'],col="blue",lwd=3)
          lines(modelComplexity,errorData[, 'TestAcurracyRate'],col="red",lwd=3)
          
        },height = lineChart_height, width = lineChart_width)
  },priority = 4)
  
  observe({ 
    exp_list <- getClassificationExperiment_List(classificationExperiments_dt())
    updateSelectInput(session, "expSelect",choices = exp_list) 
  },priority = 3)
  
  observe({ 
    ####### lineChart_errorByTrainingStep ##########
    output$lineChart_errorByTrainStep <- renderPlot({  
      errorData <- getExperimentsError(experimentSteps_dt())
      
      trainSize <- errorData[, 'step_number']
      yrange <- range(getAccuracyRate(errorData))
      xrange <- range(trainSize,na.rm=TRUE)
      
      plot(xrange,yrange,type="n",xlab="By Training Step Size",ylab="Accuracy Rate",cex.lab=1.5)
      lines(trainSize,errorData[, 'ValidationAccuracyRate'],col="green",lwd=3)
      lines(trainSize,errorData[, 'TrainAccuracyRate'],col="blue",lwd=3)
      lines(trainSize,errorData[, 'TestAcurracyRate'],col="red",lwd=3)
      
    },height = lineChart_height, width = lineChart_width)
    
  },priority = 1)
  
}

shinyApp(ui = ui, server = server)
}


