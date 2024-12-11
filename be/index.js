import dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import swaggerUi from 'swagger-ui-express';
import mainRouter from './routes/routes.js';
import swaggerJSDoc from 'swagger-jsdoc';
dotenv.config();

// Create express app
const app = express();

// for cross origin requests
app.use(cors());
// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


// Swagger Setup
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Gymify API ',
      version: '1.0.0',
      description: 'API to test gymify',
      contact: {
        name: 'Aashish Prasad Gupta',
        email: 'rauniyaaraashish@gmail.com',
      },
    },
    servers: [
      {
        url: 'http://localhost:8000/api', 
      },
    ],
    components: {
      securitySchemes: {
        BearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
  },
  apis: ['./routes/*.js'],  // Path to your API files (where JSDoc comments are present)
};

const swaggerSpec = swaggerJSDoc(swaggerOptions);

// Serve Swagger UI
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));


app.use(mainRouter);



const PORT = process.env.PORT || 8000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
});


