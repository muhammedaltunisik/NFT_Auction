function connectToMetamask() {
    /*if (typeof window.ethereum !== "undefined") {
        console.log("MetaMask installed")
    } else {
        window.open("https://metamask.io/download/", "_blank");
    }*/
    ethereum.request({ method: 'eth_requestAccounts' });
}
