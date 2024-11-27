
import express from 'express';
import { createChat, getMessages, sendMessage } from '../controllers/chat_controller/chatController.js';

const chatRouter = express.Router();


// REST API endpoints for chat
// chatRouter.get('/:chatId/messages', validateChatId ,getChatMessages);
// chatRouter.post('/:chatId/messages', validateChatId ,saveChatMessage);

// Route to create a new chat conversation
chatRouter.post('/create', createChat);

// Route to get all messages for a specific chat
chatRouter.get('/:chatId/messages', getMessages);

// Route to send a message (used via socket as well, but also can be used in API)
chatRouter.post('/send', sendMessage);

export default chatRouter;