# The order_details.csv is quite large and takes a considerable amount of time to load in.
# The LOAD DATA INFILE will help load the table through the following steps.

#Create a table called order_details with same column name with the columns in order_details.csv, 
# and set the data types to character and later it would be converted to it's respective datatypes.
CREATE TABLE order_details (
	order_details_id varchar(255),
    order_id varchar(255),
    pizza_id varchar(255),
    quantity varchar(255)
);

#Set the following variables to give permission for LOAD DATA INFILE.
SET GLOBAL local_infile = 'ON';
GRANT ALL ON TEST.* TO 'root'@'localhost';

# Before loading the file, MYSQL requires that the file be placed in a particular location in your local machine inorder 
# For it to locate the file. 

#inorder to get this location, use the output of this...
SHOW VARIABLES LIKE "secure_file_priv";

#Put the order_details.csv into the location specified by the above 

#Next, use the LOAD DATA INFILE to load the data into the newly created table
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_details.csv" INTO TABLE order_details 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

# After successful load, the first row of the table contains the original column header of order_details.csv
#It needs to be deleted before we change the datatypes of the columns.

DELETE FROM order_details
LIMIT 1;

#change the data types of the columns to the proper ones
ALTER TABLE order_details
MODIFY order_details_id INT PRIMARY KEY;

ALTER TABLE order_details
MODIFY order_id INT;

ALTER TABLE order_details
MODIFY quantity INT;



#The orders.csv also has alot of rows and i will use the LOAD DATA to load it using the same procedure 

CREATE TABLE orders (
	order_id varchar(277),
    date varchar(277),
    time varchar(277)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv" INTO TABLE orders 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

DELETE FROM orders
LIMIT 1;

ALTER TABLE orders
MODIFY order_id INT PRIMARY KEY;

ALTER TABLE orders
MODIFY date DATE;

ALTER TABLE orders
MODIFY time time;

#The other tables can be loaded using the TABLE DATA IMPORT WIZARD

# New column creations
#I'll be creating new columns such as month and hour for time analysis

ALTER TABLE orders
ADD COLUMN hour int;

ALTER TABLE orders
ADD COLUMN month varchar(255);

ALTER TABLE orders
ADD COLUMN WEEKDAY varchar(255);

# Update the newly created columns with their set values
SET SQL_SAFE_UPDATES = 0;

UPDATE orders
SET month = monthname(date);

UPDATE orders
SET hour = hour(time);

UPDATE orders
SET WEEKDAY = (Select 
					CASE WHEN WEEKDAY(orders.date) in (0, 1, 2, 3, 4, 5) THEN 'Weekday'
						 WHEN WEEKDAY(orders.date) in (6, 7) THEN 'Weekend'
						 ELSE NULL
                     END
			);
