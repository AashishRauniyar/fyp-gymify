

import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import {
    getAllConversations,
    getMessagesByChatId,
    startConversation,
    sendMessage,
    markMessagesAsRead,
} from "../controllers/chat_controller/chatController.js";

const chatRouter = express.Router();

// // Get all conversations for a user
// chatRouter.get("/conversations/:userId", authenticate, getAllConversations);

// // Get messages for a specific chat
// chatRouter.get("/messages/:chatId", authenticate, getMessagesByChatId);

// // Start a new conversation
// chatRouter.post("/start", authenticate, startConversation);

// // Send a message
// chatRouter.post("/message", authenticate, sendMessage);

// // Mark all messages in a conversation as read
// chatRouter.put("/messages/read/:chatId", authenticate, markMessagesAsRead);



// Get all conversations for a user
chatRouter.get("/conversations/:userId", getAllConversations);

// Get messages for a specific chat
chatRouter.get("/messages/:chatId", getMessagesByChatId);

// Start a new conversation
chatRouter.post("/start", startConversation);

// Send a message
chatRouter.post("/message", sendMessage);

// Mark all messages in a conversation as read
chatRouter.put("/messages/read/:chatId", markMessagesAsRead);

export default chatRouter;
