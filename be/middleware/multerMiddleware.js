// import multer from 'multer';


// const storage = multer.diskStorage({

//     destination: function (req, file, cb) {
//         const profilePath = './profile_images';
//         return cb(null, profilePath)
//     },
//     filename: function (req, file, cb) {
//         const uniqueName = `${Date.now()}-${file.originalname.replace(/\s+/g, '')}`;
//         cb(null, uniqueName);
//     }

// })


// // File filter to accept only images
// const fileFilter = (req, file, cb) => {
//     const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png'];
//     if (allowedTypes.includes(file.mimetype)) {
//         cb(null, true);
//     } else {
//         console.error('File type not supported', file.mimetype);
//         cb(new Error('Only JPG, JPEG, and PNG files are allowed!'), false);
//     }
// };

// const upload = multer({ storage: storage, fileFilter: fileFilter });

// export default upload;


import multer from 'multer';

// In-memory storage for files (no local storage)
const storage = multer.memoryStorage();

// File filter to accept only images
const fileFilter = (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png'];
    if (allowedTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        console.error('File type not supported:', file.mimetype);
        cb(new Error('Only JPG, JPEG, and PNG files are allowed!'), false);
    }
};

const upload = multer({ storage: storage, fileFilter: fileFilter });

export default upload;
