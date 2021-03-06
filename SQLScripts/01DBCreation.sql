-- MySQL Script generated by MySQL Workbench
-- lun 16 ene 2017 21:57:14 CST
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema ML_log_book
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ML_log_book` ;

-- -----------------------------------------------------
-- Schema ML_log_book
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ML_log_book` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `ML_log_book` ;

-- -----------------------------------------------------
-- Table `ML_log_book`.`Project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`Project` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`Project` (
  `PKProject` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Description` VARCHAR(100) NOT NULL,
  `ContentDirectory` VARCHAR(256) NULL COMMENT 'If the project files(source data,scripts,notebooks) are stored in a directory(local or central repo).',
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  PRIMARY KEY (`PKProject`))
ENGINE = InnoDB
COMMENT = 'A table to store information about the project to wich a group of experiments belong to.';


-- -----------------------------------------------------
-- Table `ML_log_book`.`Algorithm`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`Algorithm` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`Algorithm` (
  `PKAlgorithm` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  PRIMARY KEY (`PKAlgorithm`))
ENGINE = InnoDB
COMMENT = 'Catalogue of different algorithms to use in experiments. Examples: logistic regression,support vector machine, neural network, convolutional neural network';


-- -----------------------------------------------------
-- Table `ML_log_book`.`Tool`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`Tool` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`Tool` (
  `PKTool` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `SiteURL` VARCHAR(45) NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  PRIMARY KEY (`PKTool`))
ENGINE = InnoDB
COMMENT = 'Table to store a catalogue of tools.Examples: Tensorflow, Spark, Scikit-Learn';


-- -----------------------------------------------------
-- Table `ML_log_book`.`ToolFramework`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`ToolFramework` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`ToolFramework` (
  `PKToolFramework` INT NOT NULL AUTO_INCREMENT,
  `FKTool` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  PRIMARY KEY (`PKToolFramework`),
  INDEX `fk_ToolFramework_Tool1_idx` (`FKTool` ASC),
  CONSTRAINT `fk_ToolFramework_Tool1`
    FOREIGN KEY (`FKTool`)
    REFERENCES `ML_log_book`.`Tool` (`PKTool`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'A catalogue of libraries or frameworks for the tools , for example: skflow, sklearn , sparkling water.';


-- -----------------------------------------------------
-- Table `ML_log_book`.`ExperimentGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`ExperimentGroup` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`ExperimentGroup` (
  `PKExperimentGroup` INT NOT NULL AUTO_INCREMENT,
  `FKAlgorithm` INT NOT NULL,
  `FKToolFramework` INT NOT NULL,
  `FKProject` INT NOT NULL,
  `Description` VARCHAR(100) NULL,
  `ExecutionHost` VARCHAR(45) NULL,
  `ContentDirectory` VARCHAR(256) NULL COMMENT 'Subdirectory of projet directory to store experiments in a hierarchical way',
  `StartTime` DATETIME NOT NULL,
  `EndTime` DATETIME NULL,
  `Comments` VARCHAR(100) NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  PRIMARY KEY (`PKExperimentGroup`),
  INDEX `fk_ExperimentGroup_Algorithm1_idx` (`FKAlgorithm` ASC),
  INDEX `fk_ExperimentGroup_ToolFramework1_idx` (`FKToolFramework` ASC),
  INDEX `fk_ExperimentGroup_Project1_idx` (`FKProject` ASC),
  CONSTRAINT `fk_ExperimentGroup_Algorithm1`
    FOREIGN KEY (`FKAlgorithm`)
    REFERENCES `ML_log_book`.`Algorithm` (`PKAlgorithm`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ExperimentGroup_ToolFramework1`
    FOREIGN KEY (`FKToolFramework`)
    REFERENCES `ML_log_book`.`ToolFramework` (`PKToolFramework`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ExperimentGroup_Project1`
    FOREIGN KEY (`FKProject`)
    REFERENCES `ML_log_book`.`Project` (`PKProject`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table to store the header of experiment groups. Experiment group examples can be:\n\n- Execute a learning algorithm with different training sizes and then plot learning curves for the group of experiments. Every training size would be a experiment.\n- Execute a learning algorithm variyng polinomial complexity and then select the best polinomial degree. Every degree would be a experiment';


-- -----------------------------------------------------
-- Table `ML_log_book`.`ClassificationExperiment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`ClassificationExperiment` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`ClassificationExperiment` (
  `PKClassificationExperiment` INT NOT NULL AUTO_INCREMENT,
  `FKExperimentGroup` INT NOT NULL,
  `StartTime` DATETIME NOT NULL,
  `EndTime` DATETIME NULL,
  `Architecture` VARCHAR(150) NOT NULL,
  `TrainSize` INT NOT NULL,
  `ValidationSize` INT NULL,
  `TestSize` INT NULL,
  `TrainingSteps` INT NULL,
  `TrainingEpochs` INT NULL,
  `Complexity` DOUBLE NULL,
  `RegularizationFactor` DOUBLE NOT NULL DEFAULT 0.0 COMMENT 'Special hyper parameter(do diagnose bias variance in curves)',
  `ExperimentDirectory` VARCHAR(256) NULL COMMENT 'Subdirectory of group directory to store experiments in a hierarchical way',
  `TrainCostErrorLoss` DOUBLE NULL DEFAULT NULL,
  `TrainAccuracyRate` DOUBLE NULL DEFAULT NULL,
  `TrainMisclassificationRate` DOUBLE NULL DEFAULT NULL,
  `TrainRightPredictions` INT NULL DEFAULT NULL,
  `TrainWrongPredictions` INT NULL DEFAULT NULL,
  `TrainTruePositives` INT NULL DEFAULT NULL,
  `TrainFalsePositives` INT NULL DEFAULT NULL,
  `TrainTrueNegatives` INT NULL DEFAULT NULL,
  `TrainFalseNegatives` INT NULL DEFAULT NULL,
  `TrainPrecission` DOUBLE NULL DEFAULT NULL,
  `TrainRecall` DOUBLE NULL DEFAULT NULL,
  `TrainF1Score` DOUBLE NULL DEFAULT NULL,
  `ValidationCostErrorLoss` DOUBLE NULL DEFAULT NULL,
  `ValidationAccuracyRate` DOUBLE NULL DEFAULT NULL,
  `ValidationMisclassificationRate` DOUBLE NULL DEFAULT NULL,
  `ValidationRightPredictions` INT NULL DEFAULT NULL,
  `ValidationWrongPredictions` INT NULL DEFAULT NULL,
  `ValidationTruePositives` INT NULL DEFAULT NULL,
  `ValidationFalsePositives` INT NULL DEFAULT NULL,
  `ValidationTrueNegatives` INT NULL DEFAULT NULL,
  `ValidationFalseNegatives` INT NULL DEFAULT NULL,
  `ValidationPrecision` DOUBLE NULL DEFAULT NULL,
  `ValidationRecall` DOUBLE NULL DEFAULT NULL,
  `ValidationF1Score` DOUBLE NULL DEFAULT NULL,
  `TestCostErrorLoss` DOUBLE NULL DEFAULT NULL,
  `TestAcurracyRate` DOUBLE NULL DEFAULT NULL,
  `TestMisclassificationRate` DOUBLE NULL DEFAULT NULL,
  `TestRightPredictions` INT NULL DEFAULT NULL,
  `TestWrongPredictions` INT NULL DEFAULT NULL,
  `TestTruePositives` INT NULL DEFAULT NULL,
  `TestFalsePositives` INT NULL DEFAULT NULL,
  `TestTrueNegatives` INT NULL DEFAULT NULL,
  `TestFalseNegatives` INT NULL DEFAULT NULL,
  `TestPrecision` DOUBLE NULL DEFAULT NULL,
  `TestRecall` DOUBLE NULL DEFAULT NULL,
  `TestF1Score` DOUBLE NULL DEFAULT NULL,
  `FinalComments` VARCHAR(500) NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  INDEX `fk_BinaryClassificationExperiment_ExperimentGroup1_idx` (`FKExperimentGroup` ASC),
  PRIMARY KEY (`PKClassificationExperiment`),
  CONSTRAINT `fk_BinaryClassificationExperiment_ExperimentGroup1`
    FOREIGN KEY (`FKExperimentGroup`)
    REFERENCES `ML_log_book`.`ExperimentGroup` (`PKExperimentGroup`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'A binary classification experiment belonging to a group of experiments(some groups would have only a experiment if there no need to compra results).\nThis table captures common ML  performance metrics for binary classification. Experiment start and end times, directory where the experiment files are, ec.';


-- -----------------------------------------------------
-- Table `ML_log_book`.`HyperParameter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`HyperParameter` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`HyperParameter` (
  `PKHyperParameter` INT NOT NULL AUTO_INCREMENT,
  `FKClassificationExperiment` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Value` VARCHAR(45) NOT NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  PRIMARY KEY (`PKHyperParameter`),
  INDEX `fk_HyperParameter_ClassificationExperiment1_idx` (`FKClassificationExperiment` ASC),
  CONSTRAINT `fk_HyperParameter_ClassificationExperiment1`
    FOREIGN KEY (`FKClassificationExperiment`)
    REFERENCES `ML_log_book`.`ClassificationExperiment` (`PKClassificationExperiment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table to store any hyper parameter used in the experiment';


-- -----------------------------------------------------
-- Table `ML_log_book`.`ExperimentStepType`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`ExperimentStepType` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`ExperimentStepType` (
  `PKExperimentType` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  PRIMARY KEY (`PKExperimentType`))
ENGINE = InnoDB
COMMENT = 'A catalog of experiment step types. Examples: step or epoch(for neural networks)';


-- -----------------------------------------------------
-- Table `ML_log_book`.`ClassificationStep`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`ClassificationStep` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`ClassificationStep` (
  `FKBinaryClassificationExperiment` INT NOT NULL,
  `EstepNumber` INT NOT NULL,
  `FKExperimentType` INT NOT NULL,
  `StartTime` DATETIME NULL,
  `EndTime` DATETIME NULL,
  `TrainCostErrorLoss` DOUBLE NULL DEFAULT NULL,
  `TrainAccuracyRate` DOUBLE NULL DEFAULT NULL,
  `TrainMisclassificationRate` DOUBLE NULL DEFAULT NULL,
  `TrainRightPredictions` INT NULL DEFAULT NULL,
  `TrainWrongPredictions` INT NULL DEFAULT NULL,
  `TrainTruePositives` INT NULL DEFAULT NULL,
  `TrainFalsePositives` INT NULL DEFAULT NULL,
  `TrainTrueNegatives` INT NULL DEFAULT NULL,
  `TrainFalseNegatives` INT NULL DEFAULT NULL,
  `TrainPrecission` DOUBLE NULL DEFAULT NULL,
  `TrainRecall` DOUBLE NULL DEFAULT NULL,
  `TrainF1Score` DOUBLE NULL DEFAULT NULL,
  `ValidationCostErrorLoss` DOUBLE NULL DEFAULT NULL,
  `ValidationAccuracyRate` DOUBLE NULL DEFAULT NULL,
  `ValidationMisclassificationRate` DOUBLE NULL DEFAULT NULL,
  `ValidationRightPredictions` INT NULL DEFAULT NULL,
  `ValidationWrongPredictions` INT NULL DEFAULT NULL,
  `ValidationTruePositives` INT NULL DEFAULT NULL,
  `ValidationFalsePositives` INT NULL DEFAULT NULL,
  `ValidationTrueNegatives` INT NULL DEFAULT NULL,
  `ValidationFalseNegatives` INT NULL DEFAULT NULL,
  `ValidationPrecision` DOUBLE NULL DEFAULT NULL,
  `ValidationRecall` DOUBLE NULL DEFAULT NULL,
  `ValidationF1Score` DOUBLE NULL DEFAULT NULL,
  `TestCostErrorLoss` DOUBLE NULL DEFAULT NULL,
  `TestAcurracyRate` DOUBLE NULL DEFAULT NULL,
  `TestMisclassificationRate` DOUBLE NULL DEFAULT NULL,
  `TestRightPredictions` INT NULL DEFAULT NULL,
  `TestWrongPredictions` INT NULL DEFAULT NULL,
  `TestTruePositives` INT NULL DEFAULT NULL,
  `TestFalsePositives` INT NULL DEFAULT NULL,
  `TestTrueNegatives` INT NULL DEFAULT NULL,
  `TestFalseNegatives` INT NULL DEFAULT NULL,
  `TestPrecision` DOUBLE NULL DEFAULT NULL,
  `TestRecall` DOUBLE NULL DEFAULT NULL,
  `TestF1Score` DOUBLE NULL DEFAULT NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  INDEX `fk_ExperimentStep_BinaryClassificationExperiment1_idx` (`FKBinaryClassificationExperiment` ASC),
  PRIMARY KEY (`FKBinaryClassificationExperiment`, `EstepNumber`),
  INDEX `fk_BinaryClassificationStep_ExperimentStepType1_idx` (`FKExperimentType` ASC),
  CONSTRAINT `fk_ExperimentStep_BinaryClassificationExperiment1`
    FOREIGN KEY (`FKBinaryClassificationExperiment`)
    REFERENCES `ML_log_book`.`ClassificationExperiment` (`PKClassificationExperiment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BinaryClassificationStep_ExperimentStepType1`
    FOREIGN KEY (`FKExperimentType`)
    REFERENCES `ML_log_book`.`ExperimentStepType` (`PKExperimentType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'This table stores performance metrics at step or epoch level(instead of having to wait for the experiment to finish) and can be used or not if the experiment needs it.';


-- -----------------------------------------------------
-- Table `ML_log_book`.`Feature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ML_log_book`.`Feature` ;

CREATE TABLE IF NOT EXISTS `ML_log_book`.`Feature` (
  `PKFeature` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Type` VARCHAR(45) NULL,
  `FKBinaryClassificationExperiment` INT NOT NULL,
  `CreateTime` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `LastModificationTime` TIMESTAMP NULL,
  `CreatedBy` VARCHAR(45) NULL,
  `LastModifiedBY` VARCHAR(45) NULL,
  PRIMARY KEY (`PKFeature`),
  INDEX `fk_Feature_BinaryClassificationExperiment1_idx` (`FKBinaryClassificationExperiment` ASC),
  CONSTRAINT `fk_Feature_BinaryClassificationExperiment1`
    FOREIGN KEY (`FKBinaryClassificationExperiment`)
    REFERENCES `ML_log_book`.`ClassificationExperiment` (`PKClassificationExperiment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Table  to store the features used in a experiment.';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
