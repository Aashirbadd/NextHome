DROP DATABASE nextHome;
CREATE DATABASE nextHome;
USE nextHome;

CREATE TABLE `Listings` (
  `idListings` int NOT NULL AUTO_INCREMENT,
  `MLS Code` int DEFAULT NULL,
  `Basement Type` varchar(45) NOT NULL,
  `Description` mediumtext NOT NULL,
  `Price` int NOT NULL,
  `SquareFootage` int NOT NULL,
  `Bedrooms` int NOT NULL,
  `Bathrooms` int NOT NULL,
  `Address` varchar(45) NOT NULL,
  `AreaName` varchar(45) NOT NULL,
  `UserID` int NOT NULL,
  `BrokerageWebsite` varchar(45) NOT NULL,
  `RealtorWebsite` varchar(255) NOT NULL,
  PRIMARY KEY (`idListings`),
  UNIQUE KEY `idListings_UNIQUE` (`idListings`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ListingPhoto` (
  `ListingID` int NOT NULL,
  `FileName` varchar(255) NOT NULL,
  `ResolutionX` int DEFAULT NULL,
  `ResolutionY` int DEFAULT NULL,
  PRIMARY KEY (`ListingID`,`FileName`),
  KEY `ListingID_idx` (`ListingID`),
  CONSTRAINT `ListingID` FOREIGN KEY (`ListingID`) REFERENCES `Listings` (`idListings`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Brokerage` (
  `Website` varchar(255) NOT NULL,
  `Name` varchar(45) NOT NULL,
  PRIMARY KEY (`Website`),
  UNIQUE KEY `Website_UNIQUE` (`Website`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Realtors` (
  `Website` varchar(255) NOT NULL,
  `PhoneNumber` varchar(45) NOT NULL,
  `Name` varchar(45) NOT NULL,
  PRIMARY KEY (`Website`),
  UNIQUE KEY `Website_UNIQUE` (`Website`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `AreaSubdivision` (
  `Name` varchar(10) NOT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `User` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `FName` varchar(45) NOT NULL,
  `LName` varchar(45) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Search` (
  `UserID` int NOT NULL,
  `AreaCode` varchar(10) NOT NULL,
  `SquareFootage` int NOT NULL,
  `PriceRange` varchar(45) NOT NULL,
  PRIMARY KEY (`AreaCode`,`UserID`,`SquareFootage`,`PriceRange`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Retrieves` (
  `UserID` int NOT NULL,
  `AreaCode` varchar(45) NOT NULL,
  `SqFt` int NOT NULL,
  `PriceRange` varchar(45) NOT NULL,
  `ListingID` int NOT NULL,
  PRIMARY KEY (`UserID`,`AreaCode`,`SqFt`,`PriceRange`,`ListingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Review` (
  `idReview` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `ReviewDate` datetime DEFAULT NULL,
  `Flag` tinyint DEFAULT '0',
  `AreaCode` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idReview`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `Flag` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  PRIMARY KEY (`ID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `AdminUser` (
  `AdminCode` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `AdminUsercol` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  PRIMARY KEY (`AdminCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Moderates` (
  `AdminCode` int NOT NULL,
  `ReviewID` int NOT NULL,
  PRIMARY KEY (`AdminCode`,`ReviewID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE Listings
ADD CONSTRAINT `BrokerageWebsite` 
FOREIGN KEY (`BrokerageWebsite`) REFERENCES `Brokerage` (`Website`),
ADD  CONSTRAINT `AreaName` FOREIGN KEY (`AreaName`) REFERENCES `AreaSubdivision` (`Name`),
ADD  CONSTRAINT `RealtorWebsite` FOREIGN KEY (`RealtorWebsite`) REFERENCES `Realtors` (`Website`),
ADD CONSTRAINT `PostOwner` FOREIGN KEY (`UserID`) REFERENCES `User` (`userID`);

ALTER TABLE Search
ADD CONSTRAINT `UserID` 
FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`),
ADD CONSTRAINT `AreaCode` 
FOREIGN KEY (`AreaCode`) REFERENCES `AreaSubdivision` (`Name`);

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
ADD CONSTRAINT `AreaCodeReference` 
FOREIGN KEY (`AreaCode`) REFERENCES `AreaSubdivision` (`Name`),
ADD CONSTRAINT `UserIDReference`
FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);

ALTER TABLE Flag
ADD CONSTRAINT `ReviewUserIDReference` 
FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`),
ADD CONSTRAINT `ReviewIDReference` 
FOREIGN KEY (`ID`) REFERENCES `Review` (`idReview`);


ALTER TABLE Moderates
ADD CONSTRAINT `AdminCode` 
FOREIGN KEY (`AdminCode`) REFERENCES `AdminUser` (`AdminCode`),
ADD CONSTRAINT `ReviewIDReference1` 
FOREIGN KEY (`ReviewID`) REFERENCES `Review` (`idReview`);
