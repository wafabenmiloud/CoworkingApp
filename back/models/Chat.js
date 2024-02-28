// Import the required dependencies
const { Sequelize, DataTypes } = require('sequelize');

// Create a Sequelize instance
const sequelize = new Sequelize(process.env.DATABASE, process.env.USER, '', {
  host: process.env.HOST,
  dialect: 'mysql',
});

// Define the Conversation model
const Conversation = sequelize.define('conversation', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  chatID: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  name: {
    type: DataTypes.STRING,
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: Sequelize.NOW,
  },
  updatedAt: {
    type: DataTypes.DATE,
    defaultValue: Sequelize.NOW,
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

// Export the Conversation model
module.exports = Conversation;
