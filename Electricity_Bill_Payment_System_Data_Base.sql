drop database if exists Electricity_Bill_Payment_Data_Base_System;
CREATE DATABASE if not exists  Electricity_Bill_Payment_Data_Base_System;
USE Electricity_Bill_Payment_Data_Base_System;

-- Cretae All Table
CREATE TABLE CUSTOMER (
    Cus_ID VARCHAR(10) NOT NULL,
    Account_Number VARCHAR(20) NOT NULL,
    Full_Name VARCHAR(100) NOT NULL,
    Branch_ID varchar(10),
    Empl_ID varchar(10),
    Lane_No VARCHAR(5),
    Streat VARCHAR(20),
    Twon VARCHAR(20),
    PRIMARY KEY (Cus_ID)
    
);

CREATE TABLE CUSTOMER_CONTACT (
    Cus_ID VARCHAR(10),
    Contact_Number INT,
    PRIMARY KEY (Cus_ID,Contact_Number),
    FOREIGN KEY (Cus_ID) REFERENCES CUSTOMER(Cus_ID)
    on update cascade on delete cascade
   
);
CREATE TABLE CUSTOMER_METER (
    Cus_ID VARCHAR(10),
    Meter_ID varchar (10),
    PRIMARY KEY (Cus_ID,Meter_ID),
    FOREIGN KEY (Cus_ID) REFERENCES CUSTOMER(Cus_ID)
    on update cascade on delete cascade
   
);

CREATE TABLE CUSTOMER_CONNECTION (
    Cus_ID VARCHAR(10),
    CONNECTION_ID varchar (10),
    PRIMARY KEY (Cus_ID,CONNECTION_ID),
    FOREIGN KEY (Cus_ID) REFERENCES CUSTOMER(Cus_ID)
    on update cascade on delete cascade
   
);

CREATE TABLE PAYMENT_Det_01 (
    Cus_ID VARCHAR(10) NOT NULL,
    Meter_ID VARCHAR(20) NOT NULL,
    Branch_ID varchar(10) NOT NULL,
    Amount INT NOT NULL,
    Payment_Date INT,
    Payment_Month INT,
    Payment_Year INT,
    Bill_ID VARCHAR(20),
    Method VARCHAR(20) NOT NULL,
    PRIMARY KEY (Meter_ID,Cus_ID,Branch_ID),
    FOREIGN KEY (Cus_ID) REFERENCES CUSTOMER(Cus_ID) 
    on update cascade on delete cascade
);

CREATE TABLE PAYMENT_Det_02 (
    
    Branch_ID varchar(10),
    Branch_Name varchar (50),
    PRIMARY KEY (Branch_ID)
);

CREATE TABLE METER (
    Meter_ID VARCHAR(10) NOT NULL,
    Cus_ID varchar (10),
    Meter_Type VARCHAR(20),
    Installation_Date DATE,
    PRIMARY KEY (Meter_ID,Cus_ID)
);

CREATE TABLE Branch (
    Branch_ID VARCHAR(10) NOT NULL,
    Branch_Name VARCHAR(100) NOT NULL,
    Postal_Name VARCHAR(100),
    Lane_No VARCHAR(20),
    Streat VARCHAR(20),
    Twon VARCHAR(20),
    PRIMARY KEY (Branch_ID)
);

CREATE TABLE EMPLOYEE (
    Empl_ID VARCHAR(10) NOT NULL,
    Supervice_ID varchar(10),
    Branch_ID varchar(10),
    Empl_Name VARCHAR(50),
    Designation VARCHAR(50),
    PRIMARY KEY (Empl_ID),
    foreign key (Branch_ID) references branch (Branch_ID)
    on update cascade on delete cascade
);

CREATE INDEX idx_supervice_id ON EMPLOYEE (Supervice_ID);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk_Rc
FOREIGN KEY (Supervice_ID) REFERENCES EMPLOYEE (Empl_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

CREATE TABLE MeterReader (
    Empl_ID VARCHAR(10) NOT NULL,
    Reader_ID varchar(10),
    Reader_Name VARCHAR(50),
    Area VARCHAR(50),
    PRIMARY KEY (Empl_ID)
);

CREATE INDEX idx_reader_id ON MeterReader (Reader_ID);
ALTER TABLE MeterReader
ADD CONSTRAINT fk_Mr
FOREIGN KEY (Reader_ID) REFERENCES MeterReader (Empl_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;
CREATE TABLE BILL (
    Bill_ID VARCHAR(20) NOT NULL,
    Cus_ID varchar(10),
    Reader_Id varchar(10),
    Amount INT,
    Reading_Date DATE,
    Consumption_Unit INT,
    Current_Reading int,
    Unit_Price int,
    Previous_Reading_Unit INT,
    Previous_Reading_Date DATE,
    PRIMARY KEY (Bill_ID),
    foreign key (Reader_ID) references MeterReader(Empl_ID)
    on delete cascade on update cascade
);

CREATE TABLE Complain (
    Complain_ID VARCHAR(10) NOT NULL,
    Cus_ID VARCHAR(10),
    Description_Com VARCHAR(200),
    Status_Com VARCHAR(50),
    PRIMARY KEY (Cus_ID, Complain_ID),
    FOREIGN KEY (Cus_ID) REFERENCES CUSTOMER(Cus_ID) 
    on update cascade on delete cascade
);

CREATE TABLE Feedback (
    Feedback_No INT NOT NULL,
    Customer_ID VARCHAR(10) NOT NULL,
    Rating INT,
    Comments TEXT,
    Timestamp DATETIME,
    Resolved BOOLEAN,
    Response TEXT,
    PRIMARY KEY (Customer_ID, Feedback_No),
    FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Cus_ID)on update cascade on delete cascade
);

CREATE INDEX idx_meter_cus_id ON meter (cus_ID);
CREATE TABLE Connection_Elec (
    Connection_ID VARCHAR(10) NOT NULL,
    Connection_Type VARCHAR(30) NOT NULL,
    Capacity VARCHAR(30) NOT NULL,
    Time_Period VARCHAR(30) NOT NULL,
    Cus_ID VARCHAR(10) NOT NULL,
    PRIMARY KEY (Connection_ID),
    FOREIGN KEY (Cus_ID) REFERENCES CUSTOMER(Cus_ID),
    FOREIGN KEY (Cus_ID) REFERENCES meter(cus_ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Meter_Maintenance (
    Connection_ID VARCHAR(10) NOT NULL,
	Owner_Name varchar(50),
    Maintain_Date DATE,
    Connection_type varchar(10),
    Description_Main VARCHAR(50),
    PRIMARY KEY (Connection_ID),
    FOREIGN KEY (Connection_ID) REFERENCES Connection_Elec(Connection_ID)
     on update cascade on delete cascade
);


-- add Forigien key constrain
alter table meter
add constraint Fk_Cus
foreign key(Cus_ID) references customer(Cus_ID)
on update cascade on delete cascade;

alter table PAYMENT_Det_01
add constraint Fk_Mtr
foreign key(Meter_ID) references Meter(Meter_ID)
on update cascade on delete cascade;

alter table meterreader  
add constraint Fk_Em
foreign key(Empl_ID) references employee(Empl_ID)
on update cascade on delete cascade;

alter table customer
add constraint Fk_Br
foreign key(Branch_ID) references branch(Branch_ID)
on update cascade on delete cascade;

alter table customer
add constraint Fk_Emp
foreign key(Empl_ID) references meterreader(Empl_ID)
on update cascade on delete cascade;

alter table bill
add constraint Fk_bill
foreign key(Cus_ID) references customer(Cus_ID)
on update cascade on delete cascade;

alter table payment_det_02
add constraint Fk_Branch
foreign key(Branch_ID) references branch(Branch_ID)
on update cascade on delete cascade;

ALTER TABLE MeterReader
ADD CONSTRAINT fk_MRB FOREIGN KEY (Area) REFERENCES Branch (Branch_ID)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Enter Data To all table
INSERT INTO Branch (Branch_ID, Branch_Name, Postal_Name, Lane_No, Streat, Twon)
VALUES
    ('Branch001', 'Main Branch', 'Main St. Branch', 'A', 'Main Street', 'Colombo'),
    ('Branch002', 'City Center Branch', 'City Center', 'B', 'Oak Avenue', 'Kandy'),
    ('Branch003', 'Downtown Branch', 'Downtown', 'C', 'Elm Road', 'Galle'),
    ('Branch004', 'Northside Branch', 'Northside', 'D', 'Cedar Lane', 'Jaffna'),
    ('Branch005', 'Southside Branch', 'Southside', 'E', 'Maple Street', 'Matara'),
    ('Branch006', 'Westside Branch', 'Westside', 'F', 'Pine Avenue', 'Negombo');
    
INSERT INTO EMPLOYEE (Empl_ID,Supervice_ID,Branch_Id, Empl_Name, Designation)
VALUES
    ('Emp001', 'Emp001','Branch001','Samantha Perera', 'MeterReader'),
    ('Emp002', 'Emp001','Branch002','Nimal Silva', 'MeterReader'),
    ('Emp003', 'Emp001','Branch003','Priya Rajapaksa', 'MeterReader'),
    ('Emp007', 'Emp001','Branch004','Anuradha Fernando', 'MeterReader'),
    ('Emp010', 'Emp001','Branch005','Malini Jayawardena', 'MeterReader'),
    ('Emp012','Emp001', 'Branch006','Ranjan Bandara', 'MeterReader'),
    ('Emp015', 'Emp001','Branch001','Anuradha Sadunika', 'Clerk'),
    ('Emp016', 'Emp001','Branch002','Milan Jayawardena', 'Technician'),
    ('Emp018', 'Emp001','Branch003','Ranjitha Bandara', 'Receptionist');
    
INSERT INTO MeterReader (Empl_ID, Reader_ID, Reader_Name, Area)
VALUES
    ('Emp001', 'Emp001', 'Samantha Perera', 'Branch001'),
    ('Emp002', 'Emp001', 'Nimal Silva', 'Branch002'),
    ('Emp003', 'Emp001', 'Priya Rajapaksa', 'Branch003'),
    ('Emp007', 'Emp001', 'Anura Bandara', 'Branch004'),
    ('Emp010', 'Emp001', 'Malitha Fernando', 'Branch005'),
    ('Emp012', 'Emp001', 'Ranil Jayawardena', 'Branch006');

INSERT INTO CUSTOMER (Cus_ID, Account_Number, Full_Name, Branch_ID, Empl_ID, Lane_No, Streat, Twon)
VALUES
    ('CUS001', 'ACC123456', 'Samantha Perera', 'Branch001', 'Emp001', 'A', 'Main Street', 'Colombo'),
    ('CUS002', 'ACC789012', 'Nimal Silva', 'Branch002', 'Emp002', 'B', 'Oak Avenue', 'Kandy'),
    ('CUS003', 'ACC345678', 'Priyantha Rajapaksa', 'Branch003', 'Emp003', 'C', 'Elm Road', 'Galle'),
    ('CUS004', 'ACC901234', 'Anuradha Fernando', 'Branch004', 'Emp007', 'D', 'Cedar Lane', 'Jaffna'),
    ('CUS005', 'ACC567890', 'Malini Jayawardena', 'Branch005', 'Emp010', 'E', 'Maple Street', 'Matara'),
    ('CUS006', 'ACC234567', 'Ranjan Bandara', 'Branch006', 'Emp012', 'F', 'Pine Avenue', 'Negombo');

INSERT INTO CUSTOMER_CONTACT (Cus_ID, Contact_Number)
VALUES
  ('CUS001', 123456789),
  ('CUS001', 123411700), 
  ('CUS002', 987654321),
  ('CUS003', 654323987),
  ('CUS004', 123789456),
  ('CUS005', 456730000),
  ('CUS005', 456782222),
  ('CUS005', 456745666),
  ('CUS006', 789123456);

INSERT INTO CUSTOMER_METER (Cus_ID, Meter_ID)
VALUES
    ('CUS001', 'Meter001'),
    ('CUS002', 'Meter002'),
    ('CUS003', 'Meter003'),
    ('CUS004', 'Meter004'),
    ('CUS005', 'Meter005'),
    ('CUS006', 'Meter006'),
    ('CUS005', 'Meter009'),
    ('CUS006', 'Meter008');
    
INSERT INTO CUSTOMER_CONNECTION (Cus_ID, CONNECTION_ID)
VALUES
    ('CUS001', 'Con001'),
    ('CUS002', 'Con002'),
    ('CUS003', 'Con003'),
    ('CUS004', 'Co004'),
    ('CUS005', 'Con005'),
    ('CUS005', 'Con006'),
    ('CUS006', 'Con007'),
	('CUS006', 'Con008'); 
    
    
INSERT INTO METER (Meter_ID, Cus_ID, Meter_Type, Installation_Date)
VALUES
    ('Meter001', 'CUS001', 'Digital', '2023-09-04'),
    ('Meter002', 'CUS002', 'Analog', '2023-09-05'),
    ('Meter003', 'CUS003', 'Smart', '2023-09-06'),
    ('Meter004', 'CUS004', 'Digital', '2023-09-07'),
    ('Meter005', 'CUS005', 'Analog', '2023-09-08'),
    ('Meter006', 'CUS006', 'Smart', '2023-09-09'); 
    
INSERT INTO PAYMENT_Det_01 (Cus_ID, Meter_ID, Branch_ID, Amount, Payment_Date, Payment_Month, Payment_Year, Bill_ID, Method)
VALUES
    ('CUS001', 'Meter001', 'Branch001', 1000, 4, 9, 2023, 'Bill001', 'Credit Card'),
    ('CUS002', 'Meter002', 'Branch002', 1500, 5, 9, 2023, 'Bill002', 'PayPal'),
    ('CUS003', 'Meter003', 'Branch003', 1200, 6, 9, 2023, 'Bill003', 'Cash'),
    ('CUS004', 'Meter004', 'Branch004', 800, 7, 9, 2023, 'Bill004', 'Cheque'),
    ('CUS005', 'Meter005', 'Branch005', 2000, 8, 9, 2023, 'Bill005', 'Bank Transfer'),
    ('CUS006', 'Meter006', 'Branch006', 1700, 9, 9, 2023, 'Bill006', 'Cash');
    
INSERT INTO PAYMENT_Det_02 (Branch_ID, Branch_Name)
VALUES
    ('Branch001', 'Main Branch'),
    ('Branch002', 'City Center Branch'),
    ('Branch003', 'Downtown Branch'),
    ('Branch004', 'Northside Branch'),
    ('Branch005', 'Southside Branch'),
    ('Branch006', 'Westside Branch');
    
-- Create a trigger to calculate the Amount column
DELIMITER //
CREATE TRIGGER calculate_amount_trigger BEFORE INSERT ON BILL
FOR EACH ROW
BEGIN
    SET NEW.Amount = NEW.Unit_Price * NEW.Consumption_Unit;
END;
//
DELIMITER ;
    
INSERT INTO BILL (Bill_ID, Cus_ID,Reader_ID, Reading_Date, Consumption_Unit, Unit_Price, Previous_Reading_Unit, Previous_Reading_Date)
VALUES
    ('Bill001', 'CUS001','Emp001', '2023-09-04', 200, 10, 50, '2023-08-04'),
    ('Bill002', 'CUS002', 'Emp002', '2023-09-05', 250, 10, 100, '2023-08-05'),
    ('Bill003', 'CUS003','Emp003',  '2023-09-06', 150, 10, 0, '2023-08-06'),
    ('Bill004', 'CUS004','Emp001',  '2023-09-07', 100, 10, 10, '2023-08-07'),
    ('Bill005', 'CUS005','Emp002',  '2023-09-08', 300, 10, 50, '2023-08-08'),
    ('Bill006', 'CUS006','Emp003',  '2023-09-09', 200, 10, 50, '2023-08-09');

INSERT INTO Complain (Complain_ID, Cus_ID, Description_Com, Status_Com)
VALUES
    ('Com001', 'CUS001', 'Slow internet connection', 'Open'),
    ('Com002', 'CUS002', 'Billing discrepancy', 'Closed'),
    ('Com003', 'CUS003', 'Meter reading issue', 'Open'),
    ('Com004', 'CUS004', 'Connection outage', 'Open'),
    ('Com005', 'CUS005', 'High electricity bill', 'Open'),
    ('Com006', 'CUS006', 'Meter maintenance request', 'Open');

INSERT INTO Feedback (Feedback_No, Customer_ID, Rating, Comments, Timestamp, Resolved, Response)
VALUES
    (1, 'CUS001', 4, 'Good service overall', NOW(), true, 'Issue resolved'),
    (2, 'CUS002', 3, 'Average experience', NOW(), false, ''),
    (3, 'CUS003', 5, 'Excellent service', NOW(), true, 'Issue resolved'),
    (4, 'CUS004', 2, 'Poor customer support', NOW(), false, ''),
    (5, 'CUS005', 4, 'Prompt response', NOW(), true, 'Issue resolved'),
    (6, 'CUS006', 5, 'Very satisfied', NOW(), true, 'Issue resolved');


INSERT INTO Connection_Elec (Connection_ID, Connection_Type, Capacity, Time_Period, Cus_ID)
VALUES
    ('Con001', 'Residential', 'Single Phase', '24 Months', 'CUS001'),
    ('Con002', 'Commercial', 'Three Phase', '12 Months', 'CUS002'),
    ('Con003', 'Industrial', 'Three Phase', '36 Months', 'CUS003'),
    ('Con004','Residential', 'Single Phase', '24 Months', 'CUS004'),
    ('Con005', 'Commercial', 'Three Phase', '12 Months', 'CUS005'),
    ('Con006', 'Industrial', 'Three Phase', '36 Months', 'CUS006');

INSERT INTO Meter_Maintenance (Connection_ID,Owner_Name, Maintain_Date,Connection_type, Description_Main)
VALUES
    ('Con001','Samantha Perera', '2023-09-01','3pahse', 'Routine inspection'),
    ('Con002', 'Nimal Silava','2023-08-25', '3pahse','Meter replacement'),
    ('Con003','Priynatha Rajapaksha', '2023-09-03', '3pahse','Faulty meter repair'),
    ('Con004','Anurada Frnando','2023-09-02', '3pahse','Circuit testing'),
    ('Con005','Malini Jayawardana', '2023-08-30', '3pahse','Meter calibration'),
    ('Con006','Ranjan Bandara', '2023-09-04', '3pahse','Emergency maintenance');
    
-- Update 2 data and delete one from all table 
UPDATE Branch
SET Postal_Name = 'Matara'
WHERE Branch_ID = 'Branch001';

UPDATE Branch
SET Lane_No = 'Lane No 3'
WHERE Branch_ID = 'Branch002';

DELETE FROM Branch
WHERE Branch_ID = 'Branch003';


UPDATE Complain
SET Description_Com = 'Current faliur'
WHERE Complain_ID = 'Com001';

UPDATE Complain
SET Status_Com = 'Closed'
WHERE Complain_ID = 'Com002';

DELETE FROM Complain
WHERE Complain_ID = 'Com003';


UPDATE Feedback
SET Rating = 5
WHERE Feedback_No = 1;

UPDATE Feedback
SET Response = 'Issue resolved successfully'
WHERE Feedback_No = 2;

DELETE FROM Feedback
WHERE Feedback_No = 3;


UPDATE Connection_Elec
SET Capacity = '230'
WHERE Connection_ID = 'Con001';

UPDATE Connection_Elec
SET Time_Period = '12 months'
WHERE Connection_ID = 'Con002';

DELETE FROM Connection_Elec
WHERE Connection_ID = 'Con003';

UPDATE Meter_Maintenance
SET Description_Main = 'Not finish yet'
WHERE Connection_ID = 'Con001';

UPDATE Meter_Maintenance
SET Maintain_Date = '2023-09-05'
WHERE Connection_ID = 'Con002';


DELETE FROM Meter_Maintenance
WHERE Connection_ID = 'Con003';


UPDATE EMPLOYEE
SET Designation = 'Meter Reader'
WHERE Empl_ID = 'Emp001';

UPDATE EMPLOYEE
SET Empl_Name = 'Chamara'
WHERE Empl_ID = 'Emp002';

DELETE FROM EMPLOYEE
WHERE Empl_ID = 'Emp003';


UPDATE MeterReader
SET Area = 'Branch004'
WHERE Empl_ID = 'Emp001';

UPDATE MeterReader
SET Reader_Name = 'Sarath'
WHERE Empl_ID = 'Emp002';

DELETE FROM MeterReader
WHERE Empl_ID = 'Emp003';

UPDATE CUSTOMER
SET Lane_No = 'E'
WHERE Cus_ID = 'CUS001';

UPDATE CUSTOMER
SET Full_Name = 'chanu'
WHERE Cus_ID = 'CUS002';

DELETE FROM CUSTOMER
WHERE Cus_ID = 'CUS003';

UPDATE CUSTOMER_CONTACT
SET Contact_Number = 987004321
WHERE Cus_ID = 'CUS006';

UPDATE CUSTOMER_CONTACT
SET Contact_Number = 123006789
WHERE Cus_ID = 'CUS002';

DELETE FROM CUSTOMER_CONTACT
WHERE Cus_ID = 'CUS003';

UPDATE CUSTOMER_METER
SET Meter_ID = 'Meter021'
WHERE Cus_ID = 'CUS001';

UPDATE CUSTOMER_METER
SET Meter_ID = 'Meter015'
WHERE Cus_ID = 'CUS002';

DELETE FROM CUSTOMER_METER
WHERE Cus_ID = 'CUS003';

UPDATE CUSTOMER_CONNECTION
SET CONNECTION_ID = 'Con031'
WHERE Cus_ID = 'CUS001';

UPDATE CUSTOMER_CONNECTION
SET CONNECTION_ID = 'Con012'
WHERE Cus_ID = 'CUS002';

DELETE FROM CUSTOMER_CONNECTION
WHERE Cus_ID = 'CUS003';

UPDATE METER
SET Meter_Type = 'Digital New version'
WHERE Meter_ID = 'Meter001';

UPDATE METER
SET Installation_Date = '2023-09-10'
WHERE Meter_ID = 'Meter002';

DELETE FROM METER
WHERE Meter_ID = 'Meter003';

UPDATE PAYMENT_Det_01
SET Amount = 1200
WHERE Bill_ID = 'Bill001';

UPDATE PAYMENT_Det_01
SET Payment_Date = 5
WHERE Bill_ID = 'Bill002';

DELETE FROM PAYMENT_Det_01
WHERE Bill_ID = 'Bill003';


UPDATE PAYMENT_Det_02
SET Branch_Name = 'Kandy'
WHERE Branch_ID = 'Branch001';

UPDATE PAYMENT_Det_02
SET Branch_Name = 'Ampara'
WHERE Branch_ID = 'Branch002';

DELETE FROM PAYMENT_Det_02
WHERE Branch_ID = 'Branch003';

UPDATE BILL
SET Amount = 2000
WHERE Bill_ID = 'Bill001';

UPDATE BILL
SET Reading_Date = '2023-09-11'
WHERE Bill_ID = 'Bill002';

DELETE FROM BILL
WHERE Bill_ID = 'Bill003';


-- select
SELECT Full_Name FROM CUSTOMER;

-- Projection Operation:
SELECT Account_Number FROM CUSTOMER;

-- Cartesian Product Operation:
SELECT Full_Name, Branch_Name FROM CUSTOMER, Branch;

-- Create User View:
CREATE VIEW CustomerPayments AS
SELECT Cus_ID, Amount FROM PAYMENT_Det_01;

-- Rename
SELECT Full_Name AS CustomerName, Branch_Name AS BranchName
FROM CUSTOMER, Branch
WHERE CUSTOMER.Branch_ID = Branch.Branch_ID;

-- Aggregation Function (Average):
SELECT AVG(Amount) AS AveragePayment
FROM PAYMENT_Det_01;

-- Like
SELECT Full_Name
FROM CUSTOMER
WHERE Full_Name LIKE '%S%';



-- UNIOUN
SELECT Full_Name,Cus_ID FROM CUSTOMER
UNION
SELECT DISTINCT Cus_ID,contact_number FROM CUSTOMER_CONTACT;


SELECT Empl_ID, Reader_Name
FROM meterreader M
WHERE EXISTS (
    SELECT 1
    FROM employee E
    WHERE M.Empl_ID = E.Empl_Id
);


-- Set Difference
SELECT Empl_ID, Empl_Name
FROM employee
WHERE Empl_ID NOT IN (SELECT Empl_ID FROM meterreader);


-- Division
explain SELECT Empl_ID
FROM EMPLOYEE
WHERE NOT EXISTS (
    SELECT Area
    FROM MeterReader
    WHERE NOT EXISTS (
        SELECT *
        FROM EMPLOYEE AS E1
        WHERE NOT EXISTS (
            SELECT *
            FROM MeterReader AS M1
            WHERE E1.Empl_ID = M1.Empl_ID
              AND M1.Area = MeterReader.Area
        )
    )
);


-- after tuning
explain SELECT DISTINCT E.Empl_ID
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT M.Area
    FROM MeterReader M
    WHERE NOT EXISTS (
        SELECT E1.Empl_ID
        FROM EMPLOYEE E1
        WHERE NOT EXISTS (
            SELECT M1.Area
            FROM MeterReader M1
            WHERE E1.Empl_ID = M1.Empl_ID
              AND M1.Area = M.Area
        )
    )
);



-- inner join
create view UV1 as (select * from customer);
create view UV2 as (select * from branch);
select * from UV1 as view01 inner join UV2 as view02 on view01.Branch_Id = view02.Branch_Id;

-- natural join
create view UV3 as (select cus_ID, full_name, Branch_Id from customer);
create view UV4 as (select * from branch);
select * from UV3 as view03 natural join UV4 as view04;

-- left Outer join
CREATE VIEW UV5 AS SELECT cus_ID, full_name FROM customer;
CREATE VIEW UV6 AS SELECT * FROM payment_det_01;

SELECT * FROM UV5 AS view05
LEFT OUTER JOIN UV6 AS view06
ON view05.cus_ID = view06.Cus_ID;

-- right outer
CREATE VIEW UV7 AS SELECT cus_ID, full_name FROM customer;
CREATE VIEW UV8 AS SELECT * FROM payment_det_01;

SELECT *
FROM UV7 AS view07
right	 OUTER JOIN UV8 AS view08
ON view07.Cus_ID = view08.Cus_ID;

-- Full outer joim
CREATE VIEW RightOuterJoinUserView AS
SELECT view07.cus_ID AS customer_cus_ID, view07.full_name AS customer_full_name, view08.*
FROM UV7 AS view07
RIGHT OUTER JOIN UV8 AS view08 
ON view07.cus_ID = view08.Cus_ID;

CREATE VIEW LeftOuterJoinUserView AS
SELECT view05.cus_ID AS customer_cus_ID, view05.full_name AS customer_full_name, view06.*
FROM UV5 AS view05
LEFT OUTER JOIN UV6 AS view06
ON view05.cus_ID = view06.Cus_ID;

select * from RightOuterJoinUserView
union select * from LeftOuterJoinUserView;

-- Outer Union
CREATE VIEW UV10 AS SELECT Cus_ID, Full_Name FROM CUSTOMER;
CREATE VIEW UV11 AS SELECT * FROM PAYMENT_Det_01;

CREATE VIEW UnionView AS
SELECT Cus_ID
FROM UV10
UNION
SELECT Cus_ID
FROM UV11;
select * from UnionView;

-- Except Usin Not in
CREATE VIEW Empl_All AS SELECT Empl_ID FROM employee;
CREATE VIEW AllRaeder AS SELECT Reader_ID FROM meterreader;

CREATE VIEW EmployeeNotReader AS
SELECT Empl_ID
FROM Empl_All 
WHERE Empl_ID NOT IN (SELECT Reader_ID FROM AllRaeder);

select * from EmployeeNotReader ;


select Full_Name
FROM CUSTOMER
WHERE Cus_ID = (
    SELECT Cus_ID
    FROM PAYMENT_Det_01
    GROUP BY Cus_ID
    HAVING SUM(Amount) = (
        SELECT MAX(Total_Amount)
        FROM (
            SELECT Cus_ID, SUM(Amount) AS Total_Amount
            FROM PAYMENT_Det_01
            GROUP BY Cus_ID
        ) AS subquery
    )
);

-- after tuning
SELECT c.Full_Name
FROM CUSTOMER c
INNER JOIN (
    SELECT Cus_ID, SUM(Amount) AS Total_Amount
    FROM PAYMENT_Det_01
    GROUP BY Cus_ID
    ORDER BY Total_Amount DESC
    LIMIT 1
) AS max_payment_subquery ON c.Cus_ID = max_payment_subquery.Cus_ID;


-- Nested (Where)
SELECT Full_Name
FROM CUSTOMER
WHERE Cus_ID IN (
    SELECT Cus_ID
    FROM PAYMENT_Det_01
    WHERE Amount > (SELECT AVG(Amount) FROM PAYMENT_Det_01)
);


-- Nested Queries (Subquery in FROM Clause):
 SELECT c.Full_Name, IFNULL(SUM(p.Amount), 0) AS TotalPayment
FROM CUSTOMER c
LEFT OUTER JOIN PAYMENT_Det_01 p ON c.Cus_ID = p.Cus_ID
GROUP BY c.Full_Name;

-- Nested Queries (Subquery in SELECT Clause):
SELECT Full_Name, (
    SELECT MAX(Amount)
    FROM PAYMENT_Det_01
    WHERE Cus_ID = CUSTOMER.Cus_ID
) AS MaxPayment
FROM CUSTOMER;

-- Calculate the Total Number of Connections for Each Customer:
SELECT c.Full_Name, COUNT(con.CONNECTION_ID) AS Num_of_Connections
FROM CUSTOMER c
LEFT JOIN CUSTOMER_CONNECTION con ON c.Cus_ID = con.Cus_ID
GROUP BY c.Full_Name;

-- Find Unresolved Complaints:
SELECT c.Full_Name, com.Description_Com, com.Status_Com
FROM CUSTOMER as c
LEFT JOIN Complain as com ON c.Cus_ID = com.Cus_ID
WHERE com.Status_Com = 'Open';

-- Calculate Average Rating by Branch:
SELECT b.Branch_Name, AVG(f.Rating) AS Avg_Rating
FROM Branch b
LEFT JOIN CUSTOMER as c ON b.Branch_ID = c.Branch_ID
LEFT JOIN Feedback as f ON c.Cus_ID = f.Customer_ID
GROUP BY b.Branch_Name;

-- Add indexes to the Branch_ID columns
ALTER TABLE Branch ADD INDEX idx_Branch_ID (Branch_ID);
ALTER TABLE CUSTOMER ADD INDEX idx_Branch_ID (Branch_ID);
ALTER TABLE Feedback ADD INDEX idx_Customer_ID (Customer_ID);

SELECT b.Branch_Name, AVG(f.Rating) AS Num_Ratings
FROM Branch b
LEFT JOIN CUSTOMER c ON b.Branch_ID = c.Branch_ID
LEFT JOIN Feedback f ON c.Cus_ID = f.Customer_ID
GROUP BY b.Branch_Name;

-- List Customers Who Have Complained and Their Complaint Status:
SELECT c.Full_Name, com.Description_Com, com.Status_Com
FROM CUSTOMER as c
LEFT JOIN Complain as com ON c.Cus_ID = com.Cus_ID;

-- Find Customers with Multiple Contact Numbers:
explain SELECT c.Full_Name, COUNT(cc.Contact_Number) AS Num_of_Contacts
FROM CUSTOMER c
INNER JOIN CUSTOMER_CONTACT cc ON c.Cus_ID = cc.Cus_ID
GROUP BY c.Full_Name
HAVING Num_of_Contacts > 1;


-- To tune Add indexes to the Cus_ID columns
ALTER TABLE CUSTOMER ADD INDEX idx_Cus_ID (Cus_ID);
ALTER TABLE CUSTOMER_CONTACT ADD INDEX idx_Cus_ID (Cus_ID);

explain SELECT c.Full_Name, COUNT(cc.Contact_Number) AS Num_of_Contacts
FROM CUSTOMER c
INNER JOIN CUSTOMER_CONTACT cc ON c.Cus_ID = cc.Cus_ID
GROUP BY c.Full_Name
HAVING Num_of_Contacts > 1;



-- Tuned Queries

-- Aggregation Function (Average) After tuning:
SET @avgAmount := (SELECT AVG(Amount) FROM PAYMENT_Det_01);
SELECT DISTINCT c.Full_Name
FROM CUSTOMER c
INNER JOIN PAYMENT_Det_01 p ON c.Cus_ID = p.Cus_ID
WHERE p.Amount > @avgAmount;

WITH AvgPayment AS (
    SELECT AVG(Amount) AS AvgAmount
    FROM PAYMENT_Det_01
)

SELECT c.Full_Name
FROM CUSTOMER c
WHERE EXISTS (
    SELECT 1
    FROM PAYMENT_Det_01 p
    WHERE c.Cus_ID = p.Cus_ID
    AND p.Amount > (SELECT AvgAmount FROM AvgPayment)
);

SELECT DISTINCT c.Full_Name
FROM CUSTOMER c
WHERE EXISTS (
    SELECT 1
    FROM PAYMENT_Det_01 p
    WHERE c.Cus_ID = p.Cus_ID
    HAVING AVG(p.Amount) > @avgAmount
);



-- tunes set Difference
SELECT e.Empl_ID, e.Empl_Name
FROM employee e
LEFT JOIN meterreader m ON e.Empl_ID = m.Empl_ID
WHERE m.Empl_ID IS NULL;

-- Union After tuning 
SELECT Full_Name,Cus_ID FROM CUSTOMER
UNION ALL
SELECT DISTINCT Cus_ID,contact_number FROM CUSTOMER_CONTACT;


-- tuned Division
SELECT DISTINCT E.Empl_ID
FROM EMPLOYEE AS E
WHERE NOT EXISTS (
    SELECT DISTINCT M1.Area
    FROM MeterReader AS M1
    WHERE NOT EXISTS (
        SELECT *
        FROM MeterReader AS M2
        WHERE E.Empl_ID = M2.Empl_ID
          AND M2.Area = M1.Area
    )
);

-- already tuned Inner Join
SELECT c.Full_Name, b.Branch_Name
FROM CUSTOMER c
INNER JOIN Branch b ON c.Branch_ID = b.Branch_ID;


-- After tuning Natural
SELECT c.Full_Name, b.Branch_Name
FROM CUSTOMER c
INNER JOIN Branch b ON c.Branch_ID = b.Branch_ID;

-- After tuning Left Outer Join
SELECT c.Full_Name AS Customer_Name, p.Amount AS Payment_Amount
FROM CUSTOMER c
LEFT OUTER JOIN PAYMENT_Det_01 p ON c.Cus_ID = p.Cus_ID;


-- Tuned Neasted 01
-- Create an index on the Amount column of PAYMENT_Det_01 table
CREATE INDEX idx_payment_amount ON PAYMENT_Det_01 (Amount);
explain SELECT C.Full_Name
FROM CUSTOMER C
WHERE C.Cus_ID IN (
    SELECT P.Cus_ID
    FROM PAYMENT_Det_01 P
    WHERE P.Amount > (SELECT AVG(Amount) FROM PAYMENT_Det_01)
);

-- after tuned Nested Queries (Subquery in FROM Clause):
explain SELECT c.Full_Name, IFNULL(SUM(p.Amount), 0) AS TotalPayment
FROM CUSTOMER c
LEFT JOIN PAYMENT_Det_01 p ON c.Cus_ID = p.Cus_ID
GROUP BY c.Full_Name;

explain SELECT c.Full_Name, COALESCE(SUM(p.Amount), 0) AS TotalPayment
FROM CUSTOMER c
LEFT JOIN PAYMENT_Det_01 p ON c.Cus_ID = p.Cus_ID
GROUP BY c.Full_Name;


-- Atfer tuned Nested Queries (Subquery in SELECT Clause):
explain SELECT C.Full_Name, MAX(P.Amount) AS MaxPayment
FROM CUSTOMER C
LEFT JOIN PAYMENT_Det_01 P ON C.Cus_ID = P.Cus_ID
GROUP BY C.Full_Name;


