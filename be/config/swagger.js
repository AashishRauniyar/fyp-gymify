import swaggerJSDoc from 'swagger-jsdoc';

const swaggerOptions = {
    definition: {
        openapi: '3.0.0',
        info: {
            title: 'Gymify API',
            version: '1.0.0',
            description: 'API for Gymify',
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
    apis: ['./routes/*.js'],
};

export const swaggerSpec = swaggerJSDoc(swaggerOptions);
