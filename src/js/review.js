console.log("Hello");
const reviewContainer = document.getElementById("outer-container");


function createReview(review){
    //let listings = document.querySelectorAll("#addy");
    const newDiv = document.createElement("a");       //Create new div
    newDiv.classList.add('review-pane');                 // Add class to the list.
    newDiv.id = review.idReview;
    reviewContainer.appendChild(newDiv);                  // Append to html file

    let filledStar = "★";
    let emptyStar = "☆";
    const rating = filledStar.repeat(review.ReviewRating) + emptyStar.repeat(5-review.ReviewRating);

        //ListingContainer.appendChild(newDiv);
        //document.body.appendChild(newDiv);                  // Append to html file
    let addresses = document.getElementById(review.idReview);
    addresses.innerHTML= `  <H1>${review.ReviewTitle}</H1>
                            </br>
                            <p>${rating}</p>
                            </br>
                            <p>Area: ${review.AreaCode} | User: ${review.Email} |  Date: ${review.ReviewDate}</p>
                            </br>
                            <p>Description: \n${review.ReviewDescription}</p>`;
        
}

const j = fetch("/get_reviews")
            .then(response => response.json())
            .then(data=>{
                console.log("from shizzers");
                console.log(data)
                data.forEach(function(i){
                    console.log(i);
                    createReview(i);
                    //createListing(i, i.idListings);
                })
                return data;

                //document.querySelector("#address").innerText=data.address
                //document.querySelector("#price").innerText=data.price

            })
j;