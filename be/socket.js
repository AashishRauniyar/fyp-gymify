import { Server } from "socket.io";
import prisma from "./prisma/prisma.js"; // Import the singleton Prisma client

const connectedUsers = {}; // Unified map to store userId <-> socketId pairs

const initSocket = (server) => {
    console.log("Initializing Socket.IO");
    const io = new Server(server, {
        cors: {
            origin: "*", // Allow all origins for development; restrict in production
            methods: ["GET", "POST"],
        },
    });

    io.on("connection", (socket) => {
        console.log(`Client connected: ${socket.id}`);

        // **Register Event**
        socket.on("register", async ({ userId }) => {
            try {
                if (!userId) {
                    throw new Error("UserId is required for registration.");
                }

                const numericUserId = parseInt(userId); // Ensure userId is a number

                const user = await prisma.users.findUnique({
                    where: { user_id: numericUserId },
                });

                if (!user) {
                    throw new Error(`User with ID ${numericUserId} not found in the database.`);
                }

                // Handle duplicate registration (disconnect old socket if exists)
                if (connectedUsers[numericUserId]) {
                    const oldSocketId = connectedUsers[numericUserId];
                    io.sockets.sockets.get(oldSocketId)?.disconnect();
                    console.log(`Disconnected old socket for user ${numericUserId}`);
                }

                // Register new connection
                connectedUsers[numericUserId] = socket.id;
                socket.emit("register-success", {
                    message: "You are registered successfully.",
                });
                console.log(`User ${numericUserId} registered with Socket-ID: ${socket.id}`);
            } catch (error) {
                socket.emit("register-error", { message: error.message });
                console.error(`Register error: ${error.message}`);
            }
        });

        // **Join Room**
        socket.on("join_room", async ({ chatId, userId }) => {
            try {
                const numericUserId = parseInt(userId); // Ensure userId is a number
                const numericChatId = parseInt(chatId); // Ensure chatId is a number

                console.log("Connected Users:", connectedUsers);

                if (!connectedUsers[numericUserId]) {
                    throw new Error("User is not registered. Please register first.");
                }

                if (!numericChatId) {
                    throw new Error("ChatId is required.");
                }

                const conversation = await prisma.chatconversations.findUnique({
                    where: { chat_id: numericChatId },
                });

                if (!conversation) {
                    throw new Error("Chat room not found.");
                }

                if (![conversation.user_id, conversation.trainer_id].includes(numericUserId)) {
                    throw new Error("Access denied to the chat room.");
                }

                socket.join(numericChatId);
                console.log(`User ${numericUserId} joined chat room: ${numericChatId}`);
                socket.emit("joined_room", {
                    chatId: numericChatId,
                    status: "success",
                    message: "Successfully joined the room.",
                });
            } catch (error) {
                socket.emit("join-room-error", { message: error.message });
                console.error(`Join room error: ${error.message}`);
            }
        });

        // **Send Message**
        socket.on("send_message", async ({ chatId, userId, messageContent }) => {
            try {
                const numericUserId = parseInt(userId);
                const numericChatId = parseInt(chatId);

                if (!connectedUsers[numericUserId]) {
                    throw new Error("User is not registered. Please register first.");
                }

                if (!numericChatId || !messageContent?.text) {
                    throw new Error("ChatId and message content are required.");
                }

                const conversation = await prisma.chatconversations.findUnique({
                    where: { chat_id: numericChatId },
                });

                if (!conversation) {
                    throw new Error("Chat room not found.");
                }

                if (![conversation.user_id, conversation.trainer_id].includes(numericUserId)) {
                    throw new Error("Access denied to the chat room.");
                }

                const newMessage = await prisma.chatmessages.create({
                    data: {
                        chat_id: numericChatId,
                        sender_id: numericUserId,
                        message_content: messageContent,
                    },
                });

                await prisma.chatconversations.update({
                    where: { chat_id: numericChatId },
                    data: {
                        last_message: messageContent.text,
                        last_message_timestamp: new Date(),
                    },
                });

                console.log(`Emitting message to room: ${numericChatId}`); // Log the emission
                console.log(newMessage); // Log the new message object

                io.to(numericChatId).emit("receive_message", newMessage);

                socket.emit("message_sent", {
                    status: "success",
                    message: "Message delivered successfully.",
                    data: newMessage,
                });
            } catch (error) {
                socket.emit("send-message-error", { message: error.message });
                console.error(`Send message error: ${error.message}`);
            }
        });


        socket.on("user_typing", ({ chatId, userId }) => {
            try {
                const numericUserId = parseInt(userId);
                const numericChatId = parseInt(chatId);

                if (!connectedUsers[numericUserId]) {
                    throw new Error("User is not registered. Please register first.");
                }

                if (!numericChatId) {
                    throw new Error("ChatId is required.");
                }

                // Broadcast the typing event to other users in the room
                socket.to(numericChatId).emit("user_typing", {
                    chatId: numericChatId,
                    userId: numericUserId,
                });

                console.log(`User ${numericUserId} is typing in chat room ${numericChatId}`);
            } catch (error) {
                socket.emit("typing-error", { message: error.message });
                console.error(`Typing error: ${error.message}`);
            }
        });

        socket.on("user_stopped_typing", ({ chatId, userId }) => {
            try {
                const numericUserId = parseInt(userId);
                const numericChatId = parseInt(chatId);

                if (!connectedUsers[numericUserId]) {
                    throw new Error("User is not registered. Please register first.");
                }

                if (!numericChatId) {
                    throw new Error("ChatId is required.");
                }

                // Broadcast the stopped typing event to other users in the room
                socket.to(numericChatId).emit("user_stopped_typing", {
                    chatId: numericChatId,
                    userId: numericUserId,
                });

                console.log(`User ${numericUserId} stopped typing in chat room ${numericChatId}`);
            } catch (error) {
                socket.emit("stopped-typing-error", { message: error.message });
                console.error(`Stopped typing error: ${error.message}`);
            }
        });


        // for attendance


        // **Handle Disconnection**
        socket.on("disconnect", () => {
            const userId = Object.keys(connectedUsers).find(
                (key) => connectedUsers[key] === socket.id
            );

            if (userId) {
                delete connectedUsers[userId];
                console.log(`User ${userId} disconnected. Removed from connected users.`);
            } else {
                console.log(`Socket disconnected: ${socket.id}`);
            }
        });
    });
};

export default initSocket;

