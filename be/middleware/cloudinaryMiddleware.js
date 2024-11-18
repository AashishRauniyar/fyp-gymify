import { v2 as cloudinary } from 'cloudinary';
import dotenv from 'dotenv';
import fs from 'fs';


dotenv.config();

// Cloudinary configuration
cloudinary.config({
    cloud_name: process.env.CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
});

export const uploadToCloudinary = async (imagePath) => {
    try {
        if(!imagePath) return;
        const uploadedImage = await cloudinary.uploader.upload(imagePath, {
            folder: 'profile_images',
            resource_type: 'image'
        });
        console.log("uploadedImage", uploadedImage.url);
        return uploadedImage.url;
        
    } catch (error) {
        fs.unlinkSync(imagePath); // remove the image from the server as it was not uploaded to cloudinary

        console.log("Error uploading image to cloudinary", error);
        return null;
    }
}