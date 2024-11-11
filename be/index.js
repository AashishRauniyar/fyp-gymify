import dotenv from 'dotenv';
import express from 'express';
import router from './routes/routes.js';

dotenv.config();

const app = express();
app.use(express.json());

// Routes
app.use('/api', router);

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
