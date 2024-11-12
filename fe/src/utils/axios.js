import axios from "axios";


export const userInstance = axios.create({
    baseURL: "http://localhost:8000/api",
});

