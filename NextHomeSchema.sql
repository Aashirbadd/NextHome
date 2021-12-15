DROP DATABASE nextHome;
CREATE DATABASE nextHome;
USE nextHome;
ALTER USER 'root' @'localhost' IDENTIFIED WITH mysql_native_password BY '';
flush privileges;
CREATE TABLE `Listings` (
  `idListings` int NOT NULL AUTO_INCREMENT,
  `MLSCode` varchar(50) DEFAULT NULL,
  `BasementType` varchar(45) NOT NULL,
  `Description` LONGTEXT NOT NULL,
  `Price` int NOT NULL,
  `SquareFootage` int NOT NULL,
  `Bedrooms` int NOT NULL,
  `Bathrooms` int NOT NULL,
  `Address` varchar(45) NOT NULL,
  `AreaName` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `BrokerageWebsite` varchar(45) DEFAULT NULL,
  `RealtorWebsite` varchar(255) DEFAULT NULL,
  `ImageURL` varchar(500) DEFAULT '../img/House.jpeg',
  PRIMARY KEY (`idListings`),
  UNIQUE KEY `idListings_UNIQUE` (`idListings`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `ListingPhoto` (
  `ListingID` int NOT NULL,
  `FileName` varchar(255) NOT NULL,
  `ResolutionX` int DEFAULT NULL,
  `ResolutionY` int DEFAULT NULL,
  PRIMARY KEY (`ListingID`, `FileName`),
  KEY `ListingID_idx` (`ListingID`),
  CONSTRAINT `ListingID` FOREIGN KEY (`ListingID`) REFERENCES `Listings` (`idListings`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `Brokerage` (
  `Website` varchar(255) NOT NULL,
  `BrokerageName` varchar(45) NOT NULL,
  `BrokeragePic` varchar(500) DEFAULT "../img/cir.png",
  PRIMARY KEY (`Website`),
  UNIQUE KEY `Website_UNIQUE` (`Website`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `Realtors` (
  `Website` varchar(255) NOT NULL,
  `PhoneNumber` varchar(45) NOT NULL,
  `RealtorName` varchar(45) NOT NULL,
  `RealtorPic` varchar(500) DEFAULT "../img/realtor.png",
  PRIMARY KEY (`Website`),
  UNIQUE KEY `Website_UNIQUE` (`Website`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `AreaSubdivision` (
  `Name` varchar(10) NOT NULL,
  PRIMARY KEY (`Name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `User` (
  `FName` varchar(45) NOT NULL,
  `LName` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  PRIMARY KEY (`Email`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `Search` (
  `Email` varchar(45) NOT NULL,
  `AreaCode` varchar(10) NOT NULL,
  `SquareFootage` int NOT NULL,
  `PriceRange` varchar(45) NOT NULL,
  PRIMARY KEY (
    `AreaCode`,
    `Email`,
    `SquareFootage`,
    `PriceRange`
  )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `Retrieves` (
  `Email` varchar(45) NOT NULL,
  `AreaCode` varchar(45) NOT NULL,
  `SqFt` int NOT NULL,
  `PriceRange` varchar(45) NOT NULL,
  `ListingID` int NOT NULL,
  PRIMARY KEY (
    `Email`,
    `AreaCode`,
    `SqFt`,
    `PriceRange`,
    `ListingID`
  )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `Review` (
  `idReview` int NOT NULL AUTO_INCREMENT,
  `Email` varchar(45) NOT NULL,
  `ReviewDescription` LONGTEXT NOT NULL,
  `ReviewDate` datetime DEFAULT NULL,
  `Flag` tinyint DEFAULT '0',
  `AreaCode` varchar(45) DEFAULT NULL,
  `ReviewTitle` varchar(45) NOT NULL,
  `ReviewRating` int NOT NULL,
  PRIMARY KEY (`idReview`, `Email`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `Flag` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Email` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`, `Email`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `AdminUser` (
  `AdminCode` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `AdminEmail` varchar(100) NOT NULL,
  `Password` varchar(45) NOT NULL,
  PRIMARY KEY (`AdminCode`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE `Moderates` (
  `AdminCode` int NOT NULL,
  `ReviewID` int NOT NULL,
  PRIMARY KEY (`AdminCode`, `ReviewID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
ALTER TABLE Listings
ADD CONSTRAINT `BrokerageWebsite` FOREIGN KEY (`BrokerageWebsite`) REFERENCES `Brokerage` (`Website`),
  ADD CONSTRAINT `AreaName` FOREIGN KEY (`AreaName`) REFERENCES `AreaSubdivision` (`Name`),
  ADD CONSTRAINT `RealtorWebsite` FOREIGN KEY (`RealtorWebsite`) REFERENCES `Realtors` (`Website`),
  ADD CONSTRAINT `PostOwner` FOREIGN KEY (`Email`) REFERENCES `User` (`Email`);
ALTER TABLE Search
ADD CONSTRAINT `Email` FOREIGN KEY (`Email`) REFERENCES `User` (`Email`),
  ADD CONSTRAINT `AreaCode` FOREIGN KEY (`AreaCode`) REFERENCES `AreaSubdivision` (`Name`);
/*
 ALTER TABLE Retrieves
 ADD CONSTRAINT `UserID` 
 FOREIGN KEY (`UserID`) REFERENCES `Search` (`UserID`),
 ADD CONSTRAINT `AreaCode` 
 FOREIGN KEY (`AreaCode`) REFERENCES `Search` (`AreaCode`),
 ADD CONSTRAINT `SqFt` 
 FOREIGN KEY (`SqFt`) REFERENCES `Search` (`SquareFootage`),
 ADD CONSTRAINT `PriceRange` 
 FOREIGN KEY (`PriceRange`) REFERENCES `Search` (`PriceRange`),
 ADD CONSTRAINT `ListingID` 
 FOREIGN KEY (`ListingID`) REFERENCES `Listings` (`ListingID`);
 Error Code: 1822. Failed to add the foreign key constraint. Missing index for constraint 'SqFt' in the referenced table 'Search'
 (Didn't work --> find a way to make this work)*/
ALTER TABLE Review
ADD CONSTRAINT `AreaCodeReference` FOREIGN KEY (`AreaCode`) REFERENCES `AreaSubdivision` (`Name`),
  ADD CONSTRAINT `UserReference` FOREIGN KEY (`Email`) REFERENCES `User` (`Email`);
ALTER TABLE Flag
ADD CONSTRAINT `ReviewUserReference` FOREIGN KEY (`Email`) REFERENCES `User` (`Email`),
  ADD CONSTRAINT `ReviewIDReference` FOREIGN KEY (`ID`) REFERENCES `Review` (`idReview`);
ALTER TABLE Moderates
ADD CONSTRAINT `AdminCode` FOREIGN KEY (`AdminCode`) REFERENCES `AdminUser` (`AdminCode`),
  ADD CONSTRAINT `ReviewIDReference1` FOREIGN KEY (`ReviewID`) REFERENCES `Review` (`idReview`);
/* Dummy Data For AreaSubdivisions*/
INSERT INTO `nextHome`.`AreaSubdivision` (`Name`)
VALUES ('NE');
INSERT INTO `nextHome`.`AreaSubdivision` (`Name`)
VALUES ('NW');
INSERT INTO `nextHome`.`AreaSubdivision` (`Name`)
VALUES ('SW');
INSERT INTO `nextHome`.`AreaSubdivision` (`Name`)
VALUES ('SE');
INSERT INTO `nextHome`.`Realtors` (
    Website,
    PhoneNumber,
    `RealtorName`,
    `RealtorPic`
  )
VALUES (
    "realtor.ca/agent/2131632/kaitlin-metke-13120-st-albert-trail-nw-edmonton-alberta-t5l4p6",
    "780-886-4386",
    "Kaitlin Metke",
    "https://cdn.realtor.ca/individual/TS637553976600000000/highres/1384394.jpg"
  );
INSERT INTO `nextHome`.`Realtors` (
    Website,
    PhoneNumber,
    `RealtorName`,
    `RealtorPic`
  )
VALUES (
    "realtor.ca/agent/1725150/thuy-dinh-2629-kingsway-vancouver-british-columbia-v5r5h4",
    "604-773-8586",
    "Thuy Dinh",
    "https://cdn.realtor.ca/individual/TS637490202000000000/highres/1175626.jpg"
  );
INSERT INTO `nextHome`.`Realtors` (
    Website,
    PhoneNumber,
    `RealtorName`,
    `RealtorPic`
  )
VALUES (
    "cirrealty.ca/aimee_manser",
    "403-818-1546",
    "Aimee Manser",
    "https://sso.cirrealty.ca/realtorscans/CMANSEAI.jpg"
  );
INSERT INTO `nextHome`.`Realtors` (
    Website,
    PhoneNumber,
    `RealtorName`,
    `RealtorPic`
  )
VALUES (
    "sophia-klassen.c21.ca/",
    "(403) 863-7235",
    "Sophia Klassen",
    "https://i5.moxi.onl/img-pr/a/d49c6ed3-1339-4dfc-8dae-2bfdf57b5000/0_2_full.jpg"
  );
INSERT INTO `nextHome`.`Realtors` (
    Website,
    PhoneNumber,
    `RealtorName`,
    `RealtorPic`
  )
VALUES (
    "c21.ca/directory/agents/suman-brar",
    "(403) 919-9733",
    "Suman Brar",
    "https://i5.moxi.onl/img-pr/a/a243df43-7d92-4033-8c73-3d0bfcfc944d/0_1_full.jpg"
  );
INSERT INTO `nextHome`.`Realtors` (
    Website,
    PhoneNumber,
    `RealtorName`,
    `RealtorPic`
  )
VALUES (
    "remax.ca/ab/jennifer-miller-117639-ag",
    "(403) 923-7768",
    "Jennifer Miller",
    "https://remax-aphotos-papi.imgix.net/Person/100110604/MainPhoto_cropped/MainPhoto_cropped.jpg?fit=max&auto=format,compress&fm=pjpg&cs=srgb&q=75&w=2160"
  );
/* Dummy Data For Brokerages*/
INSERT INTO `nextHome`.`Brokerage` (Website, `BrokerageName`, `BrokeragePic`)
VALUES (
    "cirrealty.ca/",
    "CIR Realty",
    "https://www.cirrealty.ca/Themes/CIR-Blue/Content/images/CIR_Logo_Blue-Square_spot-p-800.jpeg"
  );
INSERT INTO `nextHome`.`Brokerage` (Website, `BrokerageName`, `BrokeragePic`)
VALUES (
    "bamberrealty.c21.ca/",
    "Century 21 Bamber",
    "https://easterseals.ab.ca/app/uploads/2019/05/century-logo.jpg"
  );
INSERT INTO `nextHome`.`Brokerage` (Website, `BrokerageName`, `BrokeragePic`)
VALUES (
    "realtor.ca",
    "Realtor",
    "https://www.realtor.ca/images/logo.svg"
  );
INSERT INTO `nextHome`.`Brokerage` (Website, `BrokerageName`, `BrokeragePic`)
VALUES (
    "remax.ca/ab/calgary-real-estate?pageNumber=1",
    "Remax",
    "https://media-exp1.licdn.com/dms/image/C4E1BAQEBN8PiPBxiYw/company-background_10000/0/1519838354578?e=2159024400&v=beta&t=IfGiR7P4g6oOu-v21aM4RIkamzKuCurthAvPxbbOyto"
  );
/* Dummy Data For Brokerages*/
INSERT INTO `nextHome`.`User` (FName, LName, Email, `Password`)
VALUES (
    "Aashirbad",
    "TheUltimateEagle",
    "aashirbadd@gmail.com",
    "cookie123"
  );
INSERT INTO `nextHome`.`User` (FName, LName, Email, `Password`)
VALUES (
    "Mikail",
    "Munir",
    "mikailmunir01@gmail.com",
    "bordgilla"
  );
INSERT INTO `nextHome`.`User` (FName, LName, Email, `Password`)
VALUES ("Test", "User", "testuser@nexthome.com", "next!");
/* Dummy Data For Admins*/
INSERT INTO `AdminUser` (
    AdminCode,
    FirstName,
    LastName,
    AdminEmail,
    `Password`
  )
VALUES (1, "Admin", "User", "admin@nexthome.com", "root");

INSERT INTO `nextHome`.`Listings` (`MLSCode`, `BasementType`, `Description`, `Price`, `SquareFootage`, `Bedrooms`, `Bathrooms`, `Address`, `AreaName`, `Email`, `BrokerageWebsite`, `RealtorWebsite`, `ImageURL`)
VALUES ('A1166045', 'Full, Unfinished', 'Coral Springs Executive Home!! 
Features include 4 bedrooms, 2.5 baths, main floor den, double attached garage,
huge kitchen, vaulted ceiling, new carpets throughout and more!! 
The main floor of this stunning home includes a large living/dining room combo,
huge kitchen with island and large pantry, breakfast island, eating area, and spacious 
family room with vaulted ceilings and huge windows. The upper level includes and large 
primary bedroom with walk-in closet, and full 5-piece en-suite bath, and 3 more bedrooms and 
another full bath! This executive home is stunning, in excellent condition and priced to sell!! 
Located in famous Coral Springs, this home will not last!', 485000, 2149, 4, 3, "146 Coral Keys Drive", "NE", 'mikailmunir01@gmail.com','realtor.ca', 'remax.ca/ab/jennifer-miller-117639-ag', "../img/146 Coral Keys Drive NE.jpeg");

INSERT INTO `nextHome`.`Listings` (`MLSCode`, `BasementType`, `Description`, `Price`, `SquareFootage`, `Bedrooms`, `Bathrooms`, `Address`, `AreaName`, `Email`, `BrokerageWebsite`, `RealtorWebsite`, `ImageURL`)
VALUES ('	A1162585', 'Finished, Full','VERY NEAT AND CLEAN HOUSE WITH 4+2 BEDROOMS 4.5 BATHS. MAIN FLOOR LIVING ROOM AND FAMILY ROOM. 
FAMILY ROOM WITH GAS FIRE PLACE.KITCHEN WITH PANTRY AND ISLAND.NOOK AREA WITH A DOOR GOING TO A HUGE DECK ON THE BACK. 
LAUNDRY AND HALF BATH ON THE MAIN LEVEL. UPPER LEVEL WITH 4 GOOD SIZE BEDROOMS 2 OF THEM ARE MASTER BEDROOMS. ONE MASTER 
BEDROOM WITH HIGH CEILING. FULLY FINISHED BASEMENT WITH 2 BEDROOMS FAMILY ROOM AND FULL BATH.DOUBLE FRONT ATTACHED GARAGE
 WITH EXTENDED DRIVEWAY FOR 4 CARS. CLOSE TO ALL THE AMENITIES LIKE SHOPPING,LRT STATION,SCHOOLS AND ON THE BUS ROUTE. VACANT 
 FOR QUICK POSSESSION. VERY EASY TO SHOW. SHOWS VERY WELL.PLS FOLLOW ALL COVID-19 RULES FROM CREB AND RECA.', 
 559900, 2030, 6, 5, "1141 Taradale Drive", "NE", 'mikailmunir01@gmail.com','realtor.ca', 'realtor.ca/agent/1725150/thuy-dinh-2629-kingsway-vancouver-british-columbia-v5r5h4', "../img/1141 Taradale Drive.jpeg");

INSERT INTO `nextHome`.`Listings` (`MLSCode`, `BasementType`, `Description`, `Price`, `SquareFootage`, `Bedrooms`, `Bathrooms`, `Address`, `AreaName`, `Email`, `BrokerageWebsite`, `RealtorWebsite`, `ImageURL`)
VALUES ('A1161569', 'Full, Unfinished','Immaculately kept stunning home with great curb appeal! 
The main level features a living room, family room and a den: so you never run out of room when 
entertaining and having a company over. Bright and welcoming living room overlooks the formal dining space; 
perfect for hosting formal dinners or for entertaining. The main living area is on the back where the kitchen, 
family room and breakfast nook are connected in an open concept. Cozy fireplace with raised hearth adds grace to the 
family room. The kitchen boasts stainless steel appliances, large centre island, quartz countertops, corner pantry,
 solid wood cabinets and drawers for the pots and pans. This level also contains a sizeable den that serves as a home 
 office or as a play room for the kids for all of their toys. The powder room and laundry are smartly tucked away in the 
 front corner. Step outside onto the well sized deck that is perfect for your patio set right under this pergola; perfect 
 for outdoor entertaining. If you are passionate about gardening, there are planters and garden shed for your gardening tools. 
 The primary bedroom upstairs, perches on the full width of this home and features its 4pc ensuite including separate shower 
 and soaker tub as well as an ample walk-in closet. Then we find 3 well-sized bedrooms and a 4pc bathroom. Last but not 
 least is the spacious loft offering an extra space for the whole family. The basement is unfinished with lots of potential.', 
 599900, 2344, 4, 3, "288 Saddlecrest Way", "NE", 'mikailmunir01@gmail.com','cirrealty.ca/', 'cirrealty.ca/aimee_manser', "../img/288 Saddlecrest Way.jpeg");

INSERT INTO `nextHome`.`Listings` (`MLSCode`, `BasementType`, `Description`, `Price`, `SquareFootage`, `Bedrooms`, `Bathrooms`, `Address`, `AreaName`, `Email`, `BrokerageWebsite`, `RealtorWebsite`, `ImageURL`)
VALUES ('A1131234', "Full, Unfinished", "Are you ready to be completely wowed from start to finish? 
Your new home located in the community of Monterey Park awaits you. This affordable and attractive 
two storey home is fully finished and features a double garage located on a quiet cul-de-sac. 
With almost 4000 square feet of developed space this could be the home of your dreams! Open and 
bright main floor boasts 9 ceilings, beautiful Brazilian Tigerwood hardwood flooring, and elegant light fixtures. 
As you enter you will notice the spacious and bright formal living and dining area. The kitchen is the heart of this 
home and features gorgeous cabinets, granite countertops, stainless steel appliances, stunning island, and a walkthrough pantry. 
Island eating and sunny dining area make this a wonderful space for entertaining friends or large family gatherings. 
The family room is gorgeous with built-in wall units, skylights and many windows looking out to the backyard. 
Open the patio door to access your spacious deck with glass railing. A fantastic outdoor space to unwind and enjoy the sun. 
Convenient main floor laundry and office space. Upstairs everyone will love hanging out in the sunny foyer with vaulted ceilings.
 Relax in your primary bedroom with spa like 5-piece ensuite and large walk-in closet with built-in storage. 
 There are two additional generous bedrooms with built-ins and a 5-piece main bathroom. Developed walk-out basement 
 with recreational space is ideal for watching movies or the big game. Option to have another room downstairs. 
 Enjoy an indoor hot tub and a spacious bathroom with steam room. Additional features include built-in speakers 
 throughout the house, French doors, gazebo on the balcony, huge storage room in the basement and a freshly painted interior. 
 You will love spending time in this amazing backyard that backs onto greenspace. Watch the kids play on their swing set from 
 the covered lower-level patio. Landscaped sunny yard with garden space and private access to public paths and green space. 
 Great neighborhood close to many shops, schools and easy access to both Stoney & Deerfoot Trails. 
 Don't let this stunning home get away!", 
 794000, 2655, 3, 4, "232 California Place", "NE", 'mikailmunir01@gmail.com','cirrealty.ca/', 'cirrealty.ca/aimee_manser', "../img/232 California Place.jpeg");

INSERT INTO `nextHome`.`Listings` (`MLSCode`, `BasementType`, `Description`, `Price`, `SquareFootage`, `Bedrooms`, `Bathrooms`, `Address`, `AreaName`, `Email`, `BrokerageWebsite`, `RealtorWebsite`, `ImageURL`)
VALUES ('A1165568', "Full, Walkout", "The One You Have Been Waiting For JUST LISTED 
A True DREAM HOME situated on a Beautiful street of MARTINDALE. 
Only FEW STEPS from MARTIN CROSSING SCHOOL, CLOSE to ALL Amenities
 including TWO LRT STATIONS, BUS STOPS, GENESIS CENTER, SUPERSTORES, 
 Shopping's, Banks, airport and Many more. This 2 Storey Home has it ALL to offer : 
 Comes with DOUBLE CAR GARAGE, Beautiful FRONT VERANDA, FULLY DEVELOPED BASEMENT, FULLY FENCED YARDS, 3 BATHROOMS, 
 New Roof and more. It's ONE OF A KIND ! A tremendous Place for you and your family to call HOME. 
 Very Spacious Living Room with BAY WINDOW, Huge Kitchen w/ NOOK and Dining area. 
 Upstairs offers: Spacious Master Bedroom with Bay window and good size 2 bedrooms. 
 Truly pleasure to VIEW ANYTIME, Do not hesitate to make this home yours, it will not be on the market for long !!!", 
 369700, 1250, 3, 3, "38 Martinridge Crescent", "NE", 'mikailmunir01@gmail.com','bamberrealty.c21.ca/', 'c21.ca/directory/agents/suman-brar', "../img/38 Martinridge Crescent.jpeg");

INSERT INTO `nextHome`.`Listings` (`MLSCode`, `BasementType`, `Description`, `Price`, `SquareFootage`, `Bedrooms`, `Bathrooms`, `Address`, `AreaName`, `Email`, `BrokerageWebsite`, `RealtorWebsite`, `ImageURL`)
VALUES ('A1165352', "Full, Unfinished", "A 2015 built, open concept house in the very convenient neighborhood of Cityscape NE. 
To start off, one is welcomed by the very spacious kitchen which is a chefs dram considering it's the best for hosting and 
is laid out in an excellent manner. The dining room is also a homeowners dream as it has a massive window great for letting 
in those sun rays and refreshing air (on the warmer days). Although the dining room and kitchen are very open the living room, 
provides one with a very warm and cozy vibe with the excellent color palette and two perfectly sized windows for just the right 
amount of light. The upper floor, has 3 greatly sized rooms along with 2 and a half bathrooms of which one is an in-suited in 
the master bedroom which also has a walk in closet. The laundry is also located on the upper floor; a very convenient feature 
saving time and energy for long hauls of laundry. Most importantly, the basement of the house is partially made without a 
separate entrance which in the future if developed could act as being very beneficial for it's new owners. Moving towards 
the exterior, the house has a detached garage at the back along with a concrete pad which leads to a back alley.", 
 530000, 2530, 3, 3, "126 CITYSCAPE Terrace", "NE", 'mikailmunir01@gmail.com','bamberrealty.c21.ca/', 'sophia-klassen.c21.ca/', "../img/126 CITYSCAPE Terrace.jpeg");


INSERT INTO `nextHome`.`Listings` (MLSCode, BasementType, Description, Price, SquareFootage, Bedrooms, Bathrooms,
Address, AreaName, Email, BrokerageWebsite, RealtorWebsite, ImageURL)
VALUES("A1165628", "Finished", "PRIME location on this home in the family friendly community of Auburn Bay! Literally 2 min walk to the lake that you can enjoy year round and a short drive to all of the areas amenities that include the YMCA, VIP theatre, restaurants, shops, pubs, shopping, schools, transit and the hospital! This 3 bedroom up/1 bedroom down home has an open floor plan, functional space and a fully finished basement. As you enter you have a nice flow to the house, large living room area that leads through to the dining area, a kitchen that features granite countertops, stainless steel appliances, beautiful tiled backsplash, plenty of counter and cabinet space and a corner pantry. The main floor also has a main floor den area, half bath and mudroom that leads to the garage! Upstairs has a great bonus room, a primary bedroom with a walk in closet and a full ensuite bathroom with dual sinks. Two more additional bedrooms and another full bathroom for the kids and upper level laundry for your convenience! The basement level is finished with another bedroom, full bathroom and a fabulous rec room area! Outside you will love the large deck, yard space and the underground sprinkler system. So much to love about this house in one of Calgary's premier lake communities! Don't miss this one :)",
625000, 2130, 4, 4, "106 Auburn Shores Crescent", "SE", "aashirbadd@gmail.com", "remax.ca/ab/calgary-real-estate?pageNumber=1",
"c21.ca/directory/agents/suman-brar",
"../img/106AubernShores.jpeg");