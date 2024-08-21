async function getGoogleAccessToken() {
    return new Promise((resolve, reject) => {
        chrome.cookies.get({ url: "http://localhost:3000", name: "googleAccessToken" }, (cookie) => {
            console.log(cookie);
            if (cookie) {
                resolve(cookie.value);
            } else {
                resolve(null);
            }
        });
    });
}

async function generateQRCodeOrRedirect() {
    const token = await getGoogleAccessToken();

    if (token) {
        var qrcode = new QRCode(document.getElementById("placeHolder"), {
            text: token,
            width: 128,
            height: 128,
            colorDark: "#000000",
            colorLight: "#ffffff",
            correctLevel: QRCode.CorrectLevel.H
        });
    } else {
        // Redirect to the /signin page if token is not found
        window.location.href = "/signin";
    }
}

// Call the function to generate the QR code or redirect
generateQRCodeOrRedirect();
