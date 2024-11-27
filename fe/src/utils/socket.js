// src/utils/socket.js
import { io } from 'socket.io-client';

const socket = io('http://localhost:8000/api'); // Use the correct URL for your backend

export default socket;
