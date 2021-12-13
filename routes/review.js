// Contains all user related routes
const mysql = require("mysql");
const express = require("express");
const e = require("express");
const router = express.Router();    // Creates a brand new router

function getConnection(){
    return mysql.createConnection({
        host:"localhost",
        user:'root',
        database: 'nextHome'
    })
}

router.post("/create_review", (req, res) => {
    const email = req.body.email;
    const password = req.body.password;
    const reviewDescription = req.body.reviewDescription;
    const reviewDate = new Date();
    const flag = 0;
    const areaCode = req.body.reviewArea;
    const reviewTitle = req.body.reviewTitle;
    const reviewRating = req.body.stars;

    const queryString1 = "SELECT Email FROM User WHERE Email = ? AND Password = ?;"
    const queryString2 = "INSERT INTO Review (Email, ReviewDescription, ReviewDate, Flag, AreaCode, ReviewTitle, ReviewRating) VALUES (?,?,?,?,?,?,?);"

    getConnection().query(queryString1, [email,password], (err, results, fields) => {
        if(err){
            console.log("Failed to find user" + err);
            res.sendStatus(500);
        } else if(results.length > 0){
            console.log("User found! You can post this review. ");
            getConnection().query(queryString2, [email, reviewDescription, reviewDate, flag, areaCode, reviewTitle, reviewRating], (err, results, fields) =>{ 
                if(err){
                    console.log("Failed to insert new user: " + err)
                    res.sendStatus(500)
                    return
                }
                res.redirect("./html/areaReviews.html");
            })
        } else{
            console.log("Wrong account details!!!")
            res.redirect("/html/createReview.html");
        }
    })
})

router.get("/get_flagged_review", (req, res) => {
    getConnection().query("SELECT * FROM Review WHERE Flag = 1", (err, results, fields) =>{
        if(err) {
            console.log("Could not retrieve flagged reviews: " + err);
        } else{
            res.send(results);
        }
    })
})

router.get("/delete_review/:reviewID", (req,res) => {
    const id = req.params.reviewID;
    getConnection().query("DELETE FROM `Review` WHERE idReview = ?;", [id], (err, results, fields) => {
        if(err){
            console.log("Failed to delete review: " + err);
            return
        } else{
            console.log("Deletion successful!");
            res.end("review deleted!");
        }
    })
})

router.get("/flag_review/:id", (req,res) => {
    const id = req.params.id;
    getConnection().query("UPDATE Review SET Flag = ? WHERE idReview = ?", [1, id], (err, results, fields) => {
        if(err){
            console.log("Failed to flag review: " + err);
            return
        } else{
            console.log("flag successful!");
            res.end("review flagged");
        }
    })
})

router.get("/unflag_review/:id", (req,res) => {
    const id = req.params.id;
    getConnection().query("UPDATE Review SET Flag = 0 WHERE idReview = ?", [id], (err, results, fields) => {
        if(err){
            console.log("Failed to unflag review: " + err);
            return
        } else{
            console.log("unflag successful!");
            res.end("review unflagged!");
        }
    })
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
    //res.end()
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
    //res.end()
})

module.exports = router       //Export this file somehow.