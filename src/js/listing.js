//const BtnAdd = document.querySelector(".addListing");   // Obtains button with id of addListing
//console.log(BtnAdd);

//BtnAdd.addEventListener("click", AddNew);  // Pays attention to when this event happens

function AddNew(){
    const newDiv = document.createElement("a");       //Create new div
    const newAddress = document.createElement("h1");
    newAddress.classList.add("addy");
    //newAddress.innerText.AddNew("hi");
    newDiv.classList.add('listing');                 // Add class to the list.
    newAddress.id = 'addy';
    newDiv.append(newAddress);
    ListingContainer.appendChild(newDiv);
    //document.body.appendChild(newDiv);                  // Append to html file
    createListing();
    //console.log(listings);
}

//createListing();
function leftPane(listing){
    const LC = document.getElementById("image-container");
    LC.innerHTML = `
                <img class="arrow left" src="../img/left.png" alt="">
                
                <object class="listing-image" data="${listing.ImageURL}" type="image/png">
                <img class="listing-image jj" src="../img/House.jpeg">
                </object>
                
                <img src="../img/house2.jpeg" alt="" class="listing-image">
                <img src="../img/house3.jpeg" alt="" class="listing-image">
                <img class="arrow right" src="../img/right.png" alt="">
                `;

    const ListingContainer = document.getElementById("left-pane");
    ListingContainer.innerHTML = `
        <h1>${listing.Address}</h1>
        <p>MLS® Number: ${listing.MLSCode}</p>
        <br>
        <p>Basement: ${listing.BasementType} | ${listing.SquareFootage} SqFt |  Area Code: ${listing.AreaName}</p>
        <br>
        <p>Description:</p>
        <p>${listing.Description}</p>`
    
    const RealtorPane = document.getElementById("realtor-pane")
    RealtorPane.innerHTML =`
                            <div class="realtor-text">
                            <h2>Realtor:</h2>
                            <p>${listing.RealtorName}</p>
                            </br>
                            <p>📞 ${listing.PhoneNumber}</p>
                            <a class="search-btn realtor-btn" href="https://www.${listing.RealtorWebsite}">Go to site</a>
                            </div>
                            <img class = "realtor-img" src="../img/realtor.png" alt="">`;
    
    const BrokeragePane = document.getElementById("brokerage-pane")
    BrokeragePane.innerHTML =`
                            <div class="realtor-text">
                                <h2>Brokerage:</h2>
                                <br>
                                <p>${listing.BrokerageName}</p>
                                <a class="search-btn listing-btn" href="https://www.${listing.BrokerageWebsite}">Go to site</a>
                            </div>
                            <img class = "realtor-img" src="../img/cir.png" alt="">`;
    
                            

}

function rightPane(listing){
    const ListingContainer = document.getElementById("pane-1");
    ListingContainer.innerHTML = `
    <h2>Price: $${listing.Price}</h2>
    <p>🛏${listing.Bedrooms} Bedroom | 🛀🏻 ${listing.Bedrooms} Bathroom</p>`
}

function createListing(listing, MLS){
    //let listings = document.querySelectorAll("#addy");
        const newDiv = document.createElement("a");       //Create new div
        newDiv.classList.add('listing');                 // Add class to the list.
        newDiv.href = "listing.js";
        console.log("yo" + newDiv.href);
        newDiv.id = MLS;


        ListingContainer.appendChild(newDiv);
        //document.body.appendChild(newDiv);                  // Append to html file
    let addresses = document.getElementById(MLS);
    addresses.href = "listing.js";
    addresses.innerHTML= `  <div class="listing-disc">
                            <H2>${listing.Address}</H2>
                            <p>Price: ${listing.Price}</p>
                            <p>Square Footage: ${listing.SquareFootage}</p>
                            <p>Bedrooms: ${listing.Bedrooms}</p>
                            <p>Bathrooms: ${listing.Bathrooms}</p>
                            </div>`;
    
}
const urlString = window.location.href;
const url = new URL(urlString);
const id = url.searchParams.get("id");
console.log("Url" + id);


const j = fetch(`/get_listings/${id}`)
            .then(response => response.json())
            .then(data=>{
                console.log("from shizzers");
                console.log(data[0]);
                leftPane(data[0]);
                rightPane(data[0]);
                return data;
                //document.querySelector("#address").innerText=data.address
                //document.querySelector("#price").innerText=data.price
            })

Array.from(j).forEach(function(i){
    console.log(i);
    
})