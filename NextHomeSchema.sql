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
  `ReviewDate` varchar(45) DEFAULT NULL,
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
    "Jeff",
    "Smith",
    "jeffsmith@gmail.com",
    "jeffrey"
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

INSERT INTO `nextHome`.`Listings` (
MLSCode,
BasementType,
Description,
Price,
SquareFootage,
Bedrooms,
Bathrooms,
Address,
AreaName,
Email,
BrokerageWebsite,
RealtorWebsite,
ImageURL
)
VALUES(
"A1166195",
"Finished",
"Two storey home back to playground, located in Cul de sec in Cougar Ridge! This bright and inviting family-friendly layout with tasteful upgrades throughout. The main floor features an open concept which includes a large separate office, a bright great room, a functional kitchen with granite counter top, a dining nook that opens directly onto your huge sunny deck and look into the playground. Upstairs you will find a large bonus room that is separated from the three good-sized bedrooms. The master, which has direct views of the green space, boasts a large ensuite complete with double sinks and a jetted tub. The developed basement has enlarged windows making the whole area feel brighter and more of an extension of the home. The fourth bedroom and a full bathroom grace this area, as well as a fantastic family area for movie nights. Situated on a private cul-de-sac within walking distance to schools, shopping, restaurants, and a short commute to downtown or the mountains, and winsport for ski within the city limit!",
658000,
1960,
4,
3,
"226 Cougarstone Gardens",
"SW",
"aashirbadd@gmail.com",
"realtor.ca",
"sophia-klassen.c21.ca/",
"/img/swHouse6.jpeg"
);

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

INSERT INTO `nextHome`.`Listings` (
MLSCode,
BasementType,
Description,
Price,
SquareFootage,
Bedrooms,
Bathrooms,
Address,
AreaName,
Email,
BrokerageWebsite,
RealtorWebsite,
ImageURL
)
VALUES(
"A1165383",
"Full, Unfinished",
"Welcome home to this beautiful and well maintained home in one of the best complexes in Citadel. When you enter the spacious home, you will notice the bright and open floor plan on this corner unit with numerous windows. The main floor begins with a spacious foyer that leads to a large dining area that is perfect for entertaining. The kitchen is very functional with lots of cabinets, ample counter space and stainless steel appliances. The great room features a stunning gas fireplace and large windows + garden doors that lead to a wooden deck, garden and huge common area green space. Upstairs boasts a large master bedroom with Ensuite. There are two more spacious bedrooms and an additional 4-piece bath. You also have the convenience of your own single attached garage. The basement is awaiting your personal touch. The home is located in a prime neighborhood, close to transit, shopping and great schools. This well cared for home shows pride of ownership throughout. The Condo is well managed with many long time owners and great neighbors. Book your showing today, this is the one you have been waiting for!",
324000,
1372,
3,
3,
"703 Citadel Terrace",
"NW",
"mikailmunir01@gmail.com",
"remax.ca/ab/calgary-real-estate?pageNumber=1",
"remax.ca/ab/jennifer-miller-117639-ag",
"../img/703 Citadel Terrace.jpeg"
);


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

INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1154016",
    "Unfinished",
	"Bungalow Finished in 2021 and located in one of Calgary’s nicest lake communities, Mahogany. This home offers lake privileges, solar power, a double attached heated garage with built-in electric car charging and a 220-volt outlet plug (with 30-amp breaker). Open-concept layout, with 9-foot ceilings. Kitchen features stainless steal appliances, granite countertops, filtered water drinking faucet, corner pantry, and a kitchen island with eat-in bar. Spacious main-floor master bedroom features a 4pc en-suite with double vanities and walk-in shower, as well as a large walk-in closet with built-in organizers and laundry for your convenience. The 9-foot ceilings carry through to the fully developed basement with a large rec room, 2 good-sized bedrooms, a 3pc bathroom, flex room, and storage. Newly sodded front and back yard, sunny backyard deck wired with a BBQ gas-line. Other features of this home include smart home tech solutions, and centralized air-conditioning system. Enjoy living in the spectacular community of Mahogany, with access to Mahogany Lake, Splash Park, Tennis Courts, trails, and more! Located close to all amenities, transit, the South Campus hospital, and Seton YMCA.",
    619000,
    1502,
    3,
    3,
    "94 Magnolia Terrace",
    "SE",
    "aashirbadd@gmail.com",
    "cirrealty.ca/",
    "realtor.ca/agent/1725150/thuy-dinh-2629-kingsway-vancouver-british-columbia-v5r5h4",
    "/img/seHouse5.jpeg"
  );

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

INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1165628",
    "Finished",
    "PRIME location on this home in the family friendly community of Auburn Bay! Literally 2 min walk to the lake that you can enjoy year round and a short drive to all of the areas amenities that include the YMCA, VIP theatre, restaurants, shops, pubs, shopping, schools, transit and the hospital! This 3 bedroom up/1 bedroom down home has an open floor plan, functional space and a fully finished basement. As you enter you have a nice flow to the house, large living room area that leads through to the dining area, a kitchen that features granite countertops, stainless steel appliances, beautiful tiled backsplash, plenty of counter and cabinet space and a corner pantry. The main floor also has a main floor den area, half bath and mudroom that leads to the garage! Upstairs has a great bonus room, a primary bedroom with a walk in closet and a full ensuite bathroom with dual sinks. Two more additional bedrooms and another full bathroom for the kids and upper level laundry for your convenience! The basement level is finished with another bedroom, full bathroom and a fabulous rec room area! Outside you will love the large deck, yard space and the underground sprinkler system. So much to love about this house in one of Calgary's premier lake communities! Don't miss this one :)",
    625000,
    2130,
    4,
    4,
    "106 Auburn Shores Crescent",
    "SE",
    "aashirbadd@gmail.com",
    "remax.ca/ab/calgary-real-estate?pageNumber=1",
    "c21.ca/directory/agents/suman-brar",
    "../img/seHouse1.jpeg"
  );

  INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1164556",
    "Finished, Full",
"Welcome to this well kept and beautifully upgraded home in Reunion close to many amenities and parks!! Main floor has a bright and open concept floor plan with 9ft knockdown ceilings, wide west facing windows letting in lots of natural light. This home has a modern look and feel with high quality materials, upgraded light fixtures and modern color scheme . On entry you are greeted with an open entryway and a good size sitting room/den to the right, moving to the back there is half washroom to the left, a fully upgraded kitchen with floor to ceiling cabinets , quartz countertops, Upgraded Samsung Appliances, a large corner pantry, another good size closet and a huge center island to entertain your guests. A bright and open concept dining and living room complete this floor. Moving up is an open staircase leading to a beautiful Primary Bedroom on the left complete with walk in closet and 4pc en-suite with Dual Vanities. There are two more good size bedrooms and another full washroom on this floor. Upstairs Laundry for added convenience. Downstairs is fully finished basement with another good size bedroom, a huge living room and another full washroom, basement is already roughed in for full kitchen and can be easily converted to a Suite with income potential. This home is in like new condition, huge backyard with wood patio, an oversized concrete parking pad already poured.",
    459900,
    1567,
    4,
    4,
    "68 Reunion Loop",
    "NW",
    "mikailmunir01@gmail.com",
    "remax.ca/ab/calgary-real-estate?pageNumber=1",
    "remax.ca/ab/jennifer-miller-117639-ag",
    "../img/68 Reunion Loop.jpeg"
  );
  
  INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1166117",
    "Unfinished",
	"Welcome to this STUNNING 2014 built 2 Storey home in a large lot that backs on to GREEN SPACE, in the pristine community of Copperfield. It's a gorgeous two story house with walkout basement and 2585 SQFT of breathtaking living space including 4 bedrooms, 2.5 bathrooms, a living room, a family room with huge windows, a formal dining area, and kitchen with beautiful backsplash, stainless steel appliances, and a huge center island .The main floor is completed with a 2-PC bathroom, laundry room, living room and a family room with a beautiful fireplace to make you feel cozy. On the second floor, you will find a huge bonus room with BALCONY , the primary bedroom with 4-piece en-suite bathroom and large closet, 3 another good size bedrooms and 4 piece bathroom. 9 FEET ceiling on each level. Also includes double Furnace and double AC units. Brand New roof. This home is close to walkways, schools, public transit and a short drive to all major amenities. Don’t miss out on this exclusive and rare opportunity to call this dreamy home yours!",
    685000,
    2585,
    4,
    2,
    "119 Copperpond Cove",
    "SE",
    "aashirbadd@gmail.com",
    "remax.ca/ab/calgary-real-estate?pageNumber=1",
    "sophia-klassen.c21.ca/",
    "/img/seHouse2.jpeg"
  );

INSERT INTO `nextHome`.`Listings` (
MLSCode,
BasementType,
Description,
Price,
SquareFootage,
Bedrooms,
Bathrooms,
Address,
AreaName,
Email,
BrokerageWebsite,
RealtorWebsite,
ImageURL
)
VALUES(
"A1166125",
"Full, Finished",
"Watch this one like a Hawk!119 Hawkmount Green NWThis one will sell because its pretty amazing.Is this the property for you? It could be if you love a home that is bright, beautiful, andwonderfully spacious. Well talk about that backyard later. Hawkwood in the NW is very soughtafter and on everyones checklist. Why? Because its close to everything. This description is justthe beginning.What about the house itself? First of all, this home is immaculate. It is in exceptional condition.The current owners love this home, and it shows. Built in 1992, this home oozes warmth andcoziness amidst sweeping light and a spacious spread. The house defines a living expanse.It has four bedrooms and three baths and is styled as a 3-level split with a large crawl space/storage. It has everything for your family, including a fully developed basement, massive crawl space and a balcony that spills (indoor/outdoor living) over some shaded pines and poplars. The photos do speak forthemselves. The fenced-in backyard is considerably large (very rare now in Calgary), so you cancheck this off your list if you have pets or kids. Newer developments are just not giving familiesthe space they need outside. The front is sprinkled with 30-year-old pines and shrubbery, givingit character and establishment. The neighborhood is safe, beautifully developed and ultimately ideally located. This property has an incredible palette that will allow a new homeowner to leave it as is ortransform it to the colors and styles they want. It is a canvas waiting for your artistic touch.There is considerable value in a place that does not need renovations. Its even more challenging to execute a home stylistically that is just as relevant today as in 1992. What about that location?Located between Arbour Lake and Edgemont, Hawkwood in the NW is one of Calgarys top realestate areas. There are dozens of parks around, and Its only 1.5 km to Crowfoot Crossing(Cineplex Odeon, Indigo, Safeway, Sh oppers Drug Mart, the Keg etc.) A little further is CrowfootLRT station, which takes you right downtown or to the University of Calgary. The area has multiple schools to choose from and various religious places of worship. At the end of the day location does matter. Hawkwood allows whoever lives there to experience a great area while being just a heartbeat away from amenities, downtown and, of course  the mountains.Have a look at the property specs below and see why living in Hawkwood is in your future.",
489900,
1407,
3,
3,
"119 Hawkmount Green",
"NW",
"mikailmunir01@gmail.com",
"remax.ca/ab/calgary-real-estate?pageNumber=1",
"remax.ca/ab/jennifer-miller-117639-ag",
"../img/703 Citadel Terrace.jpeg"
);

  
  INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1158707",
    "Finished",
	"Unbelievable opportunity to own this stunningly upgraded family style house located on a kid friendly cul-de-sac. With over 3100 sq ft of developed living area this home features a bright & open main floor design. Enjoy the functional kitchen with a large island, corner pantry, granite counter tops & SS appliances including gas range (Kitchen Aid). The spacious nook overlooks the great room with a beautiful stone face NG fireplace making this an ideal place to entertain friends & family. All opening onto a deck an mature yard.The dining room area is beyond written description. Never has a room been better utilized, complete with custom built-ins. The upper level features 3 bedrooms, including a large master with 5pcs ensuite. Laundry room is ideally located here as well as a bonus room.  The lower level is completely developed. This area is ideal to watch the big game or just hang out. Also featured on this level is a bar, bathroom and 4th bedroom(no window). Lets not forget ample good storage area..The backyard is OUTSTANDING. There are multiple spaces to relax and enjoy this massive oversized lot which features a deck, stamped concrete patio, hot tub & putting green.  Here are some of the great upgraded features this house also offers: sprinkler system, AC, GEM lights, newer hot water tank, gleaming hardwood floors & great curb appeal with stucco exterior. Pride of ownership is evident everywhere. With this property no work is required, just move in and start enjoying this great house in the great neighbourhood of Cranston. Shows 10/10",
    629000,
    2220,
    4,
    3,
    "177 Cranleigh Bay",
    "SE",
    "aashirbadd@gmail.com",
    "remax.ca/ab/calgary-real-estate?pageNumber=1",
    "sophia-klassen.c21.ca/",
    "/img/seHouse3.jpeg"
  );
  
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


  INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1158076",
    "Finished",
	"Welcome to this beautiful two storey estate home built by Shane Homes and backing onto the Douglasdale Golf Course. It has been immaculately maintained for the last 24 years by a single owner. Entering the home you will find a grand entrance with a beautiful staircase, 9 ft. ceilings, new tile floor and new carpet. The massive main floor includes a good-size office, formal dining area and two living spaces, as well as a bright kitchen with granite counter tops and newer backsplash. The living room has an updated fireplace and a great view of the 9th hole fairway. This house has lots of natural light with a functional layout for family-living and entertaining friends. The second story has a total of four bedrooms, three have built-in desks in front of large windows. The large master bedroom includes a 5 pc ensuite and his and hers walk in closet. The finished walkout basement is bright and spacious with a huge flex area, bar, bedroom and another bathroom. There is also a large storage room and more storage in utility room. The back of the home faces west so you get to enjoy the sun setting over the golf course and mountains. The house has newer air conditioning and a newer roof.",
    689000,
    2323,
    5,
    4,
    "194 Douglas Woods Hill",
    "SE",
    "aashirbadd@gmail.com",
    "cirrealty.ca/",
    "realtor.ca/agent/2131632/kaitlin-metke-13120-st-albert-trail-nw-edmonton-alberta-t5l4p6",
    "/img/seHouse4.jpeg"
  );
  
INSERT INTO `nextHome`.`Listings` (
MLSCode,
BasementType,
Description,
Price,
SquareFootage,
Bedrooms,
Bathrooms,
Address,
AreaName,
Email,
BrokerageWebsite,
RealtorWebsite,
ImageURL
)
VALUES(
"A1163527",
"Finished",
"Great cul de sac location and exceptionally well maintained bi-level nested in the prestigious community of signal hill, A safe place for kids and dog to play. Total of 3 bedrooms +3 bathrooms and over 2500 sq ft living space. Very bright and open plan. Vaulted ceiling in Formal living room, large dining room, hardwood throughout main level. Bright kitchen with countertops open to large eating area and great room with gas insert fireplace. French door leading out to large deck with stairs to yard. Main floor has 2 bedrooms/2 bathrooms including the SPACIOUS MASTER with walk-in closet + 4PC ensuite. Developed basement with large recreation and games room, one bedroom, a 4-piece bath and a handy workshop. double attached garage insulated and drywalled. Sprinkler system. This house is really pride of ownership. Walking distance to Westhills Shopping Centre, & local schools. Arrange your showing today!",
659900,
1553,
3,
3,
"727 Sierra Morena Place",
"SW",
"aashirbadd@gmail.com",
"realtor.ca",
"realtor.ca/agent/2131632/kaitlin-metke-13120-st-albert-trail-nw-edmonton-alberta-t5l4p6",
"/img/swHouse5.jpeg"
);

  
  INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1147635",
    "Finished",
	"Amazing home for a large and/or growing family with great room sizes throughout! Open plan with 9 foot ceilings. Corner lot on keyhole cul-de-sac across to park and pathway system. The home's exposure provides sunlight from start to finish every day. Truly a very bright, warm, friendly family home. Bonus room could easily be converted to 2 more bedrooms. Bright, sunny main floor den. Flat, pie shaped, kid friendly back yard. Underground sprinkler system & lushious green grass. Spacious kitchen with corner pantry, lots of warm oak cabinetry and large work island. Newer, super high end appliances! Induction stove with convection oven. Reverse osmosis water system plumbed to a kitchen sink faucet and the fridge. Family sized dining area! Central air conditioning. central vacuum, Merv 16, hospital grade furnace filters (an amazing difference with all the smoke this summer!) One of an allergy sufferer's best friends. Beautiful hardwood floors. Upgraded humidifiers, Ecobee smart thermostats, Cat 5 wiring, LED lighting, dimmer switches, timers on bathroom fans, garburator, wired for security. 10' x 10' shed finished to match the house with tire storage rack and Proslat organization wall. Fully finished, heated garage with built-in cabinets, lots of plugs including for your electric car, great lighting and a Proslat wall. Lots of parking. This beautiful family home is one of the largest in family friendly Copperfield giving you excellent value per square foot! And you have a whole basement to develop if you need more space. CHECK OUT THE 3-D TOUR! Don't wait, call today!",
    649000,
    2767,
    3,
    3,
    "2 Copperfield View",
    "SE",
    "aashirbadd@gmail.com",
    "cirrealty.ca/",
    "realtor.ca/agent/1725150/thuy-dinh-2629-kingsway-vancouver-british-columbia-v5r5h4",
    "/img/seHouse7.jpeg"
  );
  
  
  INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1165895",
    "Finished",
	"Welcome to this fully renovated, upgraded two-story home, built by Master built Morrison Homes. The main floor features a gourmet kitchen w/ granite counters, top-of-the-line new SS appliance package, tiled backsplash, upgraded lighting (pots/pendants). Cabinets that are freshly painted by professionals and extended to the ceiling, and a walk-through pantry to the garage entrance. Also on the main floor, you will find a front dining room ( or can be a family room), a sunny breakfast nook w/ patio doors that access the deck, and a very bright great room w/ large windows and soaring ceilings open to the 2nd level. Brand new LVP on all main and second floor. Upstairs you will find a huge bonus room, full bathroom, and 3 bedrooms, including a master retreat with a walk-in closet and ensuite bathroom (air jetted tub & separate shower). The basement is fully finished with a 4th bedroom, full bathroom, and a media room complete with a home theatre system, upgraded lighting, and built-in speakers. Also, the entire house has built-in speakers. Outside, enjoy the massive two-level deck to spend the entire summer with as many as friends and family. Located just down the path from the kids' park. Close to Calgary Waldorf School, Cougarstone Park, and Calgary French & International School",
    674000,
    1996,
    4,
    3,
    "71 Cougarstone Court",
    "SW",
    "aashirbadd@gmail.com",
    "cirrealty.ca/",
    "c21.ca/directory/agents/suman-brar",
    "/img/swHouse1.jpeg"
  );
  
    INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1164303",
    "Finished",
	"Westside Gem!! Amazing house in an equally amazing neighbourhood! This bright, open 2 story home offers lifestyle, location, quiet living and all the space a busy family needs. The main floor is bright and open with light pouring in from the SE backyard. Your family and friends will enjoy the open kitchen, living and dining room space. Whether it's a cozy morning coffee on the quiet deck or a fun pot luck dinner with appies on your sit up kitchen island. There is space for everyone to make wonderful memories. Even more impressive is the newly renovated kitchen with beautiful quartz countertops, modern cabinets and hardware and luxury vinyl plank flooring throughout the main floor. Completing this level is a private 1/2 bath for guests and a main floor laundry area. As you move up the the second level, you will be immediately impressed by the large bonus room with vaulted ceilings. So many possibilities for the family to use whether it's a work out area, theatre room, office, yoga space.....the options are as limited as your imagination. There are also 3 ample sized bedrooms & a 4 piece bathroom with the primary bedroom having its own private ensuite and walk-in closet. As you move to the basement, you will enjoy how bright the walk-out level is and open concept developed area. It can be a large bedroom suite with its own entrance, a rec room, a play area; so many possibilities. There is also a modern 3 piece bathroom and loads of storage off the utility room. The yard is beautifully landscaped offering many perennials, raised garden beds and peaceful spaces to relax and enjoy the quietness the location offers. There is also a convenient staircase from the upper deck to the yard. This home has been well cared for with many upgrades over the years: roof & shingles replaced approx 7 years ago, basement developed in 2014, main floor kitchen and flooring in 2020, new paint, hot water tank replaced in 2021 and air conditioning for the warm summers. Nest smoke detectors throughout. Springborough is a sought-after westside neighbourhood due to its amazing location which is walkable to schools from k-12 (Griffith Woods, Ernest Manning), Ambrose College, Westside Rec, the west LRT and a quick drive to shopping at both Aspen Landing and Westhills. With Stoney Trail opening, you are now a quick drive to anywhere you need to go including easy access to Highway 1 to the mountains. Book your showing today before this amazing and rare Westside walk-out home is gone!",
    699000,
    1664,
    3,
    4,
    "137 Springborough Way",
    "SW",
    "aashirbadd@gmail.com",
    "cirrealty.ca/",
    "c21.ca/directory/agents/suman-brar",
    "/img/swHouse2.jpeg"
  );

INSERT INTO `nextHome`.`Listings` (
MLSCode,
BasementType,
Description,
Price,
SquareFootage,
Bedrooms,
Bathrooms,
Address,
AreaName,
Email,
BrokerageWebsite,
RealtorWebsite,
ImageURL
)
VALUES(
"A1165512",
"Full, Finished",
"The House sold 'AS-IS' condition. Land Use:R-C2 . 60 X 100 foot Lot. Carpet over hardwood throughout except for kitchen and bathroom on main floor. Fresh wall painting on main floor. New windows on main floor except the living room big window. Vinyl siding with metal cladding around windows, metal Facia & Soffits. Upgraded electrical panel in 1984 to 125 amp. Upgraded front and back doors. Garage is double wide but only has a single door. Lean-to shed on one side of garage for plenty of storage. Great community and location..close to everything. Call today for viewing!",
439000,
894,
2,
2,
"527 Northmount Drive",
"NW",
"mikailmunir01@gmail.com",
"remax.ca/ab/calgary-real-estate?pageNumber=1",
"remax.ca/ab/jennifer-miller-117639-ag",
"../img/527 Northmount Drive.jpeg"
);


INSERT INTO `nextHome`.`Listings` (
    MLSCode,
    BasementType,
    Description,
    Price,
    SquareFootage,
    Bedrooms,
    Bathrooms,
    Address,
    AreaName,
    Email,
    BrokerageWebsite,
    RealtorWebsite,
    ImageURL
  )
VALUES(
    "A1166791",
    "Finished, Full",
"Welcome to this beautiful & immaculate home in Evanston offering a large pie shaped lot, oversized double garage w/ keyless entry, attic space & 40amp subpanel as well as amazing landscaping throughout w/ plenty of green space, patio, 2 tiered deck with gazebo, gardens & more! Features: granite counters, 9ft ceilings, wifi thermostat control & laminate flooring. Main floor offers spacious entry next to bedroom with great lighting, gorgeous 3pc bath, stunning kitchen w/ S.S appliances, centre island & extended charging station. Adjacent you will find dining area & living room w/ big window for added sunlight. Upstairs features big primary bedroom w/ walk-in closet & 4pc ensuite situated next to Den & has 2 more good size bedrooms, 4pc bath & ample size laundry room for your convenience. Basement is partially finished & bedroom & family room & awaits more of your creative ideas! (25057949)", 
570000,    
1812 ,
    4,
    3,
    "118 Evanscrest Road",
    "NW",
    "mikailmunir01@gmail.com",
    "cirrealty.ca/",
    "c21.ca/directory/agents/suman-brar",
    "/img/118 Evanscrest Road.jpeg"
  );


INSERT INTO `nextHome`.`Listings` (
MLSCode,
BasementType,
Description,
Price,
SquareFootage,
Bedrooms,
Bathrooms,
Address,
AreaName,
Email,
BrokerageWebsite,
RealtorWebsite,
ImageURL
)
VALUES(
"A1162923",
"Finished",
"Welcome to this fabulous FORMER SHOWHOME in Crestmont! . This 2333sq.ftSTUNNING interior architecture, finished with HIGH END features include PRISTINE HARDWOOD flooring, 9' ceilings, TILE entryway with built-in seating, open staircase with wrought iron & maple railings, TWO-STOREY living room surrounded by windows, gorgeous stone gas fireplace. CHEF'S kitchen with dark MAPLE cabinets, GRANITE countertops, and garburator. LARGE CENTER ISLAND with breakfast bar, BUTLER'S PANTRY, SUNNY breakfast nook, FORMAL dining room with recessed ceiling / main den. SECOND LEVEL BONUS room overlooking great room, two bedrooms & MASTER RETREAT with 5 pc ENSUITE, TRAVERTINE floors, SKYLIGHT, JETTED TUB, OVERSIZED shower. CENTRAL AIR, built-in speakers on both levels. The basement is finished professionally . The basement offers your a large entertainment room with full bathroom and bedroom. Professionally landscaped w/ SUNNY SOUTH FACING fenced backyard, LARGE DECK and underground sprinkler system. Heated finished garage and Nu-air ventilation system. Short walk to community center and park plus quick access to COP, shopping and the mountains.",
699900,
2373,
4,
3,
"12481 Crestmont Boulevard",
"SW",
"aashirbadd@gmail.com",
"realtor.ca",
"realtor.ca/agent/2131632/kaitlin-metke-13120-st-albert-trail-nw-edmonton-alberta-t5l4p6",
"/img/swHouse3.jpeg"
);



INSERT INTO `nextHome`.`Listings` (
MLSCode,
BasementType,
Description,
Price,
SquareFootage,
Bedrooms,
Bathrooms,
Address,
AreaName,
Email,
BrokerageWebsite,
RealtorWebsite,
ImageURL
)
VALUES(
"A1145084",
"Finished",
"WELCOME HOME! Incredible opportunity to own this beautiful 2-Storey, fully finished WALKOUT in the sought-after community of Signal Hill. The elegant entrance welcomes you with a high ceiling, NEWLY PAINTED walls leading you to a bright, beautiful living room, formal dining area and the kitchen equipped with BRAND NEW Stainless Steel APPLIANCES and freshly painted cabinets. The Main Floor also offers a den, perfect for an office space for those working from home. You and your family will enjoy idyllic sunsets and views of the snow-capped Rockies in the winter months from the balcony just outside the kitchen door. The beautiful stairway leads you to a huge bonus room with vaulted ceiling and a fireplace that is perfect for family gatherings. As you make your way to the upper level, you will find a convenient laundry, a bathroom, 3 bedrooms, with the primary bedroom featuring an en-suite and a walk-in closet. The walk out level boasts an additional bedroom, a full bath and a recreational room with a quick access to the lower-level patio and the backyard. Only minutes from schools, playgrounds, recreation centre, c-train station, shopping, easy access to major highways and just minutes drive to downtown, your future home awaits you. Don’t miss this opportunity. Call your favourite Realtor to book a showing today!",
638800,
2023,
4,
3,
"319 Sierra Nevada Place",
"SW",
"aashirbadd@gmail.com",
"realtor.ca",
"realtor.ca/agent/2131632/kaitlin-metke-13120-st-albert-trail-nw-edmonton-alberta-t5l4p6",
"/img/swHouse4.jpeg"
);

INSERT INTO `nextHome`.`Listings` (
MLSCode,
BasementType,
Description,
Price,
SquareFootage,
Bedrooms,
Bathrooms,
Address,
AreaName,
Email,
BrokerageWebsite,
RealtorWebsite,
ImageURL
)
VALUES(
"A1166049",
"Finished, Full",
"A location to delight the entire family!! The budding soccer and baseball stars in your family will love backing onto so many sports fields. Just steps beyond the back gate they can enjoy playing with their buddies in the 'largest back yard ever'. The adults will enjoy backing onto green space and the expansive mountain views beyond the fields. This gorgeous two-story home offers hard-to-find 4 bedrooms up and a triple car garage. Step inside to the spacious entry graced by a curving staircase and a wall-mounted water feature. Off the foyer is a conveniently located den with a door that makes an ideal quiet space for working from home. 'Wow!' will be your first thought as you look towards the open concept living area at the back of the home. There is so much to impress - quality finishing, high ceilings, gorgeous hardwood floors, and the over $100,000 spent on lighting upgrades throughout the home. The great room features gorgeous lighting and a contemporary-style fireplace flanked by modern floating shelving. Enjoy the amazing panoramic green space and mountain views while relaxing in the great room or when sharing meals in the adjoining central dining space. The show-stopper kitchen features a large tiered island with seating, beautiful granite counters, and lovely backsplash, a 4-burner plus griddle gas cooktop, two stacking Thermidor wall ovens, a Miele coffee maker, and a spacious walk through pantry. Enjoy an intimate dinner in the flex space/dining room, with a built-in hutch, that is tucked next to the great room. This flexible space can be easily adapted to meet your family's changing needs and could be used as a music room, study, or reading nook. A pretty powder room with stylish wallpaper and a huge mudroom with built-in cabinets and seating complete this level. Head up the curving staircase to the upper level featuring a beautiful bonus room that offers a 2nd fireplace, built-ins, and a dramatic ceiling treatment. There are 4 bedrooms up including the master retreat. Two bedrooms share a jack and jill bathroom - one is larger and has a walk-in closet. The 3rd bedroom is steps away from the 3-piece family bathroom with a shower. A remarkable master retreat features a private balcony with wonderful views, a huge walk-in closet, and a spa-like ensuite. Enjoy recharging in the ensuite steam shower or jetted tub, and preparing for your day at the long vanity offering dual sinks with an enormous mirror above. The basement is designed for family time and entertaining with a huge rec room that features a wet bar and a stone feature wall. Wine lovers will appreciate the custom wine cellar to store their favorite bottles! A huge 5th bedroom with a walk-in closet is perfect for when family or friends come to visit. The 3-piece basement bathroom has a shower. Imagine all the fun, and sports your family can play, just outside your back door!", 
700000,
3000,
5,
5,
"53 Rockyvale Green",
"NW",
"mikailmunir01@gmail.com",
"remax.ca/ab/calgary-real-estate?pageNumber=1",
"remax.ca/ab/jennifer-miller-117639-ag",
"../img/53 Rockyvale Green.jpeg"
);


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


INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("mikailmunir01@gmail.com", "Don’t let those industrial buildings fool you, you’ll open doors to amazing thrills only found in the North East! Tap into your inner Viking at BATL: Axe Throwing or experience the biggest indoor inflatable park in North America at Big Fun Play Centre with mazes, castles and more for all ages! ",
'Dec 12, 2021, 1:45PM', 0, "NE", 
"Industrial Park of Unexpected Thrills", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "WinSport & Canada Olympic Park gained global fame during the 1988 Winter Olympics and is now a home-grown icon to visitors and locals alike. This attraction has many summer & winter activities for the whole family to enjoy, and makes a great day out filled with adventure for friends, regardless of the season!

Also located in the North West is Western Canada's Largest Amusement Park, and one of the most exciting Calgary attractions – Calaway Park! Experience Western Canada’s largest outdoor family friendly, fun-filled amusement park, offering 32+ rides, treats, games and hours of entertainment for all ages. The park also hosts a fully functional campground which makes for a great summer getaway for family & friends. Bring the whole squad out to the park for a full day of fun activities at Calaway Park!

These famous local attractions make for a great family-friendly day out in the city.",
'Dec 14, 2021, 6:20PM', 0, "NW", 
"Local Attractions ", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "Southeast Calgary is a vast district of residential neighbourhoods and peaceful parkland stretching along the Bow River, including Fish Creek Provincial Park, popular for its trails and birdlife like great blue herons. In the north, the Calgary Zoo is home to giant pandas and grizzly bears. The indoor Calgary Farmers’ Market sells produce, meat, and hot snacks, while fashion and homeware shops fill Southcentre Mall.",
'Dec 14, 2021, 6:20PM', 0, "SE", 
"My Favorite Part of the City", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "The Beltline is one of Calgary’s most densely populated communities and home to hundreds of colourful businesses that span the neighbourhoods of West Connaught and East Victoria Park. The area is a hub for art, culture and entertainment and nowhere is this more visible than through the Beltline Urban Mural Projects (BUMP). Since 2017, artists have transformed dozens of public walls into thought-provoking and whimsical murals that celebrate the diversity, talent and vibrant character of the community.Take a neighbourhood tour of these murals by jumping on one of the many bike lanes that zip you throughout the area.The 12th Ave cycle track brings you to popular murals such as the JPG Mural",
'Dec 14, 2021, 6:44PM', 0, "SW", 
"Murals, Breweries & Bikes in the Beltline", 4);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("mikailmunir01@gmail.com", "Extremely convenient area. Everything is close by! Grocery stores, gyms, recreational locations, and even the airport! Everything you could possibly need is no more than a 15-20 minute drive away.",
'Dec 02, 2021, 3:38PM', 0, "NE", 
"Convenience at its best", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "Southeast Calgary is known for its wide open green spaces, spectacular mountain views and beautiful river valley. It offers a perfect blend of country and city living and features more Calgary lake communities than any other quadrant in the city.",
'Dec 14, 2021, 6:24PM', 0, "SE", 
"Awesome Place!", 4);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "Culture. Food. Nature. Fun. All things that Calgary is lucky to have no shortage of and all things that are calling your name to Calgary's South East Quadrant. Trendy neighbourhoods, the city's beer capital, authentic eats, lush parks, family-friendly getaways and the home of the Calgary Stampede, what more could you ask for in a day of exploration around one of the city's most exciting quarters?",
'Dec 14, 2021, 6:30PM', 0, "SE", 
"Just Love it here!!", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("aashirbadd@gmail.com", "There are so many lively and multicultural comunities in this area. It makes for fun, educational, and fulfilling experiences. NE Calgary is incredibly diverse, welcoming, and offers many opportunites for self developement.",
'Dec 04, 2021, 6:44PM', 0, "NE", 
"Multiculturalism", 4);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "Greenspaces and natural landscapes make up a lot of Calgary (over 8000 hectares) and many of these urban getaways are waiting for you in the South East. Feel connected to nature with a hike, bike or beach day in Fish Creek Provincial Park. Try your hand at fly fishing in the world-renowned Bow River, a fly fisher’s paradise. Out Fly Fishing Outfitters can set you up with equipment or take you out on a guided trip to show you the ropes. Discover a new species and explore the Inglewood Bird Sanctuary, free of charge – just remember to be mindful of the environment when taking in this hidden gem. And the best part? You can use Calgary's seemingly never-ending bike paths to access them all. ",
'Dec 14, 2021, 6:37PM', 0, "SE", 
"Biking and Birds and Fish? Oh My!", 4);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("testuser@nexthome.com", "The North East hosts its own share of gorgeous parks and pathways to be explored. Prairie Winds is a massive spot with great hiking trails and grassy two-stepping fields in August during Country Thunder, a Country music weekend held in August. Tom Campbell’s Hill Natural Park has a great off-leash park, interpretive exhibit, splash parks and beautiful lookouts of downtown Calgary that are Instagram worthy. ",
'Dec 02, 2021, 1:45PM', 0, "NE", 
"Parks and Pathways", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "Locals know finding a good bite in Calgary isn’t hard. Looking for restaurants and hyperlocal eats you haven’t tried before? Try the South East quadrant. With over 75 restaurants each with their own special flare, International Avenue is the ultimate foodie destination. Hunt down the best our local producers have to offer at the Calgary Farmers’ Market. No matter what you are in the mood for, the culinary flare of the SE has got you covered.",
 'Dec 14, 2021, 6:42PM', 0, "SE", 
"Hyperlocal Food for Thought", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("testuser@nexthome.com", "Is there a better way to spend a day with family & friends than exploring the parks, pathways and natural greenspaces in Calgary’s North West? These gorgeous parks and natural greenspaces offer some great city and mountain views, while being connected by an extensive network of multi-use pathways available for all to enjoy for walking, dog parks, running, in-line skating or cycling.",
'Dec 14, 2021, 6:44PM', 0, "NW", 
"Lush Parks, Pathways & Greenspaces ", 4);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("mikailmunir01@gmail.com", "The North West is home to big brand shopping centres and malls for family & friends alike. This fresh approach to shopping can make your shopping trip a full day experience with outlets at CrossIron Mills, big brand stores at CF Market Mall, and family friendly shopping at Northland Village Mall.",
'Dec 08, 2021, 6:22PM', 0, "NW", 
"The Ultimate Shopping Getaway", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "Marda Loop has quickly become one of Calgary’s most charming and stylish neighbourhoods. Lined with bakeries, cafes and ice-cream shops, it’s the perfect place to go out to get your fix of sweets and treats.

Visit Pie Cloud, located in the Mercantile Farmers Market, for freshly baked savoury and sweet pies. One street down, Calgary’s premium Korean bakery, WOW Bakery, serves up world-renowned pastries, cakes and breads.

Marda Loop has also become synonymous with ice cream. My Favourite Ice Cream Shoppe scoops 72 flavours of ice cream and has been a place for locals to gather on hot summer days since 1981. Play the piano in the shop for 10 minutes and get a free ice cream. Your other delicious option is Village Ice Cream on Garrison Corner, where they make all their flavours right on location. Two scoops of salted caramel on a fresh waffle cone is worth the trip to Marda Loop alone.

When you’re craving something bakeries and ice cream shops can’t offer, treat yourself to some rest, relaxation and Rosso at Distilled Beauty Bar. This all-in-one bar/social house/spa serves tapas, coffee, wine and cocktails and also offers gluten free, vegan and vegetarian options. Come in with some friends for drinks and snacks or make a day of it by indulging in one of the many beauty treatments.",
'Dec 14, 2021, 6:46PM', 0, "SW", 
"Find the Best Sweets & Treats in Marda Loop", 4);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("aashirbadd@gmail.com", "Did you know that the North East is home to the most brunch spots in the city?  OEB Breakfast Co. is known for its signature breakfast poutines and serving up duck fat fries with their delicious breakfast sandwiches. Make sure you bring an empty stomach to Blue Star Diner, a favourite breakfast spot for locals who love to support local farmers. Diner Deluxe is known for its mismatched coffee mugs and comfort food that will make you feel like you’re at a friend’s house for brunch",
'Dec 04, 2021, 6:44PM', 0, "NE", 
"Brunch, brunch… and a little more brunch
", 4);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("aashirbadd@gmail.com", "Locals know that the North West is home to beautiful golf courses in and around the city. This makes for a unique destination for local golf enthusiasts, as many of these courses offer unparalleled mountain & city views, immaculate fairways and bent grass greens which makes the North West home of world-class, yet easy-going mountain golf. Most of these courses are open to the public at very reasonable rates and are open to the people of all ages and skill levels.",
'Dec 10, 2021, 4:44PM', 0, "NW", 
"City & Mountain View Golf Courses", 4);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "You might not expect to find Canada’s largest sailing school, a rowing club and canoe rental shop in the heart of Calgary, but that’s exactly what’s happening on warm days at the Glenmore Reservoir. A retreat from its urban surroundings, the reservoir backs onto the Weaselhead Natural Environment Area, a 237 hectare park full of wildlife, hiking and biking trails. The Glenmore Sailing School and Calgary Canoe Club  provide rentals and lessons to get you on the water and enjoying one of the most unique treasures in Calgary.

If water sports aren’t for you, the parks surrounding Glenmore Reservoir are equally as stunning. Backdropped by a view of the Rocky Mountains, North & South Glenmore Park are great places to enjoy a family picnic or barbecue while looking down at the water. Green spaces and tennis courts make it easy to spend an entire day at the park. Stay late to catch one of the best sunset views in the city.",
'Dec 14, 2021, 6:48PM', 0, "SW", 
"Enjoy Nature at the Glenmore Reservoir & Park", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "Calgary’s local craft scene isn’t a secret but many of Calgary’s original breweries are found in the North East and are ready to explore. For the craft beer lovers, Tool Shed opens its brewery doors to see behind the scenes of Calgary’s first microbrewery. Minhas Micro Brewery offers tours and homemade pizzas. Or you can mix it up with Peter’s Drive-In as they ‘brew’ incredible milkshakes where you choose the unique mix ins for custom flavours.",
'Dec 03, 2021, 5:45PM', 0, "NE", 
"Brews for all Crews", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "Some of Calgary’s best ethnic restaurants have set up shop in the SW creating a quadrant that cooks up diverse food for every taste. Options range from authentic Japanese and Ethiopian to fresh takes on classic Italian.

Abyssinia: Authentic Ethiopian & Eritrean
Take part in the unique and ancient cuisine of Ethiopia and Eritrea through the shared dining experience of breaking into injera with different vegetable and meat stews. The traditional coffee roasting is a unique aromatic experience that transports you to a different place.

Location: 910 12 Ave SW

Allora Every Day Italian
Everything served at Allora Every Day Italian is local, handmade, or directly imported from Italy. This restaurant specializes in gluten free pasta that more than passes the test.

Location: 326 Aspen Glen Landing SW Unit 114

OMO Teppan: Japanese Steak House
Calgary's teppanyaki place for Wagyu beef, sushi and the perfect spot for a night out in celebration. Your personal chef performs a spectacle of fire, food and flare that makes for a truly memorable dining experience.

Location: 522 Macleod Trail S

Shokunin: Contemporary Japanese
Consistently voted as one of Canada’s top restaurants, Shokunin is a can’t miss experience for any foodie. Local ingredients are combined with traditional Japanese techniques and flavour profiles to create one-of-a-kind masterpieces.",
'Dec 14, 2021, 6:52PM', 0, "SW", 
"Eat Diverse Ethnic Cuisine", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("mikailmunir01@gmail.com", "Being a short drive from the Rocky Mountains makes the North West the perfect spot for adventure enthusiasts of all kinds. Hop in your car from the North West, and you will be taking in that fresh mountain air within 45 minutes of the city. People often choose the North West side of the city as a starting point for a day trip to the Town of Canmore or Banff. With a plethora of budget friendly accommodation options available & easy vehicle accessibility out of the city, the North West quadrant makes for an excellent jump-off point for an exciting family-friendly mountain escape for the whole crew!",
'Dec 10, 2021, 4:44PM', 0, "NW", 
"Close Proximity to the Rocky Mountains", 5);

INSERT INTO `nextHome`.`Review` (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating)
Values("jeffsmith@gmail.com", "The Calgary Zoo and TELUS Spark Science Centre host events for locals that makes every visit a new experience! Take a special someone or a group of friends to the Calgary Zoo for a wild evening of fun of movies, crafting, music, and more, each night different from the next. Spark After Dark, on the second Thursday of each month, invites locals 18 years and older to reignite childhood memories at the Science Centre with drinks and DJ’s for different themed evenings such as valentines or fun with your best furry friend!",
'Dec 10, 2021, 2:10PM', 0, "NE", 
"Two famous Calgary attractions in one day!", 5);



