// import { PrismaClient } from "@prisma/client";
// import { Server } from "socket.io";

// const prisma = new PrismaClient();
// const connectedUserIdToSocketId = new Map();

// const initSocket = (server) => {
//     console.log("Initializing Socket.IO");
//     const io = new Server(server, {
//         cors: {
//             origin: "*", // Allow all origins for development; restrict in production
//             methods: ["GET", "POST"],
//         },
//     },    // Standard path for WebSocket
//     );


//     // Utility: Get userId from socketId
//     const getUserIdFromSocketId = (socketId) => {
//         return Array.from(connectedUserIdToSocketId.entries()).find(
//             ([userId, sId]) => sId === socketId
//         )?.[0];
//     };

//     io.on("connection", (socket) => {
//         console.log("A user connected with Socket-ID:", socket.id);

//         console.log("Client connected:", socket.id);

//         // **Register Event**
//         socket.on("register", async (data) => {
//             try {
//                 console.log("Received register event with data:", data);
//                 const { userId } = data;
//                 console.log(userId);

//                 if (!userId) {
//                     console.error("UserId is required for registration.");
//                     throw new Error("UserId is required for registration.");
//                 }

//                 const user = await prisma.users.findUnique({
//                     where: { user_id: userId },
//                 });

//                 if (!user) {
//                     console.error(`User with ID ${userId} not found in the database.`);
//                     throw new Error(`User with ID ${userId} not found.`);
//                 }

//                 if (connectedUserIdToSocketId.has(userId)) {
//                     console.error(`User with ID ${userId} is already connected.`);
//                     throw new Error("User already connected.");
//                 }

//                 connectedUserIdToSocketId.set(userId, socket.id);
//                 socket.emit("register-success", {
//                     message: "You are registered successfully.",
//                 });
//                 console.log(`User ${userId} registered with Socket-ID: ${socket.id}`);
//             } catch (error) {
//                 socket.emit("register-error", { message: error.message });
//                 console.error("Register error:", error.message);
//             }
//         });


//         // **Join Room**
//         socket.on("join_room", async ({ chatId, userId }) => {
//             try {
//                 // Validate if the user is registered
//                 if (!connectedUserIdToSocketId.has(userId)) {
//                     throw new Error("User is not registered. Please register first.");
//                 }

//                 // Validate user's access to the chat room
//                 const conversation = await prisma.chatconversations.findFirst({
//                     where: {
//                         chat_id: chatId,
//                         OR: [{ user_id: userId }, { trainer_id: userId }],
//                     },
//                 });

//                 if (!conversation) {
//                     throw new Error("Access denied to the chat room.");
//                 }

//                 socket.join(chatId); // Join the room
//                 console.log(`User ${userId} joined chat room: ${chatId}`);
//                 socket.emit("joined_room", {
//                     chatId,
//                     status: "success",
//                     message: "Successfully joined the room.",
//                 });
//             } catch (error) {
//                 socket.emit("join-room-error", { message: error.message });
//                 console.error("Join room error:", error.message);
//             }
//         });

//         // **Send Message**
//         socket.on("send_message", async (data) => {
//             const { chatId, userId, messageContent } = data;

//             try {
//                 // Validate if the user is registered
//                 if (!connectedUserIdToSocketId.has(userId)) {
//                     throw new Error("User is not registered. Please register first.");
//                 }

//                 if (!chatId || !messageContent || !messageContent.text) {
//                     throw new Error("Invalid message format.");
//                 }

//                 // Validate chat room access
//                 const conversation = await prisma.chatconversations.findFirst({
//                     where: {
//                         chat_id: chatId,
//                         OR: [{ user_id: userId }, { trainer_id: userId }],
//                     },
//                 });

//                 if (!conversation) {
//                     throw new Error("User does not have access to the chat room.");
//                 }

//                 // Save the message in the database
//                 const newMessage = await prisma.chatmessages.create({
//                     data: {
//                         chat_id: chatId,
//                         sender_id: userId,
//                         message_content: messageContent,
//                     },
//                 });

//                 // Update the last message in the conversation
//                 await prisma.chatconversations.update({
//                     where: { chat_id: chatId },
//                     data: {
//                         last_message: messageContent.text,
//                         last_message_timestamp: new Date(),
//                     },
//                 });

//                 // Emit the message to all users in the room
//                 io.to(chatId).emit("receive_message", newMessage);

//                 // Send acknowledgment to the sender
//                 socket.emit("message_sent", {
//                     status: "success",
//                     message: "Message delivered successfully.",
//                     data: newMessage,
//                 });
//             } catch (error) {
//                 socket.emit("send-message-error", { message: error.message });
//                 console.error("Send message error:", error.message);
//             }
//         });

//         // **Typing Indicators**
//         socket.on("typing", ({ chatId, userId }) => {
//             socket.to(chatId).emit("user_typing", { chatId, userId });
//         });

//         socket.on("stop_typing", ({ chatId, userId }) => {
//             socket.to(chatId).emit("user_stopped_typing", { chatId, userId });
//         });

//         // **Handle Disconnection**
//         socket.on("disconnect", () => {
//             const userId = getUserIdFromSocketId(socket.id);
//             if (userId) {
//                 connectedUserIdToSocketId.delete(userId);
//                 console.log(`User ${userId} disconnected. Socket-ID: ${socket.id}`);
//             } else {
//                 console.log(`Socket disconnected: ${socket.id}`);
//             }
//         });
//     });
// };

// export default initSocket;






import { PrismaClient } from "@prisma/client";
import { Server } from "socket.io";

const prisma = new PrismaClient();
const connectedUserIdToSocketId = new Map();

const initSocket = (server) => {
    console.log("Initializing Socket.IO");
    const io = new Server(server, {
        cors: {
            origin: "*", // Allow all origins for development; restrict in production
            methods: ["GET", "POST"],
        },
    });

    // Utility: Get userId from socketId
    const getUserIdFromSocketId = (socketId) => {
        return Array.from(connectedUserIdToSocketId.entries()).find(
            ([userId, sId]) => sId === socketId
        )?.[0];
    };

    io.on("connection", (socket) => {
        console.log(`Client connected: ${socket.id}`);

        // **Register Event**
        socket.on("register", async ({ userId }) => {
            try {
                if (!userId) {
                    throw new Error("UserId is required for registration.");
                }

                const user = await prisma.users.findUnique({
                    where: { user_id: parseInt(userId) },
                });

                if (!user) {
                    throw new Error(`User with ID ${userId} not found in the database.`);
                }

                if (connectedUserIdToSocketId.has(userId)) {
                    throw new Error("User is already connected.");
                }

                connectedUserIdToSocketId.set(userId, socket.id);
                socket.emit("register-success", {
                    message: "You are registered successfully.",
                });
                console.log(`User ${userId} registered with Socket-ID: ${socket.id}`);
            } catch (error) {
                socket.emit("register-error", { message: error.message });
                console.error(`Register error: ${error.message}`);
            }
        });

        // **Join Room**
        socket.on("join_room", async ({ chatId, userId }) => {
            try {
                if (!connectedUserIdToSocketId.has(userId)) {
                    throw new Error("User is not registered. Please register first.");
                }

                if (!chatId) {
                    throw new Error("ChatId is required.");
                }

                const conversation = await prisma.chatconversations.findUnique({
                    where: { chat_id: chatId },
                });

                if (!conversation) {
                    throw new Error("Chat room not found.");
                }

                if (![conversation.user_id, conversation.trainer_id].includes(parseInt(userId))) {
                    throw new Error("Access denied to the chat room.");
                }

                socket.join(chatId);
                console.log(`User ${userId} joined chat room: ${chatId}`);
                socket.emit("joined_room", {
                    chatId,
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
                if (!connectedUserIdToSocketId.has(userId)) {
                    throw new Error("User is not registered. Please register first.");
                }

                if (!chatId || !messageContent?.text) {
                    throw new Error("ChatId and message content are required.");
                }

                const conversation = await prisma.chatconversations.findUnique({
                    where: { chat_id: chatId },
                });

                if (!conversation) {
                    throw new Error("Chat room not found.");
                }

                if (![conversation.user_id, conversation.trainer_id].includes(parseInt(userId))) {
                    throw new Error("Access denied to the chat room.");
                }

                const newMessage = await prisma.chatmessages.create({
                    data: {
                        chat_id: chatId,
                        sender_id: userId,
                        message_content: messageContent,
                    },
                });

                await prisma.chatconversations.update({
                    where: { chat_id: chatId },
                    data: {
                        last_message: messageContent.text,
                        last_message_timestamp: new Date(),
                    },
                });

                io.to(chatId).emit("receive_message", newMessage);
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

        // **Typing Indicators**
        socket.on("typing", ({ chatId, userId }) => {
            if (!chatId || !userId) return;
            socket.to(chatId).emit("user_typing", { chatId, userId });
        });

        socket.on("stop_typing", ({ chatId, userId }) => {
            if (!chatId || !userId) return;
            socket.to(chatId).emit("user_stopped_typing", { chatId, userId });
        });

        // **Handle Disconnection**
        socket.on("disconnect", () => {
            const userId = getUserIdFromSocketId(socket.id);
            if (userId) {
                connectedUserIdToSocketId.delete(userId);
                console.log(`User ${userId} disconnected. Socket-ID: ${socket.id}`);
            } else {
                console.log(`Socket disconnected: ${socket.id}`);
            }
        });
    });
};

export default initSocket;

