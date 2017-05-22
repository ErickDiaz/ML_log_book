getAllProjects <- function(){
  fromJSON("https://kkuf9fh5w3.execute-api.us-east-1.amazonaws.com/dev/list-projects")
}

getAllProjects_list <- function(projects_dt){
  projects_list <- as.list(projects_dt[['body']][['projects']][['PKProject']])
  names(projects_list) <- unlist(projects_dt[['body']][['projects']]['Name'],use.names = FALSE) 
  
  projects_list
}

getExperimentGroup <- function(projectId){
  expGroup_dt <- fromJSON( paste0("https://kkuf9fh5w3.execute-api.us-east-1.amazonaws.com/dev/list-experiment-groups/project/",
                                  projectId))
  expGroup_dt[['body']][['experiment_groups']]
}

getExperimentGroup_list <- function(experimentGroup){
  experimentGroup_list <- as.list(experimentGroup[['PKExperimentGroup']])
  names(experimentGroup_list) <- unlist(experimentGroup['Description'],use.names = FALSE)
  
  experimentGroup_list
}

getClassificationExperiments <- function(experimentGroupId){
  classificationExperiments_dt <- fromJSON(paste0("https://kkuf9fh5w3.execute-api.us-east-1.amazonaws.com/dev/list_classification_experiments/experiment_group/",experimentGroupId))
  classificationExperiments_dt[['body']][['classification_experiments']]
}

getClassificationExperimentsError <- function(classificationExperiments_dt){
  classificationExperiments_dt[,c('TrainAccuracyRate','ValidationAccuracyRate','TestAcurracyRate','TrainSize','RegularizationFactor')]
}

getAccuracyRate <- function(classificationExperiments_dt){
  range(d[,c('TrainAccuracyRate','ValidationAccuracyRate','TestAcurracyRate')])
}