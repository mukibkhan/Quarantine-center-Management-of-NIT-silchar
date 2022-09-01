Create table Passenger
(
	Pass_ID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    First_name VARCHAR(20),
    Last_name VARCHAR(20),
    DOB Date,
    Age INT,
    Aadhar_No VARCHAR(20),
	Address VARCHAR(255),
	Arrival_Date DATE,
	Coming_from VARCHAR(255),
	Goes_to VARCHAR(255),
	Flight_No VARCHAR(20)
	
);

Create Table person_allotment_status
(
  Pass_ID INT PRIMARY KEY,
  Status Varchar(20),
  Foreign key (Pass_ID) references Passenger(Pass_ID)
);

Create table Phone_No
(
	Pass_ID INT,
    mobile_no1 VARCHAR(50),
    mobile_no2 VARCHAR(50),
    Foreign Key (Pass_ID) references Passenger(Pass_ID)
    on delete cascade
    on update cascade
);

Create table Room
(
    Room_ID VARCHAR(45) PRIMARY KEY,
    Hostel_No INT,
    Floor VARCHAR(20),
    Room_No INT,
    Occupancy_status VARCHAR(20) DEFAULT 'Empty'
);

create table PID(pid INT Primary Key);

Create table Alloted
(
    Pass_ID INT,
    Room_ID VARCHAR(20),
    Arrival_Date Date,
    Departure_Date Date,
    PRIMARY KEY (Pass_ID,Room_ID),
    Foreign Key (Pass_ID)
    references Passenger(Pass_ID),
    Foreign Key (Room_ID)
    references Room(Room_ID)
);

Create table Hostel
(
	Hostel_no INT Primary Key,
    Available_Rooms_ground INT,
    Available_Rooms_first INT,
    Available_Rooms_second INT,
    Warden_Name Varchar(50)
);

set @ID = 0;
set @Hostel1_ground_floor = 1;
set @Hostel1_first_floor = 1;
set @Hostel1_second_floor = 1;
set @Hostel2_ground_floor = 1;
set @Hostel2_first_floor = 1;
set @Hostel2_second_floor = 1;

insert into Hostel values (1,100,100,50,'SM');
insert into Hostel values (2,100,100,50,'PKS');

DELIMITER //
CREATE TRIGGER ID_calculated
AFTER INSERT ON Passenger 
FOR EACH ROW
BEGIN
	Set @ID = New.Pass_ID;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Age_Calculated
BEFORE INSERT ON Passenger 
FOR EACH ROW
BEGIN
IF NEW.DOB IS NOT NULL THEN
	SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.DOB, CURDATE());
END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER DepartureDate_calculate
BEFORE INSERT ON Alloted
FOR EACH ROW
BEGIN
IF NEW.Arrival_Date IS NOT NULL THEN
	SET NEW.Departure_Date= DATE_ADD(New.Arrival_Date,INTERVAL 14 DAY);
    #SET New.Departure_Date = New.Arrival_Date;
END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER passenger_status_update
AFTER INSERT ON Passenger
FOR EACH ROW
BEGIN
    INSERT INTO person_allotment_status (Pass_ID,Status) VALUES (New.Pass_ID,'Quarantined');
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_Deletion
BEFORE DELETE ON Alloted
FOR EACH ROW
BEGIN
        UPDATE Room set Occupancy_status='Empty' where Room_ID=OLD.Room_ID;
        set @floor = (select Floor from Room where Room.Room_ID=OLD.Room_ID);
        Set @hostel_no = (Select Hostel_no from Room where Room.Room_ID=OLD.Room_ID);
        if @hostel_no=1 then
            if @floor='Ground' then
                UPDATE Hostel set Available_Rooms_ground=Available_Rooms_ground+1 where Hostel_no=1;
            elseif @floor='First' then
                UPDATE Hostel set Available_Rooms_ground=Available_Rooms_first+1 where Hostel_no=1;
            else 
                UPDATE Hostel set Available_Rooms_second=Available_Rooms_second+1 where Hostel_no=1;
            end if;
        else
            if @floor='Ground' then
                UPDATE Hostel set Available_Rooms_ground=Available_Rooms_ground+1 where Hostel_no=2;
            elseif @floor='First' then
                UPDATE Hostel set Available_Rooms_ground=Available_Rooms_first+1 where Hostel_no=2;
            else 
                UPDATE Hostel set Available_Rooms_second=Available_Rooms_second+1 where Hostel_no=2;
            end if;
        end if;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Deletion
AFTER INSERT ON PID
FOR EACH ROW
BEGIN
        UPDATE person_allotment_status set Status='Discharged' where Pass_ID=New.pid;
END //
DELIMITER ;





DELIMITER //
CREATE TRIGGER room_number_calculated
AFTER INSERT ON Passenger
FOR EACH ROW
BEGIN

    Set @hostel_no=1;
    Set @floor='Ground';
    Set @room_no=1;
    if New.Age > 60 then
        if @Hostel1_ground_floor > 100 then
            Set @hostel_no = 2;
            set @room_no = @Hostel2_ground_floor;
            set @floor = 'Ground';
            set @Hostel2_ground_floor =MOD(Hostel2_ground_floor + 1,100);
            update Hostel set Available_Rooms_ground = Available_Rooms_ground - 1 where hostel_no = 2;
        else
		    set @room_no = @Hostel1_ground_floor;
            set @floor = 'Ground';
            set @Hostel1_ground_floor =MOD(@Hostel1_ground_floor + 1,100);
            update Hostel set Available_Rooms_ground = Available_Rooms_ground - 1 where hostel_no = 1;
        end if;
    elseif New.Age > 40 AND New.Age < 60 then
        if @Hostel1_first_floor > 100 then
            Set @hostel_no = 2;
            set @room_no = @Hostel2_first_floor;
            set @floor = 'First';
            set @Hostel2_first_floor = MOD(@Hostel2_first_floor + 1,100);
            update Hostel set Available_Rooms_first = Available_Rooms_first - 1 where hostel_no = 2;
        else
		    set @room_no = @Hostel1_first_floor;
            set @Hostel1_first_floor = MOD(@Hostel1_first_floor + 1,100);
		    set @floor = 'First';
		    update Hostel set Available_Rooms_first = Available_Rooms_first - 1 where hostel_no = 1;
		end if;
	else 
	    if @Hostel1_second_floor > 50 then
            set @hostel_no = 2;
            set @room_no = @Hostel2_second_floor;
            set @floor = 'Second';
            set @Hostel2_second_floor = MOD(@Hostel2_second_floor + 1,50);
            update Hostel set Available_Rooms_second = Available_Rooms_second - 1 where hostel_no = 2;
        else
		    set @room_no = @Hostel1_second_floor;
		    set @Hostel1_second_floor = MOD(@Hostel1_second_floor + 1,50);
		    set @floor = 'Second';
		    update Hostel set Available_Rooms_second = Available_Rooms_second - 1  where hostel_no = 1;
		end if;
    end if;
    SET @idi=CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('H',@hostel_no),"_"),@floor),"_"),@room_no);
    INSERT INTO Alloted(Pass_ID,Room_ID, Arrival_Date) VALUES (@ID,@idi,NEW.Arrival_Date);
    UPDATE Room Set Occupancy_status='Occupied' where Room_ID=@idi;
END //
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_pass(IN First_name VARCHAR(20),IN Last_name VARCHAR(20),IN DOB Date,IN Aadhar_No VARCHAR(20) ,IN Address VARCHAR(255),IN Coming_from VARCHAR(255),IN Goes_to VARCHAR(255), IN Flight_No VARCHAR(20),IN mobile_no1 VARCHAR(20),IN mobile_no2 Varchar(20))
BEGIN

	INSERT INTO `Passenger` (`First_name`,`Last_name`,`DOB`, `Aadhar_No`, `Address`, `Coming_from`, `Goes_to`, `Arrival_Date`, `Flight_No`) VALUES (First_name, Last_name, DOB, Aadhar_No, Address, Coming_from, Goes_to, CURDATE(), Flight_No);
    INSERT INTO `Phone_No` (`Pass_ID`,`mobile_no`) VALUES (@ID,mobile_no1);
    if mobile_no2 <> '-' then
    INSERT INTO `Phone_No` (`Pass_ID`,`mobile_no`) VALUES (@ID,mobile_no2);
    end if;
    
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE generate_room(IN hostel INT, IN floor Varchar(20), IN capacity INT)
BEGIN

	DECLARE x  INT;  
    DECLARE id VARCHAR(45);
	SET x = 1;

	loop_label:  LOOP
		IF  x > capacity THEN 
			LEAVE  loop_label;
		END  IF;
        SET id = CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('H',hostel),"_"),floor),'_'),x);
        INSERT INTO `Room` (`Room_ID`,`Room_No`,`Hostel_no`,`Floor`) VALUES (id,x,hostel,floor);
        SET  x = x + 1;
	END LOOP;
	
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE search_pass(IN First_name varchar(20),IN Last_name varchar(20))
BEGIN

	select Passenger.Pass_ID,First_name,Last_name,DOB,Age,Address,Aadhar_No,Coming_from,Goes_to,Flight_No,Passenger.Arrival_Date,Status,Room_ID from Passenger,person_allotment_status,Alloted
	where  Passenger.First_name= First_name AND Passenger.Last_name=Last_name AND person_allotment_status.Pass_ID=Passenger.Pass_ID AND Alloted.Pass_ID=Passenger.Pass_ID;
	
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE search_room_occupancy(IN Hostel_no INT,IN Floor Varchar(20),IN Room_No INT)
BEGIN
        DECLARE idi varchar(45);
        DECLARE room_status varchar(20);
        SET idi = CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('H',Hostel_no),"_"),Floor),'_'),Room_No);
        Set room_status = (Select Occupancy_status from Room where Room_ID =idi);
        if room_status='Occupied' then 
            select Passenger.Pass_ID,First_name,Last_name,DOB,Age,Address,Aadhar_No,Coming_from,Goes_to,Flight_No,Passenger.Arrival_Date,Departure_Date from Passenger,Alloted
            where Alloted.Room_ID=idi AND Passenger.Pass_ID=Alloted.Pass_ID;
        else 
            select 'Empty';
        end if;
	
	
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE current_Avaibility()
BEGIN
        Select * from Hostel;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Occupied_rooms()
BEGIN
        Select Alloted.Room_ID,Alloted.Pass_ID,First_name,Last_name from Room,Alloted,Passenger
        where Room.Room_ID=Alloted.Room_ID AND Room.Occupancy_status='Occupied' AND Passenger.Pass_ID=Alloted.Pass_ID;
	
END$$
DELIMITER ;

DELIMITER //
Create PROCEDURE person_discharged(IN d_date DATE)
BEGIN
    Select * from Passenger,Alloted where Passenger.Pass_ID=Alloted.Pass_ID AND Departure_Date= d_date;
END //
DELIMITER ;  

DELIMITER //
Create PROCEDURE person_to_be_discharged_today()
BEGIN
    Select * from Passenger,Alloted where Passenger.Pass_ID=Alloted.Pass_ID AND Departure_Date= CURDATE();
END //
DELIMITER ; 

DELIMITER //
Create PROCEDURE Discharge_person()
BEGIN
    
    INSERT INTO PID(pid) Select Passenger.Pass_ID from Passenger,Alloted where Passenger.Pass_ID=Alloted.Pass_ID AND Departure_Date= CURDATE();
	DELETE from Alloted where Departure_Date =CURDATE();
	DELETE from PID;
    
END //
DELIMITER ;
