const express = require("express");
const app = express();
const morgan = require("morgan");

app.use(morgan("combined"));

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

//localhost:3000
app.listen(3000, () => {
    console.log("Server is up and listening on 3000....")
});