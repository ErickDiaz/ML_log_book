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
      )  
    )

)


#################################
########## SERVER ###############
#################################
server <- function(input, output, session) {
  
  lineChart_height <- 300
  lineChart_width <- 400
  
  expGroup_list = reactive({
    expGroup <- getExperimentGroup(input$projectSelect)
    getExperimentGroup_list(expGroup)
  })
  
  #classificationExperimentsError_dt = reactive({
  #  classificationExperiments_dt <- getClassificationExperiments(input$expGroupSelect)
  #  getClassificationExperimentsError(classificationExperiments_dt)
  #})
  
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
  })
  
  ####### lineChart_errorByTrainSize ##########
  output$lineChart_errorByTrainSize <- renderPlot({  
    classificationExperiments_dt <- getClassificationExperiments(input$expGroupSelect)
    classificationExperimentsError_dt <- getClassificationExperimentsError(classificationExperiments_dt)
    
    trainSize <- classificationExperimentsError_dt[, 'TrainSize']
    yrange <- range(getAccuracyRate(classificationExperimentsError_dt))
    xrange <- range(trainSize,na.rm=TRUE)
    
    plot(xrange,yrange,type="n",xlab="By Training Size",ylab="Accuracy Rate",cex.lab=1.5)
    lines(trainSize,classificationExperimentsError_dt[, 'ValidationAccuracyRate'],col="green",lwd=3)
    lines(trainSize,classificationExperimentsError_dt[, 'TrainAccuracyRate'],col="blue",lwd=3)
    lines(trainSize,classificationExperimentsError_dt[, 'TestAcurracyRate'],col="red",lwd=3)
    
  },height = lineChart_height, width = lineChart_width)

  ####### lineChart_errorByRegFactor ##########
  output$lineChart_errorByRegFactor <- renderPlot({  
    classificationExperiments_dt <- getClassificationExperiments(input$expGroupSelect)
    classificationExperimentsError_dt <- getClassificationExperimentsError(classificationExperiments_dt)
    
    RegularizationFactor <- classificationExperimentsError_dt[, 'RegularizationFactor']
    yrange <- range(getAccuracyRate(classificationExperimentsError_dt))
    xrange <- range(RegularizationFactor,na.rm=TRUE)
    
    plot(xrange,yrange,type="n",xlab="By Regularization Factor",ylab="Accuracy Rate",cex.lab=1.5)
    lines(RegularizationFactor,classificationExperimentsError_dt[, 'ValidationAccuracyRate'],col="green",lwd=3)
    lines(RegularizationFactor,classificationExperimentsError_dt[, 'TrainAccuracyRate'],col="blue",lwd=3)
    lines(RegularizationFactor,classificationExperimentsError_dt[, 'TestAcurracyRate'],col="red",lwd=3)
    
  },height = lineChart_height, width = lineChart_width)
  
  ####### lineChart_errorByModelComplex ##########
  output$lineChart_errorByModelComplex <- renderPlot({  
    classificationExperiments_dt <- getClassificationExperiments(input$expGroupSelect)
    classificationExperimentsError_dt <- getClassificationExperimentsError(classificationExperiments_dt)
    
    modelComplexity <- classificationExperimentsError_dt[, 'Complexity']
    yrange <- range(getAccuracyRate(classificationExperimentsError_dt))
    xrange <- range(modelComplexity,na.rm=TRUE)
    
    plot(xrange,yrange,type="n",xlab="By Model Complexity",ylab="Accuracy Rate",cex.lab=1.5)
    lines(modelComplexity,classificationExperimentsError_dt[, 'ValidationAccuracyRate'],col="green",lwd=3)
    lines(modelComplexity,classificationExperimentsError_dt[, 'TrainAccuracyRate'],col="blue",lwd=3)
    lines(modelComplexity,classificationExperimentsError_dt[, 'TestAcurracyRate'],col="red",lwd=3)
    
  },height = lineChart_height, width = lineChart_width)

}

shinyApp(ui = ui, server = server)
}


