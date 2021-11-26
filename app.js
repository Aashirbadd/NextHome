const express = require("express");
const app = express();
const morgan = require("morgan");
const mysql = require("mysql");
const bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({extended:false}));
app.use(morgan("short"));
app.use(express.static("./src"));

// Refactoring code using router!
const router = require('./routes/user.js');
app.use(router);

const router2 = require('./routes/listings.js');
app.use(router2);


function getConnection(){
    return mysql.createConnection({
        host:"localhost",
        user:'root',
        database: 'nextHome'
    })
}

app.get("/", (req, res) => {
    console.log("Responding to root route");
    res.send("HELLO FROM ROOT!!!");
});

app.get("/listings", (req,res) => {
    const listings1 = {address: "31 Evanspark Terr NW", resident:"AashirBIRD Dhital"};
    const listings2 = {address: "98 Anaheim P NE", resident:"Mikail MANURE"};
    const listings3 = {address: "38 Tuscany Estates Dr NW", resident:"Aayush DAHAL DAHAL DAHAL"};
    res.json([listings1,listings2,listings3]);
});




app.listen(3000, () => {
    console.log("Server is up and listening on 3000....")
});