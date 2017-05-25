#### API #####
getAllProjects <- function(){
  fromJSON("https://kkuf9fh5w3.execute-api.us-east-1.amazonaws.com/dev/list-projects")
}

getAllProjects_list <- function(projects_dt){
  projects_list <- as.list(projects_dt[['body']][['projects']][['PKProject']])
  names(projects_list) <- unlist(projects_dt[['body']][['projects']]['Name'],use.names = F) 
  
  projects_list
}

getExperimentGroup <- function(projectId){
  expGroup_dt <- fromJSON( paste0("https://kkuf9fh5w3.execute-api.us-east-1.amazonaws.com/dev/list-experiment-groups/project/",
                                  projectId))
  expGroup_dt[['body']][['experiment_groups']]
}

getExperimentGroup_list <- function(experimentGroup){
  experimentGroup_list <- as.list(experimentGroup[['PKExperimentGroup']])
  names(experimentGroup_list) <- unlist(experimentGroup['Description'],use.names = F)
  
  experimentGroup_list
}

getClassificationExperiments <- function(experimentGroupId){
  classificationExperiments_dt <- fromJSON(paste0("https://kkuf9fh5w3.execute-api.us-east-1.amazonaws.com/dev/list_classification_experiments/experiment_group/",experimentGroupId))
  classificationExperiments_dt[['body']][['classification_experiments']]
}

getClassificationExperimentsError <- function(classificationExperiments_dt){
  classificationExperiments_dt[,c('TrainAccuracyRate','ValidationAccuracyRate','TestAcurracyRate','TrainSize','RegularizationFactor','Complexity')]
}

getAccuracyRate <- function(classificationExperiments_dt){
  if(!is.null(classificationExperiments_dt)){
    return (range(classificationExperiments_dt[,c('TrainAccuracyRate','ValidationAccuracyRate','TestAcurracyRate')],na.rm=TRUE))    
  }
  range(0)
}

getClassificationExperiment_List <- function(classificationExperiments_dt){
  if ( !is.null(classificationExperiments_dt)){
    classificationExperiment_List <- classificationExperiments_dt[['PKClassificationExperiment']]
    
    architectureName <- unlist(classificationExperiments_dt['Architecture'],use.names = F)
    idClassExp <- unlist(classificationExperiments_dt['PKClassificationExperiment'],use.names = F)
    namesVec <- paste0(idClassExp,": ",architectureName)
    names(classificationExperiment_List) <- namesVec
    
    classificationExperiment_List
  }
}

getExperimentSteps <- function(experimentId){
  experimentSteps_dt <- fromJSON(paste0("https://kkuf9fh5w3.execute-api.us-east-1.amazonaws.com/dev/list_classification_experiments/steps/",
                                        experimentId,
                                        "/type/1"))
  experimentSteps_dt[['body']][['classification_steps']]
}


getExperimentsError <- function(experimentSteps_dt){
  if(length(experimentSteps_dt) > 0){
    experimentSteps_dt[,c('TrainAccuracyRate','ValidationAccuracyRate','TestAcurracyRate','step_number')]
  }  
}


#### OTHER #####
getRange <- function(x){
  if(!is.null(x)){
    return (range(x,na.rm=TRUE))    
  }
  range(0)
}
  