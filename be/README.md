## Backend Implementation and Design

| **Method** | **Endpoint** | **Protected** | **Description** | **Required Headers** | **Request Body** |
|------------|--------------|----------------|------------------|----------------------|-------------------|
| **POST**   | `/register` | No             | Registers a new user. | None | `{ user_name, full_name, email, password, phone_number, ... }` |
| **POST**   | `/login`    | No             | Logs in a user and returns a JWT token. | None | `{ email, password }` |
| **GET**    | `/profile`  | Yes            | Gets the logged-in user's profile. | `Authorization: Bearer <token>` | None |
| **PUT**    | `/profile`  | Yes            | Updates the logged-in user's profile. | `Authorization: Bearer <token>` | `{ full_name, phone_number, address, ... }` |
| **GET**    | `/exercises` | No            | Gets all exercises available. | None | None |
| **GET**    | `/exercises/:id` | No        | Gets details of a specific exercise by ID. | None | None |
| **POST**   | `/exercises` | Yes (Trainer) | Creates a new exercise (Trainer only). | `Authorization: Bearer <token>` | `{ exercise_name, description, target_muscle_group, ... }` |
| **PUT**    | `/exercises/:id` | Yes (Trainer) | Updates an exercise by ID (Trainer only). | `Authorization: Bearer <token>` | `{ exercise_name, description, ... }` |
| **DELETE** | `/exercises/:id` | Yes (Trainer) | Deletes an exercise by ID (Trainer only). | `Authorization: Bearer <token>` | None |
| **POST**   | `/workouts` | Yes (Trainer) | Creates a new workout (Trainer only). | `Authorization: Bearer <token>` | `{ workout_name, description, target_muscle_group, ... }` |
| **POST**   | `/workouts/:workoutId/exercises` | Yes (Trainer) | Adds an exercise to a workout (Trainer only). | `Authorization: Bearer <token>` | `{ exercise_id, sets, reps, duration }` |
| **GET**    | `/workouts` | No             | Gets all workouts. | None | None |
| **GET**    | `/workouts/:id` | No         | Gets details of a specific workout by ID. | None | None |
| **PUT**    | `/workouts/:id` | Yes (Trainer) | Updates a workout by ID (Trainer only). | `Authorization: Bearer <token>` | `{ workout_name, description, ... }` |
| **DELETE** | `/workouts/:id` | Yes (Trainer) | Deletes a workout by ID (Trainer only). | `Authorization: Bearer <token>` | None |
| **POST**   | `/custom-workouts` | Yes    | Creates a new custom workout for a user. | `Authorization: Bearer <token>` | `{ custom_workout_name }` |
| **POST**   | `/custom-workouts/add-exercise` | Yes | Adds an exercise to a custom workout. | `Authorization: Bearer <token>` | `{ custom_workout_id, exercise_id, sets, reps, duration }` |
| **GET**    | `/custom-workouts/:id/exercises` | Yes | Gets exercises in a specific custom workout. | `Authorization: Bearer <token>` | None |
| **DELETE** | `/custom-workouts/exercises/:id` | Yes | Removes an exercise from a custom workout. | `Authorization: Bearer <token>` | None |
