const firebase = require("firebase/app");
require('firebase/auth');
require('firebase/database');

let database = null;

async function startDatabase() {
    const config = {
        apiKey: "",
        authDomain: "",
        databaseURL: "",
        storageBucket: ""
    };
    
    firebase.initializeApp(config);

    // Get a reference to the database service
    database = firebase.database();

    console.log("Connected to database");
}

async function getDatabase() {
  if (!database) await startDatabase();
  return database;
}

module.exports = {
  getDatabase,
  startDatabase,
};
