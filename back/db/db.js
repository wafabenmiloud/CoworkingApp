const mysql = require('mysql');
const dotenv = require('dotenv');

dotenv.config();



// Create MySQL connection
const db = mysql.createConnection({
    host: process.env.HOST,
    user: process.env.USER,
    password: "",
    database: process.env.DATABASE
  });
  
  module.exports = db;
