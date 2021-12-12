
console.log("Hello");
const reviewContainer = document.getElementById("review-container");


function createReview(review){
    //let listings = document.querySelectorAll("#addy");
    const newDiv = document.createElement("a");       //Create new div
    newDiv.classList.add('review-pane');                 // Add class to the list.
    newDiv.id = review.idReview;
    reviewContainer.appendChild(newDiv);                  // Append to html file

    let filledStar = "★";
    let emptyStar = "☆";
    const rating = filledStar.repeat(review.ReviewRating) + emptyStar.repeat(5-review.ReviewRating);

    if (review.Flag){
        flag = `<a class="search-btn flag" onclick="unFlagReview(${review.idReview})" >Unflag</a>`;
    }
    else flag = `<div class="rightPane"> <a class="search-btn flag" onclick="flagReview(${review.idReview})" >Flag</a>`;

    const urlString = window.location.href;

    if (urlString.includes("moderateReview")){
        del = `<a class="search-btn del" onclick="deleteReview(${review.idReview})" >Delete</a> </div>`;
    } else del = ``;
    
    let flagPane = `<div class="rightPane"> ${flag} ${del} </div>`;


        //ListingContainer.appendChild(newDiv);
        //document.body.appendChild(newDiv);                  // Append to html file
    let addresses = document.getElementById(review.idReview);
    addresses.innerHTML= `  <div class="leftPane">
                            <H1>${review.ReviewTitle}</H1>
                            </br>
                            <p>${rating}</p>
                            </br>
                            <p>Area: ${review.AreaCode} | User: ${review.Email} |  Date: ${review.ReviewDate}</p>
                            </br>
                            <p>Description: \n${review.ReviewDescription}</p>
                            </div>
                            ${flagPane}`;        
}

async function flagReview(reviewID){
    return fetch(`/flag_review/${reviewID}`)
        .then(getReviews());
}

async function unFlagReview(reviewID){
    console.log(reviewID)
    let element = document.getElementById(reviewID);
    console.log("hi" + element);
    fetch(`/unflag_review/${reviewID}`)
        .then(getReviews());
    
    
}

function deleteReview(reviewID){
    fetch(`/delete_review/${reviewID}`);
    getReviews();
}

function getAllReviews(){
    reviewContainer.innerHTML=``;
    const g = fetch("/get_reviews")
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
                })
}

function getSpecificReviews(areaCode){
    const g = fetch(`/get_specificReview?area=${areaCode}`) // /get_specificReview?area=NW
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
                })
}

function getReviews(){
    const area = document.getElementById('area').value;
    console.log(area);
    reviewContainer.innerHTML=``;
    if (area != "ALL"){
        getSpecificReviews(area);
    }
    else{
        getAllReviews();
    }
    
}


getAllReviews();