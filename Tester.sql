#CALL insert_pass('Rohit', 'Pail', "1999-12-19", '351728974351', 'suncity Complex', 'Guwahati', 'Silchar', 'B25-37', '7002208850', '9435078523');
#CALL insert_pass('Akash', 'Lahoty', "1965-7-23", '326372465275', 'HSR Layout', 'Bangalore', 'Silchar', 'B34-73', '6002354232', '-');
#CALL insert_pass('Chinmoy', 'Talukdar', "1950-1-1", '235729846520', 'Dighir Para Silchar', 'Guwahati', 'Silchar', 'B02-12', '6002352541', '-');
#CALL insert_pass('Ravi', 'Kumar', "1994-1-19", '23454235634', 'Panchayat lane house no. - 342', 'Patna', 'Silchar', 'B23-84', '700235235', '-');
#CALL insert_pass('Prachurjya', 'Kashyap', "1983-3-14", '526246523432', 'Digvijay Estate No 2, 1st Pokhran Road, Thane ', 'Kolkata', 'Silchar', 'B06-12', '7002356526', '-');
#CALL insert_pass('Mainak', 'Deb', "1955-2-13", '24614617145', '11 st Floor Doulatram Mansion, Kitridge Road, Colaba', 'Mumbai', 'Silchar', 'B82-34', '6000173645', '9435576834');
#CALL insert_pass('Tafreed', 'Numan', "1999-12-12", '256456265474', 'Bab Makkah Dist.', 'Dubai', 'Silchar', 'D32-59', '0235262452673', '2395480129642');
#CALL insert_pass('Sandeep', 'Saha', "1991-1-1", '3516464135132", Ashram Road Silchar', 'Guwahati', 'Silchar', 'R23-61', '6000382596', '-');
#select * from passenger;

#SELECT * FROM alloted;

#SELECT * FROM person_allotment_status;

#SELECT * FROM Room WHERE Room.Occupancy_status="Occupied";

#SELECT * FROM alloted;

#SELECT * FROM PID;

#CALL Occupied_rooms();

#CALL current_Avaibility();

#CALL search_room_occupancy(2, 'Second', 8);

#CALL search_pass('Akash', 'Lahoty');

#CALL person_to_be_discharged_today();

#CALL Discharge_person();

#CALL person_discharged("2020-12-25");

#update alloted set Departure_Date=DATE_ADD(Arrival_Date, INTERVAL 3 DAY) where (Pass_ID=1);

select * from passenger_allotment_status;
