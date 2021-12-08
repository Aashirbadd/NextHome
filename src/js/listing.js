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
    const ListingContainer = document.getElementById("left-pane");
    ListingContainer.innerHTML = `
        <h1>${listing.Address}</h1>
        <p>MLS® Number: ${listing.MLSCode}</p>
        <br>
        <p>Basement: ${listing.BasementType} | ${listing.SquareFootage} SqFt |  Area Code: ${listing.AreaName}</p>
        <br>
        <p>Description:</p>
        <p>${listing.Description}</p>`

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
        newDiv.id = MLS;



        ListingContainer.appendChild(newDiv);
        //document.body.appendChild(newDiv);                  // Append to html file
    let addresses = document.getElementById(MLS);
    addresses.innerHTML= `  <div class="listing-disc">
                            <H2>${listing.Address}</H2>
                            <p>Price: ${listing.Price}</p>
                            <p>Square Footage: ${listing.SquareFootage}</p>
                            <p>Bedrooms: ${listing.Bedrooms}</p>
                            <p>Bathrooms: ${listing.Bathrooms}</p>
                            </div>`;
    
}

const j = fetch("/get_listings/2")
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