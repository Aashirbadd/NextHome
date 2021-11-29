// Contains all user related routes
const mysql = require("mysql");
const express = require("express");
const router = express.Router();    // Creates a brand new router

function getConnection(){
    return mysql.createConnection({
        host:"localhost",
        user:'root',
        database: 'nextHome'
    })
}

router.post("/create_review", (req, res) => {
    const userID = 1;
    const reviewDescription = req.body.reviewDescription;
    const reviewDate = new Date();
    const flag = 0;
    const areaCode = req.body.reviewArea;

    console.log(reviewDescription + " " + areaCode);

    const queryString = "INSERT INTO Review (UserID, ReviewDescription, ReviewDate, Flag, AreaCode) VALUES (?,?,?,?,?);"

    getConnection().query(queryString, [userID, reviewDescription, reviewDate, flag, areaCode], (err, results, fields) =>{ 
        if(err){
            console.log("Failed to insert new user: " + err)
            res.sendStatus(500)
            return
        }
        
        console.log("Inserted a new user with id: ", results.userID)
        res.end()
    })

    res.end();
})


module.exports = router       //Export this file somehow.