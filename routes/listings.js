// Contains all user related routes
const mysql = require("mysql");
const express = require("express");
const router2 = express.Router();    // Creates a brand new router

function getConnection(){
    return mysql.createConnection({
        host:"localhost",
        user:'root',
        database: 'nextHome'
    })
}

router2.get("/get_listings", (req, res) => {
    const area = req.params.area;
    const minPrice = req.params.min_price;
    const maxPrice = req.params.max_price;
    const minSqft = req.params.min_sqft;
    const maxSqft = req.params.max_sqft;
    const queryString = "SELECT * FROM Listings;";
    const queryInserts = [area, minPrice, maxPrice, minSqft, maxSqft];

    getConnection().query(queryString, queryInserts, (err, rows, fields) => {
        if(err){
            console.log("Failed to query for listings: " + err)
            res.sendStatus(500)
            throw err
        }
        console.log(area);
        console.log("I think we fetched listings successfuly")
        res.json(rows)
    })

})

router2.get("/get_listings/:area/:min_price/:max_price?", (req, res) => {
    const area = req.params.area;
    const minPrice = req.params.min_price;
    const maxPrice = req.params.max_price;
    const minSqft = req.params.min_sqft;
    const maxSqft = req.params.max_sqft;
    const queryString = "SELECT * FROM Listings WHERE (AreaName = ?) AND (Price >= ? AND Price <= ?);";
    //AND (Price >= ? AND Price <= ?) AND (SquareFootage >= ? AND SquareFootage <= ?);
    const queryInserts = [area, minPrice, maxPrice, minSqft, maxSqft];

    getConnection().query(queryString, queryInserts, (err, rows, fields) => {
        if(err){
            console.log("Failed to query for listings: " + err)
            res.sendStatus(500)
            throw err
        }
        console.log(area);
        console.log("I think we fetched listings successfuly")
        res.json(rows)
    })

})

router2.post("/post_listing", (req,res) => {

    const mlsCode = req.body.create_MLS_code;
    const address = req.body.create_address;
    const basementType = req.body.create_basement;
    const description = req.body.create_description;
    const price = req.body.create_price;
    const sqft = req.body.create_square;
    const bedrooms = req.body.create_bedrooms;
    const bathrooms = req.body.create_bathrooms;
    const areaName = req.body.create_area_name;
    const brokerage = req.body.create_brokerage_website;
    const realtor = req.body.create_realtor_website;
    const user = req.body.create_user_email;
    let queryString;
    let queryInserts;

    if(brokerage === "" && realtor === ""){
        queryString = "INSERT INTO Listings (`MLS Code`, `Basement Type`, `Description`, Price, SquareFootage, Bedrooms, Bathrooms, Address, AreaName,  Email) VALUES (?,?,?,?,?,?,?,?,?,?);";
        queryInserts = [mlsCode, basementType, description, price, sqft, bedrooms, bathrooms, address, areaName, user];
    } else if(brokerage === "" && realtor !== ""){
        queryString = "INSERT INTO Listings (`MLS Code`, `Basement Type`, `Description`, Price, SquareFootage, Bedrooms, Bathrooms, Address, AreaName, RealtorWebsite, Email) VALUES (?,?,?,?,?,?,?,?,?,?,?);";
        queryInserts = [mlsCode, basementType, description, price, sqft, bedrooms, bathrooms, address, areaName, realtor, user];
    } else if(brokerage !== "" && realtor === ""){
        queryString = "INSERT INTO Listings (`MLS Code`, `Basement Type`, `Description`, Price, SquareFootage, Bedrooms, Bathrooms, Address, AreaName, BrokerageWebsite, Email) VALUES (?,?,?,?,?,?,?,?,?,?,?);";
        queryInserts = [mlsCode, basementType, description, price, sqft, bedrooms, bathrooms, address, areaName, brokerage, user];
    } else{
        queryString = "INSERT INTO Listings (`MLS Code`, `Basement Type`, `Description`, Price, SquareFootage, Bedrooms, Bathrooms, Address, AreaName, BrokerageWebsite, RealtorWebsite, Email) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);";
        queryInserts = [mlsCode, basementType, description, price, sqft, bedrooms, bathrooms, address, areaName, brokerage, realtor, user];
    }

    // Null realtor and Null brokerage --> So change as need.
    getConnection().query(queryString, queryInserts, (err, results, fields)=>{
        if(err){
            console.log("Failed to insert new listing: " + err)
            res.sendStatus(500)
            return
        }
        
        console.log("Inserted a new listing with id: ", results.idListings)
        res.end()
    })

    res.end()
})

module.exports = router2       //Export this file somehow.