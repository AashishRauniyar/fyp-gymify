
import { 
  User, Role, Gender, FitnessLevel, GoalType, MembershipPlan, PlanType, 
  Membership, MembershipStatus, Payment, PaymentMethod, PaymentStatus, 
  Exercise, Workout, DifficultyLevel, WorkoutExercise, ActivityLog, ChartData
} from '@/types';

// Users data
export const users: User[] = [
  {
    user_id: 1,
    user_name: 'johndoe',
    full_name: 'John Doe',
    email: 'john@example.com',
    role: Role.Admin,
    phone_number: '+1234567890',
    gender: Gender.Male,
    address: '123 Main St, City',
    birthdate: new Date('1990-05-15'),
    fitness_level: FitnessLevel.Advanced,
    goal_type: GoalType.Muscle_Gain,
    profile_image: 'https://i.pravatar.cc/150?img=1',
    created_at: new Date('2023-01-10')
  },
  {
    user_id: 2,
    user_name: 'janedoe',
    full_name: 'Jane Doe',
    email: 'jane@example.com',
    role: Role.Trainer,
    phone_number: '+0987654321',
    gender: Gender.Female,
    address: '456 Park Ave, Town',
    birthdate: new Date('1992-08-21'),
    fitness_level: FitnessLevel.Athlete,
    goal_type: GoalType.Endurance,
    profile_image: 'https://i.pravatar.cc/150?img=5',
    created_at: new Date('2023-02-15')
  },
  {
    user_id: 3,
    user_name: 'mikesmith',
    full_name: 'Mike Smith',
    email: 'mike@example.com',
    role: Role.Member,
    phone_number: '+1122334455',
    gender: Gender.Male,
    address: '789 Grove St, Village',
    birthdate: new Date('1995-11-08'),
    fitness_level: FitnessLevel.Beginner,
    goal_type: GoalType.Weight_Loss,
    profile_image: 'https://i.pravatar.cc/150?img=8',
    created_at: new Date('2023-03-20')
  },
  {
    user_id: 4,
    user_name: 'sarahjones',
    full_name: 'Sarah Jones',
    email: 'sarah@example.com',
    role: Role.Member,
    phone_number: '+9988776655',
    gender: Gender.Female,
    address: '101 Elm St, Suburb',
    birthdate: new Date('1998-04-17'),
    fitness_level: FitnessLevel.Intermediate,
    goal_type: GoalType.Muscle_Gain,
    profile_image: 'https://i.pravatar.cc/150?img=9',
    created_at: new Date('2023-04-05')
  },
  {
    user_id: 5,
    user_name: 'robwilson',
    full_name: 'Robert Wilson',
    email: 'rob@example.com',
    role: Role.Trainer,
    phone_number: '+5544332211',
    gender: Gender.Male,
    address: '202 Pine St, District',
    birthdate: new Date('1988-09-30'),
    fitness_level: FitnessLevel.Advanced,
    goal_type: GoalType.Flexibility,
    profile_image: 'https://i.pravatar.cc/150?img=12',
    created_at: new Date('2023-05-12')
  }
];

// Membership Plans
export const membershipPlans: MembershipPlan[] = [
  {
    plan_id: 1,
    plan_type: PlanType.Monthly,
    price: 50,
    duration: 1,
    description: 'Basic monthly membership with access to all gym facilities.'
  },
  {
    plan_id: 2,
    plan_type: PlanType.Quarterly,
    price: 120,
    duration: 3,
    description: 'Quarterly membership with access to all gym facilities and one free personal training session per month.'
  },
  {
    plan_id: 3,
    plan_type: PlanType.Yearly,
    price: 400,
    duration: 12,
    description: 'Annual membership with access to all gym facilities, two free personal training sessions per month, and exclusive access to premium classes.'
  }
];

// Memberships
export const memberships: Membership[] = [
  {
    membership_id: 1,
    user_id: 3,
    plan_id: 1,
    start_date: new Date('2023-06-01'),
    end_date: new Date('2023-07-01'),
    status: MembershipStatus.Active,
    created_at: new Date('2023-06-01')
  },
  {
    membership_id: 2,
    user_id: 4,
    plan_id: 2,
    start_date: new Date('2023-05-15'),
    end_date: new Date('2023-08-15'),
    status: MembershipStatus.Active,
    created_at: new Date('2023-05-15')
  },
  {
    membership_id: 3,
    user_id: 5,
    plan_id: 3,
    start_date: new Date('2023-01-10'),
    end_date: new Date('2024-01-10'),
    status: MembershipStatus.Active,
    created_at: new Date('2023-01-10')
  }
];

// Payments
export const payments: Payment[] = [
  {
    payment_id: 1,
    membership_id: 1,
    user_id: 3,
    price: 50,
    payment_method: PaymentMethod.Cash,
    transaction_id: 'TRANS123456',
    payment_date: new Date('2023-06-01'),
    payment_status: PaymentStatus.Paid,
    created_at: new Date('2023-06-01')
  },
  {
    payment_id: 2,
    membership_id: 2,
    user_id: 4,
    price: 120,
    payment_method: PaymentMethod.Khalti,
    transaction_id: 'TRANS789012',
    pidx: 'PIDX123456',
    payment_date: new Date('2023-05-15'),
    payment_status: PaymentStatus.Paid,
    created_at: new Date('2023-05-15')
  },
  {
    payment_id: 3,
    membership_id: 3,
    user_id: 5,
    price: 400,
    payment_method: PaymentMethod.Cash,
    transaction_id: 'TRANS345678',
    payment_date: new Date('2023-01-10'),
    payment_status: PaymentStatus.Paid,
    created_at: new Date('2023-01-10')
  }
];

// Exercises
export const exercises: Exercise[] = [
  {
    exercise_id: 1,
    exercise_name: 'Bench Press',
    description: 'A compound exercise that works the chest, shoulders, and triceps.',
    target_muscle_group: 'Chest',
    calories_burned_per_minute: 8.0,
    image_url: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=2070',
    video_url: 'https://www.youtube.com/watch?v=rT7DgCr-3pg',
    created_at: new Date('2023-01-05')
  },
  {
    exercise_id: 2,
    exercise_name: 'Squat',
    description: 'A compound exercise that works the quadriceps, hamstrings, and glutes.',
    target_muscle_group: 'Legs',
    calories_burned_per_minute: 9.5,
    image_url: 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?q=80&w=2069',
    video_url: 'https://www.youtube.com/watch?v=ultWZbUMPL8',
    created_at: new Date('2023-01-06')
  },
  {
    exercise_id: 3,
    exercise_name: 'Deadlift',
    description: 'A compound exercise that works the back, glutes, and hamstrings.',
    target_muscle_group: 'Back',
    calories_burned_per_minute: 10.0,
    image_url: 'https://images.unsplash.com/photo-1598575222493-a0711b641df8?q=80&w=2070',
    video_url: 'https://www.youtube.com/watch?v=WFUOtnI1LmA',
    created_at: new Date('2023-01-07')
  },
  {
    exercise_id: 4,
    exercise_name: 'Pull-Up',
    description: 'A compound exercise that works the back and biceps.',
    target_muscle_group: 'Back',
    calories_burned_per_minute: 8.0,
    image_url: 'https://images.unsplash.com/photo-1598971639058-b12b6863a285?q=80&w=1974',
    video_url: 'https://www.youtube.com/watch?v=sIvJTfGxdFo',
    created_at: new Date('2023-01-08')
  },
  {
    exercise_id: 5,
    exercise_name: 'Overhead Press',
    description: 'A compound exercise that works the shoulders and triceps.',
    target_muscle_group: 'Shoulders',
    calories_burned_per_minute: 7.5,
    image_url: 'https://images.unsplash.com/photo-1603287681836-b174ce5074c2?q=80&w=1974',
    video_url: 'https://www.youtube.com/watch?v=_RlRDWO2jfg',
    created_at: new Date('2023-01-09')
  }
];

// Workouts
export const workouts: Workout[] = [
  {
    workout_id: 1,
    workout_name: 'Beginner Full Body',
    description: 'A full body workout for beginners focusing on compound movements.',
    target_muscle_group: 'Full Body',
    difficulty: DifficultyLevel.Easy,
    goal_type: GoalType.Muscle_Gain,
    fitness_level: FitnessLevel.Beginner,
    workout_image: 'https://images.unsplash.com/photo-1470468969717-61d5d54fd036?q=80&w=2983',
    trainer_id: 2,
    created_at: new Date('2023-02-01')
  },
  {
    workout_id: 2,
    workout_name: 'Intermediate Upper Body',
    description: 'An upper body workout for intermediate lifters focusing on strength development.',
    target_muscle_group: 'Upper Body',
    difficulty: DifficultyLevel.Intermediate,
    goal_type: GoalType.Muscle_Gain,
    fitness_level: FitnessLevel.Intermediate,
    workout_image: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=2970',
    trainer_id: 5,
    created_at: new Date('2023-02-05')
  },
  {
    workout_id: 3,
    workout_name: 'Advanced Lower Body',
    description: 'A challenging lower body workout for advanced athletes.',
    target_muscle_group: 'Lower Body',
    difficulty: DifficultyLevel.Hard,
    goal_type: GoalType.Endurance,
    fitness_level: FitnessLevel.Advanced,
    workout_image: 'https://images.unsplash.com/photo-1434682881908-b43d0467b798?q=80&w=2974',
    trainer_id: 2,
    created_at: new Date('2023-02-10')
  }
];

// Workout Exercises
export const workoutExercises: WorkoutExercise[] = [
  {
    workout_exercise_id: 1,
    workout_id: 1,
    exercise_id: 1,
    sets: 3,
    reps: 10,
    duration: 0
  },
  {
    workout_exercise_id: 2,
    workout_id: 1,
    exercise_id: 2,
    sets: 3,
    reps: 12,
    duration: 0
  },
  {
    workout_exercise_id: 3,
    workout_id: 1,
    exercise_id: 5,
    sets: 3,
    reps: 10,
    duration: 0
  },
  {
    workout_exercise_id: 4,
    workout_id: 2,
    exercise_id: 1,
    sets: 4,
    reps: 8,
    duration: 0
  },
  {
    workout_exercise_id: 5,
    workout_id: 2,
    exercise_id: 4,
    sets: 4,
    reps: 10,
    duration: 0
  },
  {
    workout_exercise_id: 6,
    workout_id: 2,
    exercise_id: 5,
    sets: 4,
    reps: 8,
    duration: 0
  },
  {
    workout_exercise_id: 7,
    workout_id: 3,
    exercise_id: 2,
    sets: 5,
    reps: 5,
    duration: 0
  },
  {
    workout_exercise_id: 8,
    workout_id: 3,
    exercise_id: 3,
    sets: 5,
    reps: 5,
    duration: 0
  }
];

// Activity Logs
export const activityLogs: ActivityLog[] = [
  {
    id: 1,
    userId: 1,
    userName: 'John Doe',
    action: 'created',
    resourceType: 'membership',
    resourceId: 1,
    details: 'Created membership for Mike Smith',
    timestamp: new Date('2023-06-01T10:30:00')
  },
  {
    id: 2,
    userId: 1,
    userName: 'John Doe',
    action: 'processed',
    resourceType: 'payment',
    resourceId: 1,
    details: 'Processed payment for Mike Smith',
    timestamp: new Date('2023-06-01T10:35:00')
  },
  {
    id: 3,
    userId: 2,
    userName: 'Jane Doe',
    action: 'created',
    resourceType: 'workout',
    resourceId: 1,
    details: 'Created Beginner Full Body workout',
    timestamp: new Date('2023-02-01T14:20:00')
  },
  {
    id: 4,
    userId: 3,
    userName: 'Mike Smith',
    action: 'logged',
    resourceType: 'attendance',
    details: 'Checked into the gym',
    timestamp: new Date('2023-06-02T08:00:00')
  },
  {
    id: 5,
    userId: 5,
    userName: 'Robert Wilson',
    action: 'created',
    resourceType: 'workout',
    resourceId: 2,
    details: 'Created Intermediate Upper Body workout',
    timestamp: new Date('2023-02-05T09:15:00')
  }
];

// Membership distribution data
export const membershipDistribution: ChartData[] = [
  { name: 'Monthly', value: 45 },
  { name: 'Quarterly', value: 30 },
  { name: 'Yearly', value: 25 }
];

// Revenue data
export const revenueData: ChartData[] = [
  { name: 'Jan', value: 4000 },
  { name: 'Feb', value: 3000 },
  { name: 'Mar', value: 2000 },
  { name: 'Apr', value: 2780 },
  { name: 'May', value: 1890 },
  { name: 'Jun', value: 2390 },
  { name: 'Jul', value: 3490 }
];

// User growth data
export const userGrowthData: ChartData[] = [
  { name: 'Jan', value: 10 },
  { name: 'Feb', value: 15 },
  { name: 'Mar', value: 25 },
  { name: 'Apr', value: 40 },
  { name: 'May', value: 55 },
  { name: 'Jun', value: 75 },
  { name: 'Jul', value: 100 }
];

// Stats
export const stats = {
  totalUsers: users.length,
  totalMembers: users.filter(user => user.role === Role.Member).length,
  totalTrainers: users.filter(user => user.role === Role.Trainer).length,
  activeMembers: memberships.filter(membership => membership.status === MembershipStatus.Active).length,
  pendingMembers: memberships.filter(membership => membership.status === MembershipStatus.Pending).length,
  totalRevenue: payments.reduce((sum, payment) => sum + payment.price, 0),
  totalWorkouts: workouts.length,
  totalExercises: exercises.length
};
