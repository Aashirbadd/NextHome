const ListingContainer = document.getElementById("listing-container");

function createListing(listing, MLS){
    //let listings = document.querySelectorAll("#addy");
        const newDiv = document.createElement("a");       //Create new div
        newDiv.classList.add('listing');                 // Add class to the list.
        newDiv.id = MLS;
        newDiv.href = `listing.html?id=${MLS}&area=${listing.AreaName}`
        ListingContainer.appendChild(newDiv);
        //document.body.appendChild(newDiv);                  // Append to html file
    let addresses = document.getElementById(MLS);
    addresses.innerHTML= `  <p>
                                <object class="listing-img" data="${listing.ImageURL}" type="image/png">
                                <img class="listing-img" src="../img/House.jpeg">
                                </object>
                            </p>
                            <div class="listing-disc">
                            <H2>${listing.Address} ${listing.AreaName}</H2>
                            <p>Price: ${listing.Price}</p>
                            <p>Square Footage: ${listing.SquareFootage}</p>
                            <p>Bedrooms: ${listing.Bedrooms}</p>
                            <p>Bathrooms: ${listing.Bathrooms}</p>
                            </div>`;
    
}
//<img class="listing-img" src="${listing.ImageURL}" alt="">

function searchAllListings(){
    const j = fetch("/get_listings/")
                .then(response => response.json())
                .then(data=>{
                    console.log("from shizzers");
                    console.log(data)
                    data.forEach(function(i){
                        console.log(i);
                        createListing(i, i.idListings);
                    })
                    return data;
    
                    //document.querySelector("#address").innerText=data.address
                    //document.querySelector("#price").innerText=data.price
    
                })
    
    Array.from(j).forEach(function(i){
        console.log(i);
        
    })
    
}

function fetchSpecificListings(searchString){
    const j = fetch(searchString)
            .then(response => response.json())
            .then(data=>{
                console.log("from shizzers");
                console.log(data)
                data.forEach(function(i){
                    console.log(i);
                    createListing(i, i.idListings);
                })
                return data;
            })

    Array.from(j).forEach(function(i){
    console.log(i);
    })
}

function fn1(){
    const areaName = document.getElementById("area").value;
    const minPrice = document.getElementById("min-price").value;
    const maxPrice = document.getElementById("max-price").value;
    const minSqft = document.getElementById("min-sqft").value;
    const maxSqft = document.getElementById("max-sqft").value;

    const searchString = `/search_listings?area=${areaName}&min_price=${minPrice}&max_price=${maxPrice}&min_sqft=${minSqft}&max_sqft=${maxSqft}`

    ListingContainer.innerHTML = ``;
    fetchSpecificListings(searchString);
}

function getAll(){
    ListingContainer.innerHTML = ``;
    searchAllListings();
}

getAll();