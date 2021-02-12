// importing the dependencies
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const {startDatabase} = require('./database/database');

const jwt = require('express-jwt');
const jwks = require('jwks-rsa');

// defining the Express app
const app = express();

// AUTH
const jwtCheck = jwt({
  secret: jwks.expressJwtSecret({
      cache: true,
      rateLimit: true,
      jwksRequestsPerMinute: 5,
      jwksUri: ''
}),
audience: '',
issuer: '',
algorithms: ['RS256']
});

app.use(jwtCheck);


// adding Helmet to enhance your API's security
app.use(helmet());

// using bodyParser to parse JSON bodies into JS objects
app.use(bodyParser.json());

// enabling CORS for all requests
app.use(cors());

// adding morgan to log HTTP requests
app.use(morgan('combined'));


app.use('/', require('./routes/index'));

startDatabase().then(() => {
  // start the server
  app.listen(3000, () => {
    console.log("Server running on port 3000");
  });
});
