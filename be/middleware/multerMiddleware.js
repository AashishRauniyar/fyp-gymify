
// //? working for all 
// import multer from 'multer';

// // In-memory storage for files (no local storage)
// const storage = multer.memoryStorage();

// // File filter to accept only images
// const fileFilter = (req, file, cb) => {
//     const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png'];
//     if (allowedTypes.includes(file.mimetype)) {
//         cb(null, true);
//     } else {
//         console.error('File type not supported:', file.mimetype);
//         cb(new Error('Only JPG, JPEG, and PNG files are allowed!'), false);
//     }
// };

// const upload = multer({ storage: storage, fileFilter: fileFilter });

// export default upload;



import multer from 'multer';

// In-memory storage for files (no local storage)
const storage = multer.memoryStorage();

// File filter to accept both images and videos
const fileFilter = (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'video/mp4', 'video/mov', 'video/avi'];
    if (allowedTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        console.error('File type not supported:', file.mimetype);
        cb(new Error('Only JPG, JPEG, PNG, MP4, MOV, AVI files are allowed!'), false);
    }
};

const upload = multer({ storage: storage, fileFilter: fileFilter });

export default upload;
