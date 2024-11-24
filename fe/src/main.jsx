/* eslint-disable react/react-in-jsx-scope */
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import Register from './pages/Register.jsx'
import Welcome from './pages/Welcome.jsx'
import Login from './pages/Login.jsx'
import CreateWorkout from './pages/workout/CreateWorkout.jsx'
import ViewWorkouts from './pages/workout/ViewWorkouts.jsx'
import CreateExercise from './pages/exercise/CreateExercise.jsx'
import ViewExercises from './pages/exercise/ViewExercises.jsx'
import AddExercisesToWorkout from './pages/workout/AddExerciseToWorkout.jsx'
import WorkoutDetails from './pages/workout/WorkoutDetails.jsx'
import CreateCustomWorkout from './pages/custom_workout/CreateCustomWorkout.jsx'
import AddExercisesToCustomWorkout from './pages/custom_workout/AddExercisesToCustomWorkout.jsx'
import ViewCustomWorkouts from './pages/custom_workout/ViewCustomWorkouts.jsx'


const router = createBrowserRouter(
  [
    {
      path: '/register',
      element: <Register />
    },
    {
      path: '/welcome',
      element: <Welcome />
    },
    {
      path: '/login',
      element: <Login />
    },
    {
      path: '/create-workout',
      element: <CreateWorkout />
    },
    {
      path: '/workouts',
      element: <ViewWorkouts />
    },
    {
      path: 'create-exercise',
      element: <CreateExercise />
    },
    {
      path: '/exercises',
      element: <ViewExercises />
    },
    {
      path: '/add-exercise-to-workout',
      element: <AddExercisesToWorkout />
    },
    {
      path: '/workouts/:workoutId',
      element: <WorkoutDetails />
    },
    {
      path: '/create-custom-workout',
      element: <CreateCustomWorkout />
    },
    {
      path: '/custom-workouts/:id/add-exercises',
      element: <AddExercisesToCustomWorkout />
    },
    {
      path: '/custom-workouts',
      element: <ViewCustomWorkouts />
    },
    {
      path: '/',
      element: <App />
    }
    

  ]
)



createRoot(document.getElementById('root')).render(
  <StrictMode>
    <RouterProvider router={router}/>
  </StrictMode>,
)
