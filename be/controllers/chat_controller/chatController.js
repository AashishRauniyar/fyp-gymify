import prisma from '../../prisma/prisma.js';


export const getAllConversations = async (req, res) => {
    const { userId } = req.params;

    if (!userId || isNaN(userId)) {
        return res.status(400).json({
            status: "failure",
            message: "Invalid or missing userId",
        });
    }

    try {
        const conversations = await prisma.chatconversations.findMany({
            where: {
                OR: [{ user_id: parseInt(userId) }, { trainer_id: parseInt(userId) }],
            },
            include: {
                users_chatconversations_user_idTousers: true,
                users_chatconversations_trainer_idTousers: true,
                chatmessages: {
                    orderBy: { sent_at: "desc" },
                    take: 1, // Include only the last message for preview
                },
            },
        });

        res.status(200).json({
            status: "success",
            message: "Conversations fetched successfully",
            data: conversations,
        });
    } catch (error) {
        console.error(`Error fetching conversations for userId ${userId}:`, error);
        res.status(500).json({
            status: "failure",
            message: "Server error while fetching conversations",
        });
    }
};


export const getMessagesByChatId = async (req, res) => {
    const { chatId } = req.params;
    const { limit = 50, offset = 0 } = req.query; // Default pagination

    if (!chatId || isNaN(chatId)) {
        return res.status(400).json({
            status: "failure",
            message: "Invalid or missing chatId",
        });
    }

    try {
        const messages = await prisma.chatmessages.findMany({
            where: { chat_id: parseInt(chatId) },
            orderBy: { sent_at: "asc" },
            skip: parseInt(offset),
            take: parseInt(limit),
        });

        res.status(200).json({
            status: "success",
            message: "Messages fetched successfully",
            data: messages,
        });
    } catch (error) {
        console.error(`Error fetching messages for chatId ${chatId}:`, error);
        res.status(500).json({
            status: "failure",
            message: "Server error while fetching messages",
        });
    }
};


export const startConversation = async (req, res) => {
    const { userId, trainerId } = req.body;

    if (!userId || !trainerId || isNaN(userId) || isNaN(trainerId) || userId === trainerId) {
        return res.status(400).json({
            status: "failure",
            message: "Invalid userId or trainerId",
        });
    }

    try {
        const sortedIds = [userId, trainerId].sort((a, b) => a - b); // Ensure consistent order
        const chatId = parseInt(sortedIds.join("")); // Combine IDs into a numeric valu/ Combine IDs into a numeric value

        let conversation = await prisma.chatconversations.findUnique({
            where: { chat_id: chatId },
        });

        if (!conversation) {
            conversation = await prisma.chatconversations.create({
                data: {
                    chat_id: chatId,
                    user_id: userId,
                    trainer_id: trainerId,
                },
            });
        }

        res.status(201).json({
            status: "success",
            message: "Conversation started",
            data: conversation,
        });
    } catch (error) {
        console.error("Error starting conversation:", error);
        res.status(500).json({
            status: "failure",
            message: "Server error while starting conversation",
        });
    }
};



export const sendMessage = async (req, res) => {
    const { chatId, senderId, messageContent } = req.body;

    if (!chatId || !senderId || !messageContent?.text) {
        return res.status(400).json({
            status: "failure",
            message: "Invalid chatId, senderId, or messageContent",
        });
    }

    try {
        const conversation = await prisma.chatconversations.findUnique({
            where: { chat_id: chatId },
        });

        if (!conversation) {
            return res.status(404).json({
                status: "failure",
                message: "Conversation not found",
            });
        }

        const newMessage = await prisma.chatmessages.create({
            data: {
                chat_id: chatId,
                sender_id: senderId,
                message_content: messageContent,
                sent_at: new Date(),
                is_read: false,
            },
        });

        await prisma.chatconversations.update({
            where: { chat_id: chatId },
            data: {
                last_message: messageContent.text,
                last_message_timestamp: new Date(),
            },
        });

        res.status(201).json({
            status: "success",
            message: "Message sent successfully",
            data: newMessage,
        });
    } catch (error) {
        console.error("Error sending message:", error);
        res.status(500).json({
            status: "failure",
            message: "Server error while sending message",
        });
    }
};



export const markMessagesAsRead = async (req, res) => {
    const { chatId } = req.params;

    if (!chatId || isNaN(chatId)) {
        return res.status(400).json({
            status: "failure",
            message: "Invalid or missing chatId",
        });
    }

    try {
        const updatedMessages = await prisma.chatmessages.updateMany({
            where: { chat_id: parseInt(chatId), is_read: false },
            data: { is_read: true },
        });

        res.status(200).json({
            status: "success",
            message: "Messages marked as read",
            data: { count: updatedMessages.count },
        });
    } catch (error) {
        console.error("Error marking messages as read:", error);
        res.status(500).json({
            status: "failure",
            message: "Server error while marking messages as read",
        });
    }
};
