import { 
    uploadToCloudinary, 
    uploadWorkoutImageToCloudinary,
    uploadExerciseImageToCloudinary,
    uploadExerciseVideoToCloudinary,
    uploadMealPhotoToCloudinary,
    uploadDietPhotoToCloudinary
  } from '../middleware/cloudinaryMiddleware.js';
  import { jest } from '@jest/globals';
  
  // Mock cloudinary
  jest.mock('cloudinary', () => {
    return {
      v2: {
        config: jest.fn(),
        uploader: {
          upload_stream: jest.fn((options, callback) => {
            // Create a mock stream
            const mockStream = {
              end: jest.fn((buffer) => {
                // Simulate successful upload after a small delay
                setTimeout(() => {
                  callback(null, { secure_url: 'https://res.cloudinary.com/mock-url/image.jpg' });
                }, 10);
                return mockStream;
              })
            };
            return mockStream;
          })
        }
      }
    };
  });
  
  // Mock dotenv
  jest.mock('dotenv', () => ({
    config: jest.fn()
  }));
  
  import { v2 as cloudinary } from 'cloudinary';
  
  describe('Cloudinary Middleware', () => {
    // Create a test buffer
    const testBuffer = Buffer.from('test image data');
    
    beforeEach(() => {
      jest.clearAllMocks();
    });
    
    describe('uploadToCloudinary', () => {
      it('should upload image to Cloudinary successfully', async () => {
        const result = await uploadToCloudinary(testBuffer);
        
        expect(cloudinary.uploader.upload_stream).toHaveBeenCalledWith(
          { folder: 'profile_images', resource_type: 'image' },
          expect.any(Function)
        );
        expect(result).toBe('https://res.cloudinary.com/mock-url/image.jpg');
      });
      
      it('should use custom folder when provided', async () => {
        const customFolder = 'custom_folder';
        await uploadToCloudinary(testBuffer, customFolder);
        
        expect(cloudinary.uploader.upload_stream).toHaveBeenCalledWith(
          { folder: customFolder, resource_type: 'image' },
          expect.any(Function)
        );
      });
      
      it('should handle upload errors', async () => {
        // Mock upload_stream to simulate an error
        cloudinary.uploader.upload_stream.mockImplementationOnce((options, callback) => {
          const mockStream = {
            end: jest.fn(() => {
              setTimeout(() => {
                callback({ error: 'Upload failed' }, null);
              }, 10);
              return mockStream;
            })
          };
          return mockStream;
        });
        
        await expect(uploadToCloudinary(testBuffer)).rejects.toEqual({ error: 'Upload failed' });
      });
    });
    
    describe('uploadWorkoutImageToCloudinary', () => {
      it('should upload workout image successfully', async () => {
        const result = await uploadWorkoutImageToCloudinary(testBuffer);
        
        expect(cloudinary.uploader.upload_stream).toHaveBeenCalledWith(
          { folder: 'workout_images', resource_type: 'image' },
          expect.any(Function)
        );
        expect(result).toBe('https://res.cloudinary.com/mock-url/image.jpg');
      });
    });
    
    describe('uploadExerciseImageToCloudinary', () => {
      it('should upload exercise image successfully', async () => {
        const result = await uploadExerciseImageToCloudinary(testBuffer);
        
        expect(cloudinary.uploader.upload_stream).toHaveBeenCalledWith(
          { folder: 'exercise_images', resource_type: 'image' },
          expect.any(Function)
        );
        expect(result).toBe('https://res.cloudinary.com/mock-url/image.jpg');
      });
    });
    
    describe('uploadExerciseVideoToCloudinary', () => {
      it('should upload exercise video successfully', async () => {
        const result = await uploadExerciseVideoToCloudinary(testBuffer);
        
        expect(cloudinary.uploader.upload_stream).toHaveBeenCalledWith(
          { folder: 'exercise_videos', resource_type: 'video' },
          expect.any(Function)
        );
        expect(result).toBe('https://res.cloudinary.com/mock-url/image.jpg');
      });
    });
    
    describe('uploadMealPhotoToCloudinary', () => {
      it('should upload meal photo successfully', async () => {
        const result = await uploadMealPhotoToCloudinary(testBuffer);
        
        expect(cloudinary.uploader.upload_stream).toHaveBeenCalledWith(
          { folder: 'meal_images', resource_type: 'image' },
          expect.any(Function)
        );
        expect(result).toBe('https://res.cloudinary.com/mock-url/image.jpg');
      });
    });
    
    describe('uploadDietPhotoToCloudinary', () => {
      it('should upload diet photo successfully', async () => {
        const result = await uploadDietPhotoToCloudinary(testBuffer);
        
        expect(cloudinary.uploader.upload_stream).toHaveBeenCalledWith(
          { folder: 'diet_images', resource_type: 'image' },
          expect.any(Function)
        );
        expect(result).toBe('https://res.cloudinary.com/mock-url/image.jpg');
      });
    });
  });