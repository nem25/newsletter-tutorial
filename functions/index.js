const functions = require("firebase-functions");

exports.signUp = functions.https.onCall((data, context) => {
    return "Success from my function!";
})
