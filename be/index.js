import dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import swaggerUi from 'swagger-ui-express';
import mainRouter from './routes/routes.js';

import { swaggerSpec } from './config/swagger.js';

dotenv.config();

// Create express app
const app = express();

// for cross origin requests
app.use(cors());
// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec))
app.use(mainRouter);


const PORT = process.env.PORT || 8000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
});


