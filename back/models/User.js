const { Sequelize, DataTypes } = require('sequelize');
const dotenv = require('dotenv');
dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE, process.env.USER, '', {
  host: process.env.HOST,
  dialect: 'mysql',
});

// Define the User model
const User = sequelize.define('user', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  fullname: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  nickname: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  phone_number: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  country: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  gender: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  address: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

// Synchronize the model with the database
sequelize.sync()
  .then(() => {
    console.log('Model synchronized with the database.');
  })
  .catch((error) => {
    console.error('Error synchronizing model:', error);
  });
  module.exports = User;
