// import dotenv from 'dotenv';
// import express from 'express';
// import cors from 'cors';
// import swaggerUi from 'swagger-ui-express';
// import mainRouter from './routes/routes.js';

// import { swaggerSpec } from './config/swagger.js';

// dotenv.config();

// // Create express app
// const app = express();

// // for cross origin requests
// app.use(cors());
// // Middlewares
// app.use(express.json());
// app.use(express.urlencoded({ extended: true }));
// app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec))
// app.use(mainRouter);


// const PORT = process.env.PORT || 8000;
// app.listen(PORT, '0.0.0.0', () => {
//   console.log(`Server is running on port ${PORT}`);
// });


//!-----------------------------------


import dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import swaggerUi from 'swagger-ui-express';
import http from 'http'; // Import HTTP server
import mainRouter from './routes/routes.js';
import { swaggerSpec } from './config/swagger.js';
import initSocket from './socket.js'; 

dotenv.config();

// Create express app
const app = express();

// for cross-origin requests
// app.use(cors());

// allow cors to all origins
app.use(cors({ origin: '*' }));

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.use(mainRouter);
app.set('trust proxy', 1);

// Create an HTTP server to attach Socket.IO
const server = http.createServer(app);

// Initialize Socket.IO
initSocket(server); // Pass the server instance to initSocket

// Start the server
const PORT = process.env.PORT || 8000;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
});


