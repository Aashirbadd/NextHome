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

router.post("/create_user", (req, res) => {
    const firstname = req.body.create_first_name;
    const lastname = req.body.create_last_name;
    const email = req.body.create_email;
    const password = req.body.create_password;

    const queryString = "INSERT INTO User (FName, LName, Email, Password) VALUES (?,?,?,?);"

    getConnection().query(queryString, [firstname, lastname, email, password], (err, results, fields) =>{ 
        if(err){
            console.log("Failed to insert new user: " + err)
            res.sendStatus(500)
            return
        }
        
        console.log("Inserted a new user with id: ", results.userID)
        res.end()
    })
})


module.exports = router       //Export this file somehow.