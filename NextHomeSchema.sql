DROP DATABASE nextHome;
CREATE DATABASE nextHome;
USE nextHome;
ALTER USER 'root' @'localhost' IDENTIFIED WITH mysql_native_password BY '';
flush privileges;
CREATE TABLE `Listings` (
  `idListings` int NOT NULL AUTO_INCREMENT,
  `MLSCode` varchar(45) DEFAULT NULL,
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
    "/img/seHouse1.jpeg"
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
