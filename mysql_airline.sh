#!/bin/bash

# function to import the csv files into the tables
importData (){
  /usr/local/mysql/bin/mysql -u root test<< EOF
  LOAD DATA LOCAL INFILE '$csvDirectory/$csvFile'
  INTO TABLE $tableName
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 ROWS;
EOF
  echo "Data successfully imported"
};

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

  # Get user permission to import into the selected table.
  read -r -p "Are you sure you want to import data to $tableName [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
  then
    importData
  else
      echo "Request declined"
  fi
done
exit
