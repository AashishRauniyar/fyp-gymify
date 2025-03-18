// routes/routes.js
import express from 'express';

const testRouter = express.Router();

// Test endpoint
testRouter.get('/test', (req, res) => {
  res.json({ message: 'Test endpoint is working!' });
});

// You can add more routes here

export default testRouter;
