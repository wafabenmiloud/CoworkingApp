const { Sequelize, DataTypes } = require('sequelize');

const dotenv = require('dotenv');
dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE, process.env.USER, '', {
  host: process.env.HOST,
  dialect: 'mysql',
});

const ChatMessage = sequelize.define('message', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  sender: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  chatID: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  timestamp: {
    type: DataTypes.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
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
  module.exports = ChatMessage;
