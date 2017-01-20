
Python script for insert, update values into the ML_Log database


#### Dependencies
[PyMySQL](https://github.com/PyMySQL/PyMySQL)

`> pip install PyMySQL`

#### Usage
```python
db = MySQLConnector('mypass', 'my_database', 'utf8', host='127.0.1', user='root')
db.initConnection()
try:
    ###  Insert values ###
    id = db.insertData("ML_log_book.ClassificationExperiment",
                  FKExperimentGroup=1,
                  EstartTime="2017-01-17 22:13:00",
                  EndTime="2017-01-17 22:14:00",
                  Architecture="test",
                  TrainSize=90)
                  
    # Print returned id
    print(id)

    ####  Update values ####
    # Make a dictionary for the values to update
    setVaules = {"FKExperimentGroup":2,
                  "EstartTime":"2017-01-17 22:13:00",
                  "EndTime":"2017-01-17 22:14:00",
                  "Architecture":"test",
                  "TrainSize":90}
    # Make a dictionary for the values en the were
    whereConditions = {"PKClassificationExperiment":id}
    # run the update: db.updateData("<table name>", <Dic. set values>,<Dic. where values>)
    db.updateData("ML_log_book.ClassificationExperiment",setVaules,whereConditions)
finally:
    db.closeConnection();
```