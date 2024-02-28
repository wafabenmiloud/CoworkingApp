const { Sequelize, DataTypes } = require('sequelize');

const dotenv = require('dotenv');
dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE, process.env.USER, '', {
  host: process.env.HOST,
  dialect: 'mysql',
});

// Define the Igloo model
const Igloo = sequelize.define('igloo', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  igloo_name: {
    type: DataTypes.STRING,
  },
  igloo_type: {
    type: DataTypes.STRING,
  },
  coworking_place: {
    type: DataTypes.TEXT,
  },
  internet: {
    type: DataTypes.TEXT,
  },
  days:{
    type: DataTypes.TEXT,
  },
  transport: {
    type: DataTypes.TEXT,
  },
  equipements: {
    type: DataTypes.TEXT,
  },
  description: {
    type: DataTypes.STRING,
  },
  startDate: {
    type: DataTypes.DATE,
  },
  endDate: {
    type: DataTypes.DATE,
  },
  start_time: {
    type: DataTypes.TIME,
  },
  end_time: {
    type: DataTypes.TIME,
  },
  animals: {
    type: DataTypes.TEXT,
  },
  accept_animals: {
    type: DataTypes.BOOLEAN,
  },
  habitude: {
    type: DataTypes.BOOLEAN,
  },
  fauteil: {
    type: DataTypes.BOOLEAN,
  },
  ascenseur: {
    type: DataTypes.BOOLEAN,
  },
  cuisine: {
    type: DataTypes.BOOLEAN,
  },
  ville: {
    type: DataTypes.STRING,
  },
  location: {
    type: DataTypes.STRING,
  },
  price: {
    type: DataTypes.DOUBLE,
  },
  nb_places: {
    type: DataTypes.INTEGER,
  },
  liked: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  rate: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  user_id: {
    type: DataTypes.INTEGER,
  },
  images: {
    type: DataTypes.TEXT,
  },
  files: {
    type: DataTypes.TEXT,
  },
  latitude: {
    type: DataTypes.DOUBLE,
  },
  longitude: {
    type: DataTypes.DOUBLE,
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
  module.exports = Igloo;
