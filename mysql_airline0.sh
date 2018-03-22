#!/bin/bash

# function to alter the ticket table
AlterticketData (){
  /usr/local/mysql/bin/mysql -u root kaitech_airline<< EOF
  ALTER TABLE ticket ADD my_text_dates VARCHAR(10) AFTER PassengerID;
EOF
}
importData (){
  /usr/local/mysql/bin/mysql -u root kaitech_airline<< EOF
  LOAD DATA LOCAL INFILE '$csvDirectory/$csvFile'
  INTO TABLE $tableName
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 ROWS;
EOF
  echo "Data successfully imported"
};
# function to alter the ticket table
FormateTicketTable(){
  /usr/local/mysql/bin/mysql -u root kaitech_airline<< EOF
  ALTER TABLE ticket ADD TicketDate DATE;
  UPDATE ticket SET TicketDate = STR_TO_DATE(my_text_dates, '%m/%d/%Y');
  ALTER TABLE ticket drop column my_text_dates;
EOF
}

AlterticketData
# define directory containing CSV files
csvDirectory="/Users/sunday.alabi/SqlProject"

# go into directory
cd $csvDirectory

# get a list of CSV files in directory
csvFiles=`ls -1 *.csv`
echo $csvFiles


# loop through csv files
for csvFile in ${csvFiles[@]}
do
  # remove file extension for the csv files to use as file name
  csvFile_extensionless=`echo $csvFile | sed 's/\(.*\)\..*/\1/'`

  # define table name from the removed file extension
  tableName="${csvFile_extensionless}"

  # get header columns from CSV file
  headerColumns=`head -1 $csvDirectory/$csvFile | tr ',' '\n' | sed 's/^"//' | sed 's/"$//' | sed 's/ /_/g'`
  headerColumns_string=`head -1 $csvDirectory/$csvFile | sed 's/ /_/g' | sed 's/"//g'`

  # Import CSV File
  importData
done

# Formate date column in Ticket table
FormateTicketTable
exit
