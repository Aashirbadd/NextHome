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
    func2();
    //console.log(listings);
}

func2();

function func2(){
    //let listings = document.querySelectorAll("#addy");
    for (let i = 0; i < 9; i++) {
        const newDiv = document.createElement("a");       //Create new div
        const newAddress = document.createElement("h2");
        newAddress.classList.add("addy");
        //newAddress.innerText.AddNew("hi");
        newDiv.classList.add('listing');                 // Add class to the list.
        newAddress.id = 'addy';
        newDiv.append(newAddress);
        ListingContainer.appendChild(newDiv);
        //document.body.appendChild(newDiv);                  // Append to html file
      }
    let listings = document.querySelectorAll("#addy");
    let i = 0;
    Array.from(listings).forEach(function(listing){
        console.log(listing);
        listing.textContent="House #" + i;
        i++;
    })
    //console.log(listings);
}