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

    const queryString1 = "SELECT Email FROM User WHERE Email = ?;"
    const queryString2 = "INSERT INTO User (FName, LName, Email, Password) VALUES (?,?,?,?);"

    getConnection().query(queryString1, [email], (err, results, fields) => {
        if(err){
            console.log("Could not create account!!!")
            return;
        }
        if(results.length > 0){
            console.log("That email already exists!")
            res.redirect("/html/createAccount.html")
        } else{

            getConnection().query(queryString2, [firstname, lastname, email, password], (err, results, fields) =>{ 
                if(err){
                    console.log("Failed to insert new user: " + err)
                    res.sendStatus(500);
                    return
                }
                console.log("New user inserted into database");
                res.redirect("/html/index.html")
            })

        }
    })
})

router.get("/user_login", (req,res) => {
    const email = req.query.email;
    const password = req.query.password;
    const queryString = "SELECT Email, Password FROM User WHERE Email = ? AND Password = ?;";

    getConnection().query(queryString, [email, password], (err, results, fields) => {
        if(err){
            console.log("Could not login!!!")
        }
        console.log(results);
        if(results.length > 0){
            console.log("Login successful!")
        } else{
            console.log("Invalid email or password");
            res.redirect("/html/login.html");
            res.end();
            return;
        }
        res.redirect("/html/index.html");
    })
})

router.get("/admin_login", (req,res) => {
    const email = req.query.email;
    const password = req.query.password;
    const queryString = "SELECT Email, Password FROM User WHERE (Email = mikailmunir01@gmail.com AND Password = bordgilla) OR (Email = aashirbadd@gmail.com AND Password = cookie123);";

    getConnection().query((err, results, fields) => {
        if(err){
            console.log("Could not login!!!")
        }
        console.log(results);
        if((email === "mikailmunir01@gmail.com" && password === "bordgilla") || (email === "aashirbadd@gmail.com" && password === "cookie123")){
            console.log("Login successful!")
        } else{
            console.log("Invalid email or password");
            res.redirect("/html/login.html");
            res.end();
            return;
        }
        res.redirect("/html/moderateReview.html");
    })
})

module.exports = router       //Export this file somehow.