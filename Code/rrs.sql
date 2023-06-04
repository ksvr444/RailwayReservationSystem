show databases;
-- drop database IF EXISTS RRS;
create DATABASE IF NOT EXISTS RRS;
use RRS;
drop table if EXISTS Train;
Create Table IF NOT EXISTS Train(
    `number` varchar(10) NOT NULL,
    `name` varchar(20) NOT NULL UNIQUE,
    `source` varchar(20) NOT NULL,
    destination varchar(20) NOT NULL,
    premium_fare int NOT NULL,
    general_fare int NOT NULL,
    primary key (`number`)
);
drop table if EXISTS Availability;
Create Table IF NOT EXISTS Availability(
    train_number varchar(10) NOT NULL,
    `day` ENUM(
        'SUNDAY',
        'MONDAY',
        'TUESDAY',
        'WEDNESDAY',
        'THURSDAY',
        'FRIDAY',
        'SATURDAY'
    ),
    foreign key (train_number) references Train(number),
    primary key(train_number, `day`)
);
drop table if EXISTS Passenger;
Create Table IF NOT EXISTS Passenger(
    firstname VARCHAR(20) NOT NULL,
    lastname VARCHAR(20) NOT NULL,
    phone CHAR(12) NOT NULL,
    bdate DATE NOT NULL,
    county VARCHAR(20) NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(20) NOT NULL,
    ssn CHAR(15) NOT NULL,
    PRIMARY KEY(ssn)
);
drop table if EXISTS Booking;
Create Table IF NOT EXISTS Booking(
    `date` date NOT NULL,
    train_number varchar(10) NOT NULL,
    passenger_ssn CHAR(15) NOT NULL,
    category ENUM('premium', 'general') NOT NULL,
    status ENUM('confirmed', 'waitlist') NOT NULL,
    Primary key(`date`, train_number, passenger_ssn),
    foreign key (train_number) references Train(number),
    foreign key(passenger_ssn) references Passenger(ssn)
);

drop table if EXISTS TrainStatus;
Create Table IF NOT EXISTS TrainStatus(
    TrainDate DATE NOT NULL,
    train_number varchar(3) NOT NULL,
    PremiumSeatsAvailable INT NOT NULL,
	GenSeatsAvailable INT NOT NULL,
	PremiumSeatsOccupied INT NOT NULL,
	GenSeatsOccupied INT NOT NULL,
    foreign key (train_number) references Train(number)
);

-- Train Table
insert into Train(number, name, premium_fare, general_fare, source, destination)
values
('001', 'Orient Express' , 800, 600, 'Paris', 'Istanbul'),
('002', 'Flying Scotsman', 4000, 3500, 'Edinburgh', 'London'),
('003', 'Golden Arrow' , 980, 860, 'Victoria', 'Dover'),
('004', 'Golden Chariot', 4300, 3800, 'Bangalore', 'Goa'),
('005', 'Maharaja Express', 5980, 4510, 'Delhi', 'Mumbai');

-- Availability Table
INSERT INTO Availability
VALUES ('001', 'MONDAY'),
	('001', 'TUESDAY'),
    ('001', 'WEDNESDAY'),
	('001', 'THURSDAY'),
    ('001', 'FRIDAY'),
    ('002', 'FRIDAY'),
    ('002', 'SUNDAY'),
    ('002', 'SATURDAY'),
	('003', 'MONDAY'),
	('003', 'TUESDAY'),
    ('003', 'WEDNESDAY'),
    ('004', 'SUNDAY'),
    ('004', 'SATURDAY'),
    ('005', 'THURSDAY'),
    ('005', 'WEDNESDAY'),
	('005', 'FRIDAY');
	
	
-- Passenger Table
insert into Passenger(firstname,lastname,address,city,county,phone,ssn,bdate)
values
('James','Butt','6649 N Blue Gum St','New Orleans','Orleans','504-845-1427','264816896',str_to_date('10/10/1968','%m/%d/%y')),
('Josephine','Darakjy','4 B Blue Ridge Blvd','Brighton','Livingston','810-374-9840','240471168',str_to_date('11/1/1975','%m/%d/%y')),
('Art','Venere','8 W Cerritos Ave #54','Bridgeport','Gloucester','605-264-4130','285200976',str_to_date('11/13/1982','%m/%d/%y')),
('Lenna','Paprocki','639 Main St','Anchorage','Anchorage','907-921-2010','309323096',str_to_date('8/9/1978','%m/%d/%y')),
('Donette','Foller','34 Center St','Hamilton','Butler','513-549-4561','272610795',str_to_date('6/11/1990','%m/%d/%y')),
('Simona','Morasca','3 Mcauley Dr','Ashland','Ashland','419-800-6759','250951162',str_to_date('8/15/1994','%m/%d/%y')),
('Mitsue','Tollner','7 Eads St','Chicago','Cook','773-924-8565','272913578',str_to_date('7/4/1984','%m/%d/%y')),
('Leota','Dilliard','7 W Jackson Blvd','San Jose','Santa Clara','408-813-1105','268682534',str_to_date('5/9/1991','%m/%d/%y')),
('Sage','Wieser','5 Boston Ave #88','Sioux Falls','Minnehaha','605-794-4895','310908858',str_to_date('2/25/1982','%m/%d/%y')),
('Kris','Marrier','228 Runamuck Pl #2808','Baltimore','Baltimore City','410-804-4694','322273872',str_to_date('4/4/1956','%m/%d/%y')),
('Minna','Amigon','2371 Jerrold Ave','Kulpsville','Montgomery','215-422-8694','256558303',str_to_date('9/9/1995','%m/%d/%y')),
('Abel','Maclead','37275 St  Rt 17m M','Middle Island','Suffolk','631-677-3675','302548590',str_to_date('11/5/1960','%m/%d/%y')),
('Kiley','Caldarera','25 E 75th St #69','Los Angeles','Los Angeles','310-254-3084','284965676',str_to_date('5/9/1981','%m/%d/%y')),
('Graciela','Ruta','98 Connecticut Ave Nw','Chagrin Falls','Geauga','440-579-7763','277292710',str_to_date('2/25/1982','%m/%d/%y')),
('Cammy','Albares','56 E Morehead St','Laredo','Webb','956-841-7216','331160133',str_to_date('4/4/1956','%m/%d/%y')),
('Mattie','Poquette','73 State Road 434 E','Phoenix','Maricopa','605-953-6360','331293204',str_to_date('9/9/1995','%m/%d/%y')),
('Meaghan','Garufi','69734 E Carrillo St','Mc Minnville','Warren','931-235-7959','290123298',str_to_date('11/2/1960','%m/%d/%y')),
('Gladys','Rim','322 New Horizon Blvd','Milwaukee','Milwaukee','414-377-2880','286411536',str_to_date('5/9/1991','%m/%d/%y')),
('Yuki','Whobrey','1 State Route 27','Taylor','Wayne','313-341-4470','294860856',str_to_date('2/25/1985','%m/%d/%y')),
('Fletcher','Flosi','394 Manchester Blvd','Rockford','Winnebago','815-426-5657','317434088',str_to_date('4/4/1961','%m/%d/%y'));


-- Booking Table
insert into Booking (passenger_ssn,train_number,category,status)
values
('264816896','003','Premium','confirmed'),
('240471168','002','General','confirmed'),
('285200976','004','Premium','confirmed'),
('285200976','002','Premium','confirmed'),
('317434088','002','Premium','confirmed'),
('310908858','002','General','confirmed'),
('322273872','002','General','confirmed'),
('256558303','003','Premium','waitlist'),
('302548590','002','General','waitlist'),
('284965676','003','Premium','waitlist'),
('277292710','003','General','waitlist'),
('331160133','003','General','waitlist'),
('331293204','003','General','waitlist'),
('290123298','003','General','waitlist'),
('286411536','004','Premium','confirmed'),
('294860856','004','Premium','confirmed'),
('317434088','004','Premium','confirmed'),
('310908858','004','Premium','confirmed'),
('322273872','004','Premium','confirmed'),
('256558303','004','Premium','confirmed'),
('302548590','004','Premium','confirmed'),
('284965676','004','General','confirmed'),
('277292710','004','General','confirmed'),
('331160133','004','General','confirmed'),
('331293204','004','General','confirmed');

-- Train Status table
insert into TrainStatus(TrainDate, train_number, PremiumSeatsAvailable, GenSeatsAvailable, PremiumSeatsOccupied, GenSeatsOccupied)
values
('2022-02-19', '001', 10, 10, 0, 0),
('2022-02-20', '002', 8, 5, 2, 5),
('2022-02-21', '005', 7, 6, 3, 4),
('2022-02-21', '004', 6, 3, 4, 7),
('2022-02-18', '003', 5, 6, 2, 3);

select *
from Passenger;
select *
from Booking;
-- QUESTION-1 
select number,
    name,
    source,
    destination,
    date
from Train
    RIGHT JOIN Booking ON Train.number = Booking.train_number
    RIGHT JOIN Passenger ON Booking.passenger_ssn = Passenger.ssn
where Passenger.firstname = 'john'
    and Passenger.lastname = 'doe';
-- QUESTION-2 
select P.firstname,
    P.lastname,
    B.train_number,
    B.category,
    B.date
from Passenger as P
    RIGHT JOIN Booking as B ON P.ssn = B.passenger_ssn
where day(B.date) = 2
    and B.status = 'confirmed';
-- Question-3
select Train.name as Train_name,
    Train.number as Train_number,
    Train.source,
    Train.destination,
    Passenger.firstname,
    Passenger.address,
    Booking.category,
    Booking.status
from Booking
    LEFT JOIN Train ON Train.number = Booking.train_number
    LEFT JOIN Passenger ON Passenger.ssn = Booking.passenger_ssn
where DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(Passenger.bdate, '%Y') - (DATE_FORMAT(NOW(), '00-%m-%d') < DATE_FORMAT(Passenger.bdate, '00-%m-%d')) BETWEEN 50 AND 60;
-- QUESTION-4
select count(Booking.passenger_ssn),
    Train.name as Train_name
from Booking
    LEFT JOIN Train ON Booking.train_number = Train.number
where Booking.status = 'confirmed'
GROUP BY Booking.train_number;
-- QUESTION-5
select Passenger.firstname,
    Passenger.lastname,
    Passenger.address,
    Booking.category
from Booking
    LEFT JOIN Train ON Train.number = Booking.train_number
    LEFT JOIN Passenger ON Passenger.ssn = Booking.passenger_ssn
where Train.name = 'Metro'
    and Booking.status = 'confirmed';
--