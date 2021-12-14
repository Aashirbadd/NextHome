DROP DATABASE nextHome;

CREATE DATABASE nextHome;

USE nextHome;
ALTER USER 'root' @'localhost' IDENTIFIED WITH mysql_native_password BY '';
flush privileges;


CREATE TABLE `Listings` (
  `idListings` int NOT NULL AUTO_INCREMENT,
  `MLSCode` int DEFAULT NULL,
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
  PRIMARY KEY (`AreaCode`, `Email`, `SquareFootage`, `PriceRange`)
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

INSERT INTO `nextHome`.`AreaSubdivision` (`Name`) VALUES ('NE');
INSERT INTO `nextHome`.`AreaSubdivision` (`Name`) VALUES ('NW');
INSERT INTO `nextHome`.`AreaSubdivision` (`Name`) VALUES ('SW');
INSERT INTO `nextHome`.`AreaSubdivision` (`Name`) VALUES ('SE');

INSERT INTO `nextHome`.`Realtors` (Website, PhoneNumber, `RealtorName`, `RealtorPic`) VALUES ("realtor.ca/agent/2131632/kaitlin-metke-13120-st-albert-trail-nw-edmonton-alberta-t5l4p6", "780-886-4386", "Kaitlin Metke", "https://cdn.realtor.ca/individual/TS637553976600000000/highres/1384394.jpg");
INSERT INTO `nextHome`.`Realtors` (Website, PhoneNumber, `RealtorName`, `RealtorPic`) VALUES ("realtor.ca/agent/1725150/thuy-dinh-2629-kingsway-vancouver-british-columbia-v5r5h4", "604-773-8586", "Thuy Dinh", "https://cdn.realtor.ca/individual/TS637490202000000000/highres/1175626.jpg");
INSERT INTO `nextHome`.`Realtors` (Website, PhoneNumber, `RealtorName`, `RealtorPic`) VALUES ("cirrealty.ca/aimee_manser", "403-818-1546", "Aimee Manser", "https://sso.cirrealty.ca/realtorscans/CMANSEAI.jpg");
INSERT INTO `nextHome`.`Realtors` (Website, PhoneNumber, `RealtorName`, `RealtorPic`) VALUES ("sophia-klassen.c21.ca/", "(403) 863-7235", "Sophia Klassen", "https://i5.moxi.onl/img-pr/a/d49c6ed3-1339-4dfc-8dae-2bfdf57b5000/0_2_full.jpg");
INSERT INTO `nextHome`.`Realtors` (Website, PhoneNumber, `RealtorName`, `RealtorPic`) VALUES ("c21.ca/directory/agents/suman-brar", "(403) 919-9733", "Suman Brar", "https://i5.moxi.onl/img-pr/a/a243df43-7d92-4033-8c73-3d0bfcfc944d/0_1_full.jpg");
INSERT INTO `nextHome`.`Realtors` (Website, PhoneNumber, `RealtorName`, `RealtorPic`) VALUES ("remax.ca/ab/jennifer-miller-117639-ag", "(403) 923-7768", "Jennifer Miller", "https://remax-aphotos-papi.imgix.net/Person/100110604/MainPhoto_cropped/MainPhoto_cropped.jpg?fit=max&auto=format,compress&fm=pjpg&cs=srgb&q=75&w=2160");



INSERT INTO `nextHome`.`Brokerage` (Website, `BrokerageName`, `BrokeragePic`) VALUES ("cirrealty.ca/", "CIR Realty", "https://www.cirrealty.ca/Themes/CIR-Blue/Content/images/CIR_Logo_Blue-Square_spot-p-800.jpeg");
INSERT INTO `nextHome`.`Brokerage` (Website, `BrokerageName`, `BrokeragePic`) VALUES ("https://bamberrealty.c21.ca/", "Century 21 Bamber", "https://easterseals.ab.ca/app/uploads/2019/05/century-logo.jpg");
INSERT INTO `nextHome`.`Brokerage` (Website, `BrokerageName`, `BrokeragePic`) VALUES ("realtor.ca", "Realtor", "https://www.realtor.ca/images/logo.svg");
INSERT INTO `nextHome`.`Brokerage` (Website, `BrokerageName`, `BrokeragePic`) VALUES ("https://www.remax.ca/ab/calgary-real-estate?pageNumber=1", "Remax", "https://media-exp1.licdn.com/dms/image/C4E1BAQEBN8PiPBxiYw/company-background_10000/0/1519838354578?e=2159024400&v=beta&t=IfGiR7P4g6oOu-v21aM4RIkamzKuCurthAvPxbbOyto");




INSERT INTO `nextHome`.`User` (FName, LName, Email, `Password`) VALUES ("Aashirbad", "TheUltimateEagle", "aashirbadd@gmail.com", "cookie123");
INSERT INTO `nextHome`.`User` (FName, LName, Email, `Password`) VALUES ("Mikail", "Munir", "mikailmunir01@gmail.com", "bordgilla");
INSERT INTO `AdminUser` (AdminCode, FirstName, LastName, AdminEmail, `Password`) VALUES (1, "Mikail", "Munir", "mikailmunir01@gmail.com", "bordgilla");
INSERT INTO `AdminUser` (AdminCode, FirstName, LastName, AdminEmail, `Password`) VALUES (2, "Aashirbad", "Dhital", "aashirbadd@gmail.com", "cookie123");
