import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();


export const socketController = (socket, io) => {
    // When a user connects to the socket server
    console.log('User connected: ' + socket.id);

    // Listen for joining a specific chat
    socket.on('joinChat', (chatId) => {
        socket.join(chatId);
        console.log(`User joined chat: ${chatId}`);
    });

    // Send message to a specific chat room
    socket.on('sendMessage', async (data) => {
        const { chatId, senderId, message } = data;

        try {
            // Save the message to the database
            const newMessage = await prisma.chatmessages.create({
                chat_id: chatId,
                sender_id: senderId,
                message_content: JSON.stringify({ text: message }), // Assuming message is JSON for flexibility
            });

            // Broadcast the message to the chat room
            io.to(chatId).emit('messageReceived', {
                chatId,
                messageId: newMessage.message_id,
                senderId,
                message,
                sentAt: newMessage.sent_at,
            });

            console.log('Message sent: ', message);
        } catch (error) {
            console.error('Error sending message: ', error);
        }
    });

    // Handle user disconnect
    socket.on('disconnect', () => {
        console.log('User disconnected: ' + socket.id);
    });
};

// API to create a new chat conversation
export const createChat = async (req, res) => {
    const { userId, trainerId } = req.body;

    try {
        // Check if a conversation already exists between the user and trainer
        const existingChat = await prisma.chatconversations.findOne({
            where: {
                [Op.or]: [
                    { user_id: userId, trainer_id: trainerId },
                    { user_id: trainerId, trainer_id: userId },
                ],
            },
        });

        if (existingChat) {
            return res.status(200).json({ chatId: existingChat.chat_id });
        }

        // If no chat exists, create a new one
        const newChat = await prisma.chatconversations.create({
            user_id: userId,
            trainer_id: trainerId,
        });

        res.status(201).json({ chatId: newChat.chat_id });
    } catch (error) {
        console.error('Error creating chat: ', error);
        res.status(500).json({ error: 'Failed to create chat' });
    }
};

// API to get all messages for a particular chat
export const getMessages = async (req, res) => {
    const { chatId } = req.params;

    try {
        const messages = await prisma.chatmessages.findAll({
            where: { chat_id: chatId },
            order: [['sent_at', 'ASC']],
        });

        res.status(200).json(messages);
    } catch (error) {
        console.error('Error fetching messages: ', error);
        res.status(500).json({ error: 'Failed to fetch messages' });
    }
};

// API to send a message (this is used via socket for real-time updates)
export const sendMessage = async (req, res) => {
    const { chatId, senderId, message } = req.body;

    try {
        const newMessage = await prisma.chatmessages.create({
            chat_id: chatId,
            sender_id: senderId,
            message_content: JSON.stringify({ text: message }),
        });

        res.status(200).json({ messageId: newMessage.message_id, sentAt: newMessage.sent_at });
    } catch (error) {
        console.error('Error sending message: ', error);
        res.status(500).json({ error: 'Failed to send message' });
    }
};
