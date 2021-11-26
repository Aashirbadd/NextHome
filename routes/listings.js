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
    const user = req.body.create_user_id;

    if(brokerage == ""){
        console.log("NULLLLLLLLL");
        
    }

    // Null realtor and Null brokerage --> So change as need.
    const queryString = "INSERT INTO Listings (`MLS Code`, `Basement Type`, `Description`, Price, SquareFootage, Bedrooms, Bathrooms, Address, AreaName,  UserID) VALUES (?,?,?,?,?,?,?,?,?,?);"
    getConnection().query(queryString, [mlsCode, basementType, description, price, sqft, bedrooms, bathrooms, address, areaName, user], (err, results, fields)=>{
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