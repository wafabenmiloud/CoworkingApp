const ChatMessage = require('../models/Message');
const Conversation  = require('../models/Chat');

const addConversation  = async (chatID, userID, name) => {
  try {
    const conversation = await Conversation.findOne({ where: { chatID } });
    if (!conversation) {
      await Conversation.create({ chatID, name});
    } else {
        await conversation.save();
        console.log(conversation);
    }
  } catch (error) {
    console.error('Failed to add conversation:', error);
  }
};
const addMessage  = async (chatID, sender, content) => {
  try {
    await ChatMessage.create({ chatID, sender, content });
  } catch (error) {
    console.error('Failed to add message:', error);
  }
};

const getMessagesByChatID  = async (chatID) => {
  try {
    const messages = await ChatMessage.findAll({
      where: { chatID },
      order: [['timestamp', 'ASC']],
    });
    return messages;
  } catch (error) {
    console.error('Failed to get messages:', error);
    return [];
  }
}

module.exports = {
  addConversation,
  addMessage,
  getMessagesByChatID
}