
// Enums
export enum Role {
  Member = 'Member',
  Trainer = 'Trainer',
  Admin = 'Admin'
}

export enum Gender {
  Male = 'Male',
  Female = 'Female',
  Other = 'Other'
}

export enum FitnessLevel {
  Beginner = 'Beginner',
  Intermediate = 'Intermediate',
  Advanced = 'Advanced',
  Athlete = 'Athlete'
}

export enum GoalType {
  Weight_Loss = 'Weight Loss',
  Muscle_Gain = 'Muscle Gain',
  Endurance = 'Endurance',
  Maintenance = 'Maintenance',
  Flexibility = 'Flexibility'
}

export enum MembershipStatus {
  Pending = 'Pending',
  Active = 'Active',
  Expired = 'Expired',
  Cancelled = 'Cancelled'
}

export enum PaymentMethod {
  Khalti = 'Khalti',
  Cash = 'Cash'
}

export enum PaymentStatus {
  Paid = 'Paid',
  Pending = 'Pending',
  Failed = 'Failed'
}

export enum PlanType {
  Monthly = 'Monthly',
  Quarterly = 'Quarterly',
  Yearly = 'Yearly'
}

export enum DifficultyLevel {
  Easy = 'Easy',
  Intermediate = 'Intermediate',
  Hard = 'Hard'
}

// Interfaces
export interface User {
  user_id: number;
  user_name?: string;
  full_name?: string;
  email: string;
  role: Role;
  phone_number?: string;
  gender?: Gender;
  address?: string;
  birthdate?: Date;
  fitness_level?: FitnessLevel;
  goal_type?: GoalType;
  profile_image?: string;
  created_at?: Date;
}

export interface MembershipPlan {
  plan_id: number;
  plan_type: PlanType;
  price: number;
  duration: number;
  description: string;
  created_at?: Date;
}

export interface Membership {
  membership_id: number;
  user_id?: number;
  plan_id: number;
  start_date?: Date;
  end_date?: Date;
  status: MembershipStatus;
  created_at?: Date;
  user?: User;
  membership_plan?: MembershipPlan;
}

export interface Payment {
  payment_id: number;
  membership_id?: number;
  user_id?: number;
  price: number;
  payment_method: PaymentMethod;
  transaction_id: string;
  pidx?: string;
  payment_date: Date;
  payment_status: PaymentStatus;
  created_at?: Date;
  user?: User;
  membership?: Membership;
}

export interface Exercise {
  exercise_id: number;
  exercise_name: string;
  description: string;
  target_muscle_group: string;
  calories_burned_per_minute: number;
  image_url?: string;
  video_url?: string;
  created_at?: Date;
}

export interface Workout {
  workout_id: number;
  workout_name: string;
  description: string;
  target_muscle_group: string;
  difficulty: DifficultyLevel;
  goal_type: GoalType;
  fitness_level: FitnessLevel;
  workout_image?: string;
  trainer_id?: number;
  user_id?: number;
  created_at?: Date;
}

export interface WorkoutExercise {
  workout_exercise_id: number;
  workout_id: number;
  exercise_id: number;
  sets: number;
  reps: number;
  duration: number;
  exercise?: Exercise;
}

export interface ChartData {
  name: string;
  value: number;
}

export interface ActivityLog {
  id: number;
  userId?: number;
  userName?: string;
  action: string;
  resourceType: string;
  resourceId?: number;
  details?: string;
  timestamp: Date;
}

export interface StatCardProps {
  title: string;
  value: string | number;
  icon: React.ComponentType<React.SVGProps<SVGSVGElement>>;
  description?: string;
  trend?: number;
  onClick?: () => void;
}
