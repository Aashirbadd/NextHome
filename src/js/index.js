const BtnAdd = document.querySelector(".addListing");   // Obtains button with id of addListing
console.log(BtnAdd);
const ListingContainer = document.getElementById("listing-container");

BtnAdd.addEventListener("click", AddNew);  // Pays attention to when this event happens

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

function createListing(listing, MLS){
    //let listings = document.querySelectorAll("#addy");
        const newDiv = document.createElement("a");       //Create new div
        newDiv.classList.add('listing');                 // Add class to the list.
        newDiv.id = MLS;



        ListingContainer.appendChild(newDiv);
        //document.body.appendChild(newDiv);                  // Append to html file
    let addresses = document.getElementById(MLS);
    addresses.innerHTML= `  <img class="listing-img" src="../img/House.jpeg" alt="">
                            <div class="listing-disc">
                            <H2>${listing.Address}</H2>
                            <p>Price: ${listing.Price}</p>
                            <p>Square Footage: ${listing.SquareFootage}</p>
                            <p>Bedrooms: ${listing.Bedrooms}</p>
                            <p>Bathrooms: ${listing.Bathrooms}</p>
                            </div>`;
    
}

const j = fetch("/get_listings")
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