import prisma from '../../prisma/prisma.js';

export const getUserOverallStats = async (req, res) => {
    try {
        const { user_id, role } = req.user;
        
        // Ensure the user is a trainer
        if (role !== 'Trainer') {
            return res.status(403).json({ 
                status: 'failure', 
                message: 'Access denied. Trainers only' 
            });
        }
        
        // Get user ID from params
        const targetUserId = parseInt(req.params.userId);
        
        if (!targetUserId) {
            return res.status(400).json({ 
                status: 'failure', 
                message: 'User ID is required' 
            });
        }
        
        // Check if user exists
        const userExists = await prisma.users.findUnique({
            where: { user_id: targetUserId }
        });
        
        if (!userExists) {
            return res.status(404).json({ 
                status: 'failure', 
                message: 'User not found' 
            });
        }
        
        // Get user profile data
        const userProfile = await prisma.users.findUnique({
            where: { user_id: targetUserId },
            select: {
                user_name: true,
                full_name: true,
                birthdate: true,
                height: true,
                current_weight: true,
                gender: true,
                email: true,
                fitness_level: true,
                goal_type: true,
                allergies: true,
                calorie_goals: true,
                profile_image: true
            }
        });
        
        // Get weight logs to track progress
        const weightLogs = await prisma.weight_logs.findMany({
            where: { user_id: targetUserId },
            orderBy: { logged_at: 'asc' }
        });
        
        // Get workout stats
        const workoutLogs = await prisma.workoutlogs.findMany({
            where: { user_id: targetUserId },
            include: {
                workouts: {
                    select: {
                        workout_name: true,
                        target_muscle_group: true,
                        difficulty: true,
                        goal_type: true
                    }
                },
                workoutexerciseslogs: {
                    include: {
                        exercises: true
                    }
                }
            },
            orderBy: { workout_date: 'desc' }
        });
        
        // Calculate workout metrics
        const totalWorkouts = workoutLogs.length;
        const totalDuration = workoutLogs.reduce((sum, log) => 
            sum + (log.total_duration ? parseFloat(log.total_duration) : 0), 0);
        const totalCaloriesBurned = workoutLogs.reduce((sum, log) => 
            sum + (log.calories_burned ? parseFloat(log.calories_burned) : 0), 0);
            
        // Get recent workouts (last 5)
        const recentWorkouts = workoutLogs.slice(0, 5);
        
        // Get diet plan stats
        const mealLogs = await prisma.meallogs.findMany({
            where: { user_id: targetUserId },
            include: {
                meal: {
                    include: {
                        dietplan: true
                    }
                }
            },
            orderBy: { log_time: 'desc' }
        });
        
        // Get active diet plans
        const dietPlans = await prisma.dietplans.findMany({
            where: { user_id: targetUserId },
            include: {
                meals: true
            }
        });
        
        // Calculate nutrition metrics
        const totalMealsLogged = mealLogs.length;
        const caloriesConsumed = mealLogs.reduce((sum, log) => {
            const mealCalories = log.meal?.calories ? parseFloat(log.meal.calories) : 0;
            const quantity = log.quantity ? parseFloat(log.quantity) : 0;
            return sum + (mealCalories * quantity);
        }, 0);
        
        // Get personal bests
        const personalBests = await prisma.personal_bests.findMany({
            where: { user_id: targetUserId },
            include: {
                supported_exercises: true
            },
            orderBy: { achieved_at: 'desc' }
        });
        
        // Get membership status
        const membership = await prisma.memberships.findFirst({
            where: { 
                user_id: targetUserId,
                status: 'Active'
            },
            include: {
                membership_plan: true
            },
            orderBy: { created_at: 'desc' }
        });
        
        // Get attendance records
        const attendance = await prisma.attendance.findMany({
            where: { user_id: targetUserId },
            orderBy: { attendance_date: 'desc' }
        });
        
        const attendanceCount = attendance.length;
        const lastAttendance = attendance[0]?.attendance_date;
        
        // Calculate overall metrics and progress
        let weightProgress = null;
        if (weightLogs.length >= 2) {
            const latestWeight = parseFloat(weightLogs[weightLogs.length - 1].weight);
            const initialWeight = parseFloat(weightLogs[0].weight);
            weightProgress = latestWeight - initialWeight;
        }
        
        // Compile all statistics
        const statistics = {
            userProfile,
            weightStats: {
                currentWeight: userProfile.current_weight,
                weightLogs,
                weightProgress
            },
            workoutStats: {
                totalWorkouts,
                totalDuration,
                totalCaloriesBurned,
                recentWorkouts
            },
            nutritionStats: {
                dietPlans,
                totalMealsLogged,
                caloriesConsumed,
                recentMealLogs: mealLogs.slice(0, 5)
            },
            performanceStats: {
                personalBests
            },
            membershipInfo: membership,
            attendanceStats: {
                totalAttendances: attendanceCount,
                lastAttendance
            }
        };
        
        res.status(200).json({
            status: 'success',
            message: 'User statistics retrieved successfully',
            data: statistics
        });
        
    } catch (error) {
        console.error('Error getting user statistics:', error);
        res.status(500).json({ 
            status: 'failure', 
            message: 'Server error' 
        });
    }
};

// Get a list of all users for the trainer to select from
export const getAllUsers = async (req, res) => {
    try {
        const { user_id, role } = req.user;
        
        // Ensure the user is a trainer
        if (role !== 'Trainer') {
            return res.status(403).json({ 
                status: 'failure', 
                message: 'Access denied. Trainers only' 
            });
        }
        
        // Get all members (users with role 'Member')
        const users = await prisma.users.findMany({
            where: { role: 'Member' },
            select: {
                user_id: true,
                user_name: true,
                full_name: true,
                email: true,
                profile_image: true,
                fitness_level: true,
                goal_type: true
            },
            orderBy: { full_name: 'asc' }
        });
        
        res.status(200).json({
            status: 'success',
            message: 'Users retrieved successfully',
            data: users
        });
        
    } catch (error) {
        console.error('Error getting users:', error);
        res.status(500).json({ 
            status: 'failure', 
            message: 'Server error' 
        });
    }
};

// Get summary statistics for all users (for dashboard view)
export const getUsersStatsSummary = async (req, res) => {
    try {
        const { user_id, role } = req.user;
        
        // Ensure the user is a trainer
        if (role !== 'Trainer') {
            return res.status(403).json({ 
                status: 'failure', 
                message: 'Access denied. Trainers only' 
            });
        }
        
        // Count total members
        const totalMembers = await prisma.users.count({
            where: { role: 'Member' }
        });
        
        // Get total workouts completed
        const totalWorkoutsCompleted = await prisma.workoutlogs.count();
        
        // Get total diet plans created
        const totalDietPlans = await prisma.dietplans.count();
        
        // Get attendance trend (last 30 days)
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
        
        const attendanceCount = await prisma.attendance.count({
            where: {
                attendance_date: {
                    gte: thirtyDaysAgo
                }
            }
        });
        
        // Get users by goal type
        const usersByGoalType = await prisma.users.groupBy({
            by: ['goal_type'],
            where: { 
                role: 'Member',
                goal_type: { not: null }
            },
            _count: true
        });
        
        // Get users by fitness level
        const usersByFitnessLevel = await prisma.users.groupBy({
            by: ['fitness_level'],
            where: { 
                role: 'Member',
                fitness_level: { not: null }
            },
            _count: true
        });
        
        // Compile summary statistics
        const summary = {
            totalMembers,
            totalWorkoutsCompleted,
            totalDietPlans,
            recentAttendance: attendanceCount,
            usersByGoalType,
            usersByFitnessLevel
        };
        
        res.status(200).json({
            status: 'success',
            message: 'User statistics summary retrieved successfully',
            data: summary
        });
        
    } catch (error) {
        console.error('Error getting users stats summary:', error);
        res.status(500).json({ 
            status: 'failure', 
            message: 'Server error' 
        });
    }
};