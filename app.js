const express = require("express");
const app = express();
const morgan = require("morgan");
const mysql = require("mysql");
const bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({extended:false}));
app.use(morgan("short"));
app.use(express.static("./src"));

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

app.post("/create_user", (req, res) => {
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

app.post("/post_listing", (req,res) => {

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


    const queryString = "INSERT INTO Listings (`MLS Code`, `Basement Type`, `Description`, Price, SquareFootage, Bedrooms, Bathrooms, Address, AreaName, BrokerageWebsite, RealtorWebsite, UserID) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);"
    getConnection().query(queryString, [mlsCode, basementType, description, price, sqft, bedrooms, bathrooms, address, areaName, brokerage, realtor, user], (err, results, fields)=>{
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

app.listen(3000, () => {
    console.log("Server is up and listening on 3000....")
});