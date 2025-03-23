// const axios = require('axios');
// const FormData = require('form-data');
// const fs = require('fs');

// // Your API endpoint for bulk workout creation
// const API_URL = 'http://localhost:3000/bulk-create-workouts'; // Update with your API URL

// // Define your JWT token for authentication
// const JWT_TOKEN = 'your-jwt-token-here'; // Ensure you have a valid JWT token

// // Sample workout data (you would typically load this from a file or database)
// const workoutsData = [
//     {
//         workout_name: 'Workout 1',
//         description: 'A full-body workout.',
//         target_muscle_group: 'Full Body',
//         difficulty: 'Intermediate',
//         goal_type: 'Muscle_Gain',
//         fitness_level: 'Intermediate',
//         exercises: [
//             { exercise_id: 1, sets: 3, reps: 12, duration: 0 },
//             { exercise_id: 2, sets: 4, reps: 10, duration: 0 }
//         ],
//         // You can refer to an actual image file path here
//         workout_image: 'path/to/image1.jpg' // Make sure this is the correct file path
//     },
//     {
//         workout_name: 'Workout 2',
//         description: 'A lower body workout.',
//         target_muscle_group: 'Legs',
//         difficulty: 'Hard',
//         goal_type: 'Weight_Loss',
//         fitness_level: 'Beginner',
//         exercises: [
//             { exercise_id: 3, sets: 3, reps: 12, duration: 0 }
//         ],
//         // You can refer to an actual image file path here
//         workout_image: 'path/to/image2.jpg' // Make sure this is the correct file path
//     }
// ];

// // Function to upload the workouts with images
// async function bulkCreateWorkouts() {
//     try {
//         // Create FormData for bulk workouts
//         const formData = new FormData();

//         // Add the workout JSON data
//         formData.append('workouts', JSON.stringify(workoutsData));

//         // Loop through the workouts and append images
//         workoutsData.forEach((workout, index) => {
//             const imagePath = workout.workout_image;

//             // Check if the image exists and add it to the form data
//             if (fs.existsSync(imagePath)) {
//                 formData.append(`workout_images[${index}]`, fs.createReadStream(imagePath));
//             } else {
//                 console.log(`Image for ${workout.workout_name} not found at ${imagePath}`);
//             }
//         });

//         // Send the POST request to the API
//         const response = await axios.post(API_URL, formData, {
//             headers: {
//                 'Authorization': `Bearer ${JWT_TOKEN}`, // Pass JWT for authentication
//                 ...formData.getHeaders() // Set the correct headers for form-data
//             }
//         });

//         // Log the server response
//         console.log('Response:', response.data);

//     } catch (error) {
//         console.error('Error posting workouts:', error.response ? error.response.data : error.message);
//     }
// }

// // Run the bulk upload
// bulkCreateWorkouts();


// Example client-side code for bulk uploading workouts
async function bulkUploadWorkouts() {
    // Your workout data
    const workoutsData = {
      workouts: [
        {
          workout_name: "Full Body Blast",
          description: "Complete full body workout",
          target_muscle_group: "Full Body",
          difficulty: "Intermediate",
          goal_type: "Muscle_Gain",
          fitness_level: "Intermediate",
          exercises: [
            {
              exercise_id: 1,
              sets: 3,
              reps: 12,
              duration: 0
            },
            {
              exercise_id: 2,
              sets: 4,
              reps: 10,
              duration: 0
            }
          ]
        },
        {
          workout_name: "HIIT Cardio",
          description: "High intensity interval training",
          target_muscle_group: "Cardiovascular",
          difficulty: "Hard",
          goal_type: "Weight_Loss",
          fitness_level: "Advanced",
          exercises: [
            {
              exercise_id: 3,
              sets: 4,
              reps: 20,
              duration: 30
            }
          ]
        }
      ]
    };
  
    // Create FormData object
    const formData = new FormData();
    
    // Add the workouts data as JSON
    formData.append('workouts', JSON.stringify(workoutsData.workouts));
    
    // Add workout images - assume you have them from file inputs or elsewhere
    // For example, if you have file inputs with IDs 'workout-image-0', 'workout-image-1', etc.
    const workoutImage0 = document.getElementById('workout-image-0').files[0];
    const workoutImage1 = document.getElementById('workout-image-1').files[0];
    
    if (workoutImage0) {
      // Rename the file to match the expected pattern
      const file0 = new File([workoutImage0], 'workout_0.jpg', { type: workoutImage0.type });
      formData.append('workout_images', file0);
    }
    
    if (workoutImage1) {
      const file1 = new File([workoutImage1], 'workout_1.jpg', { type: workoutImage1.type });
      formData.append('workout_images', file1);
    }
    
    // Get your auth token (assuming you store it somewhere)
    const token = "";
    
    try {
      // Make the request
      const response = await fetch('http://localhost:3000/api/bulk-create-workouts', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`
        },
        body: formData
      });
      
      const result = await response.json();
      
      if (response.ok) {
        console.log('Bulk upload successful:', result);
        // Handle success - maybe show a success message
      } else {
        console.error('Bulk upload failed:', result);
        // Handle error - display error message
      }
    } catch (error) {
      console.error('Error during bulk upload:', error);
      // Handle network errors
    }
  }
  
  // Call the function when your form is submitted
  document.getElementById('bulk-upload-form').addEventListener('submit', (e) => {
    e.preventDefault();
    bulkUploadWorkouts();
  });