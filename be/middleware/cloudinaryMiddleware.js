// import { v2 as cloudinary } from 'cloudinary';
// import dotenv from 'dotenv';
// import fs from 'fs';


// dotenv.config();

// // Cloudinary configuration
// cloudinary.config({
//     cloud_name: process.env.CLOUD_NAME,
//     api_key: process.env.CLOUDINARY_API_KEY,
//     api_secret: process.env.CLOUDINARY_API_SECRET,
// });

// export const uploadToCloudinary = async (imagePath) => {
//     try {
//         if(!imagePath) return;
//         const uploadedImage = await cloudinary.uploader.upload(imagePath, {
//             folder: 'profile_images',
//             resource_type: 'image'
//         });
//         console.log("uploadedImage", uploadedImage.url);
//         return uploadedImage.url;
        
//     } catch (error) {
//         fs.unlinkSync(imagePath); // remove the image from the server as it was not uploaded to cloudinary

//         console.log("Error uploading image to cloudinary", error);
//         return null;
//     }
// }


import { v2 as cloudinary } from 'cloudinary';
import dotenv from 'dotenv';

dotenv.config();

// Cloudinary configuration
cloudinary.config({
    cloud_name: process.env.CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Upload file buffer to Cloudinary
export const uploadToCloudinary = async (buffer, folder = 'profile_images') => {
    return new Promise((resolve, reject) => {
        const stream = cloudinary.uploader.upload_stream(
            { folder, resource_type: 'image' },
            (error, result) => {
                if (error) {
                    console.error('Cloudinary upload error:', error);
                    reject(error);
                } else {
                    resolve(result.secure_url); // Return the Cloudinary URL
                }
            }
        );

        // Pipe the buffer into the Cloudinary upload stream
        stream.end(buffer);
    });
};
