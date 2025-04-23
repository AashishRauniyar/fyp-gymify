import multer from 'multer';

// In-memory storage for files (no local storage)
const storage = multer.memoryStorage();

// File filter to accept both images and videos
const fileFilter = (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'video/mp4', 'video/mov', 'video/avi'];
    if (allowedTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        console.error('File type not supported:', file.mimetype);
        cb(new Error('Only JPG, JPEG, PNG, WebP, MP4, MOV, AVI files are allowed!'), false);
    }
};

const upload = multer({ storage: storage, fileFilter: fileFilter });

export default upload;
