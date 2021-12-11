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
    const Email = "aashirbadd@gmail.com";
    const reviewDescription = req.body.reviewDescription;
    const reviewDate = new Date();
    const flag = 0;
    const areaCode = req.body.reviewArea;
    const reviewTitle = req.body.reviewTitle;
    const reviewRating = req.body.stars;

    console.log(reviewDescription + " " + areaCode);

    const queryString = "INSERT INTO Review (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating) VALUES (?,?,?,?,?,?,?);"

    getConnection().query(queryString, [Email, reviewDescription, reviewDate, flag, areaCode, reviewTitle, reviewRating], (err, results, fields) =>{ 
        if(err){
            console.log("Failed to insert new user: " + err)
            res.sendStatus(500)
            return
        }
        console.log(reviewRating);
        console.log("Inserted a new user with id: ", results.userID)
        res.end()
    })
    res.redirect("./html/areaReviews.html");

    //res.end();
})


router.get("/get_reviews", (req, res) => {
    const queryString = "SELECT * FROM Review;";
    const flag = 0;

    const queryInserts = [flag];

    getConnection().query(queryString, (err, rows, fields) => {
        if(err){
            console.log("Failed to query for listings: " + err)
            res.sendStatus(500)
            throw err
        }
        console.log("I think we fetched listings successfuly")
        res.json(rows)
    })

})

router.get("/get_specificReview", (req, res) => {
    const area = req.query.area;
    console.log("area is" + area);
    const queryString = "SELECT * FROM Review WHERE (AreaCode = ?);";
    //const queryString = "SELECT * FROM Review;";
    const flag = 0;

    const queryInserts = [area];

    getConnection().query(queryString, queryInserts, (err, rows, fields) => {
        if(err){
            console.log("Failed to query for listings: " + err)
            res.sendStatus(500)
            throw err
        }
        console.log("I think we fetched listings successfuly")
        res.json(rows)
    })

})

router.get("/search_listings/", (req, res) => {
    const area = req.query.area;
    const minPrice = req.query.min_price;
    const maxPrice = req.query.max_price;
    const minSqft = req.query.min_sqft;
    const maxSqft = req.query.max_sqft;
    const queryString = "SELECT * FROM Listings WHERE (AreaName = ?) AND (Price >= ? AND Price <= ?) AND (SquareFootage >= ? AND SquareFootage <=?);";
    const queryInserts = [area, minPrice, maxPrice, minSqft, maxSqft];

    getConnection().query(queryString, queryInserts, (err, rows, fields) => {
        if(err){
            console.log("Failed to query for listings: " + err)
            res.sendStatus(500)
            throw err
        }
        console.log(req.params);
        console.log("I think we fetched listings successfuly")
        res.json(rows)
    })

})

module.exports = router       //Export this file somehow.