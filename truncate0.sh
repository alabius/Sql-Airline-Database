#!/bin/bash
# this script is to truncate the data in the tables at

#path to mysql database
/ usr / local / mysql / bin / mysql - u root kaitech_airline << EOF

# Set FOREIGN_KEY values to false
SET
  FOREIGN_KEY_CHECKS = 0;

#TRUNCATE the tables
TRUNCATE passenger;
TRUNCATE airlineClass;
TRUNCATE airline;
TRUNCATE country;
TRUNCATE ticket;

# Alter Ticket table for import;
ALTER TABLE
  ticket
drop
  TicketDate;

# Set FOREIGN_KEY values back to true
SET
  FOREIGN_KEY_CHECKS = 1;
EOF #exit script
exit
