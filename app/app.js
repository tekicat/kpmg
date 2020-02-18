const express = require('express');
const fileUpload = require('express-fileupload');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const path = require('path');
const app = express();

const {getHomePage} = require('./routes/index');
const {addPlayerPage, addPlayer, deletePlayer, editPlayer, editPlayerPage} = require('./routes/player');
const port = process.env.APP_PORT || 2000;

console.log(process.env)
// create connection to database
// the mysql.createConnection function takes in a configuration object which contains host, user, password and the database name.
const db = mysql.createConnection ({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME
});

// connect to database
db.connect((err) => {
    if (err) {
        throw err;
    }
    let createPlayers = `CREATE TABLE IF NOT EXISTS players (
        id int(5) NOT NULL AUTO_INCREMENT,
        first_name varchar(255) NOT NULL,
        last_name varchar(255) NOT NULL,
        position varchar(255) NOT NULL,
        number int(11) NOT NULL,
        image varchar(255) NOT NULL,
        user_name varchar(20) NOT NULL,
        PRIMARY KEY (id)
      ) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;`;

    db.query(createPlayers, function(err, results, fields) {
    if (err) {
        console.log(err.message);
    }
    });
    console.log('Connected to database');
});
global.db = db;

// configure middleware
app.set('port', port); // set express to use this port
app.set('views', __dirname + '/views'); // set express to look in this folder to render our view
app.set('view engine', 'ejs'); // configure template engine
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json()); // parse form data client
app.use(express.static(path.join(__dirname, 'public'))); // configure express to use public folder
app.use(fileUpload()); // configure fileupload

// routes for the app

app.get('/', getHomePage);
app.get('/add', addPlayerPage);
app.get('/edit/:id', editPlayerPage);
app.get('/delete/:id', deletePlayer);
app.post('/add', addPlayer);
app.post('/edit/:id', editPlayer);

// set the app to listen on the port
app.listen(port, () => {
    console.log(`Server running on port: ${port}`);
});