



function addNewNFTtoHome() {
    const para = document.createElement("Div");
    para.id = "nftDiv"; 

    para.innerHTML = `
    <div id = "nftDivAlt">
                <img src="1.png" alt="">
                <div id = deneme>
                    <p>Price:</p>
                    <p>Highest Bid:</p>
                    <p>End Time:</p>
                    <p>Your Offer:</p>
                    <input type="text">
                    <button>Give Offer</button>
                </div>
            </div>    
    `

    document.body.appendChild(para); //body'e öğeyi ekledik
}



