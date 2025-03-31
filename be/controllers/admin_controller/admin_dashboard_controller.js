import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

/**
 * Get dashboard summary statistics
 * Provides key metrics for the admin dashboard overview
 * Includes: user counts, membership stats, revenue metrics
 */
export const getDashboardStats = async (req, res) => {
    try {
        // User stats
        const totalUsers = await prisma.users.count();

        const today = new Date();
        const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
        const firstDayOfPrevMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1);

        const newUsersThisMonth = await prisma.users.count({
            where: {
                created_at: {
                    gte: firstDayOfMonth
                }
            }
        });

        const newUsersPrevMonth = await prisma.users.count({
            where: {
                created_at: {
                    gte: firstDayOfPrevMonth,
                    lt: firstDayOfMonth
                }
            }
        });

        const userGrowthRate = newUsersPrevMonth > 0
            ? ((newUsersThisMonth - newUsersPrevMonth) / newUsersPrevMonth) * 100
            : 100;

        // Membership stats
        const activeMemberships = await prisma.memberships.count({
            where: { status: 'Active' }
        });

        const pendingMemberships = await prisma.memberships.count({
            where: { status: 'Pending' }
        });

        const expiringMemberships = await prisma.memberships.count({
            where: {
                status: 'Active',
                end_date: {
                    gte: today,
                    lte: new Date(today.getFullYear(), today.getMonth(), today.getDate() + 30)
                }
            }
        });

        // Revenue stats
        const thisMonthPayments = await prisma.payments.findMany({
            where: {
                payment_date: {
                    gte: firstDayOfMonth
                },
                payment_status: 'Paid'
            }
        });

        const thisMonthRevenue = thisMonthPayments.reduce(
            (sum, payment) => sum + Number(payment.price), 0
        );

        const prevMonthPayments = await prisma.payments.findMany({
            where: {
                payment_date: {
                    gte: firstDayOfPrevMonth,
                    lt: firstDayOfMonth
                },
                payment_status: 'Paid'
            }
        });

        const prevMonthRevenue = prevMonthPayments.reduce(
            (sum, payment) => sum + Number(payment.price), 0
        );

        const revenueGrowthRate = prevMonthRevenue > 0
            ? ((thisMonthRevenue - prevMonthRevenue) / prevMonthRevenue) * 100
            : 100;

        // Attendance stats
        const todayAttendance = await prisma.attendance.count({
            where: {
                attendance_date: {
                    equals: new Date(today.getFullYear(), today.getMonth(), today.getDate())
                }
            }
        });

        // Most popular workouts
        const popularWorkouts = await prisma.workoutlogs.groupBy({
            by: ['workout_id'],
            _count: {
                log_id: true
            },
            orderBy: {
                _count: {
                    log_id: 'desc'
                }
            },
            take: 5
        });

        // Get workout names
        const workoutIds = popularWorkouts.map(w => w.workout_id).filter(id => id !== null);
        const workouts = await prisma.workouts.findMany({
            where: {
                workout_id: {
                    in: workoutIds
                }
            },
            select: {
                workout_id: true,
                workout_name: true,
                target_muscle_group: true,
                goal_type: true,
                difficulty: true
            }
        });

        // Combine data
        const topWorkouts = popularWorkouts
            .filter(w => w.workout_id !== null)
            .map(w => {
                const workout = workouts.find(workout => workout.workout_id === w.workout_id);
                return {
                    workout_id: w.workout_id,
                    count: w._count.log_id,
                    workout_name: workout ? workout.workout_name : 'Unknown',
                    target_muscle_group: workout ? workout.target_muscle_group : null,
                    goal_type: workout ? workout.goal_type : null,
                    difficulty: workout ? workout.difficulty : null
                };
            });

        res.status(200).json({
            status: 'success',
            message: 'Dashboard statistics fetched successfully',
            data: {
                userStats: {
                    totalUsers,
                    newUsersThisMonth,
                    newUsersPrevMonth,
                    userGrowthRate: parseFloat(userGrowthRate.toFixed(2))
                },
                membershipStats: {
                    activeMemberships,
                    pendingMemberships,
                    expiringMemberships
                },
                revenueStats: {
                    thisMonthRevenue,
                    prevMonthRevenue,
                    revenueGrowthRate: parseFloat(revenueGrowthRate.toFixed(2))
                },
                attendanceStats: {
                    todayAttendance
                },
                popularWorkouts: topWorkouts
            }
        });
    } catch (error) {
        console.error('Error fetching dashboard stats:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch dashboard statistics'
        });
    }
};

/**
 * Get monthly revenue data
 * Provides revenue aggregated by month for chart visualization
 */
export const getMonthlyRevenue = async (req, res) => {
    try {
        const { year } = req.query;

        // Default to current year if not specified
        const targetYear = year ? parseInt(year) : new Date().getFullYear();

        // Start and end dates for the year
        const startDate = new Date(targetYear, 0, 1); // January 1st
        const endDate = new Date(targetYear, 11, 31); // December 31st

        // Get all payments for the year
        const payments = await prisma.payments.findMany({
            where: {
                payment_date: {
                    gte: startDate,
                    lte: endDate
                },
                payment_status: 'Paid'
            },
            select: {
                payment_date: true,
                price: true
            }
        });

        // Prepare monthly data
        const monthlyRevenue = Array(12).fill(0).map((_, index) => ({
            month: index + 1,
            month_name: new Date(targetYear, index, 1).toLocaleString('default', { month: 'long' }),
            revenue: 0
        }));

        // Aggregate payments by month
        payments.forEach(payment => {
            const month = payment.payment_date.getMonth();
            monthlyRevenue[month].revenue += Number(payment.price);
        });

        // Get previous year data for comparison if available
        let previousYearData = null;

        if (targetYear > 2000) { // Arbitrary check to avoid going too far back
            const prevYearStart = new Date(targetYear - 1, 0, 1);
            const prevYearEnd = new Date(targetYear - 1, 11, 31);

            const prevYearPayments = await prisma.payments.findMany({
                where: {
                    payment_date: {
                        gte: prevYearStart,
                        lte: prevYearEnd
                    },
                    payment_status: 'Paid'
                },
                select: {
                    payment_date: true,
                    price: true
                }
            });

            if (prevYearPayments.length > 0) {
                const prevMonthlyRevenue = Array(12).fill(0).map((_, index) => ({
                    month: index + 1,
                    month_name: new Date(targetYear - 1, index, 1).toLocaleString('default', { month: 'long' }),
                    revenue: 0
                }));

                prevYearPayments.forEach(payment => {
                    const month = payment.payment_date.getMonth();
                    prevMonthlyRevenue[month].revenue += Number(payment.price);
                });

                previousYearData = prevMonthlyRevenue;
            }
        }

        res.status(200).json({
            status: 'success',
            message: 'Monthly revenue data fetched successfully',
            data: {
                year: targetYear,
                monthly_data: monthlyRevenue,
                previous_year_data: previousYearData,
                total_revenue: monthlyRevenue.reduce((sum, month) => sum + month.revenue, 0)
            }
        });
    } catch (error) {
        console.error('Error fetching monthly revenue:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch monthly revenue data'
        });
    }
};

/**
 * Get user growth statistics
 * Provides user registrations by month for trends visualization
 */
export const getUserGrowthStats = async (req, res) => {
    try {
        const { year } = req.query;

        // Default to current year if not specified
        const targetYear = year ? parseInt(year) : new Date().getFullYear();

        // Start and end dates for the year
        const startDate = new Date(targetYear, 0, 1); // January 1st
        const endDate = new Date(targetYear, 11, 31); // December 31st

        // Get all users registered during the year
        const users = await prisma.users.findMany({
            where: {
                created_at: {
                    gte: startDate,
                    lte: endDate
                }
            },
            select: {
                created_at: true,
                role: true
            }
        });

        // Prepare monthly data
        const monthlySignups = Array(12).fill(0).map((_, index) => ({
            month: index + 1,
            month_name: new Date(targetYear, index, 1).toLocaleString('default', { month: 'long' }),
            total: 0,
            members: 0,
            trainers: 0
        }));

        // Aggregate users by month and role
        users.forEach(user => {
            if (user.created_at) {
                const month = user.created_at.getMonth();
                monthlySignups[month].total++;

                if (user.role === 'Member') {
                    monthlySignups[month].members++;
                } else if (user.role === 'Trainer') {
                    monthlySignups[month].trainers++;
                }
            }
        });

        // Get cumulative totals
        let cumulativeTotal = 0;
        const cumulativeGrowth = monthlySignups.map(month => {
            cumulativeTotal += month.total;
            return {
                ...month,
                cumulative: cumulativeTotal
            };
        });

        // Get user count at start of year for accurate cumulative
        const userCountBeforeYear = await prisma.users.count({
            where: {
                created_at: {
                    lt: startDate
                }
            }
        });

        // Adjust cumulative values
        cumulativeGrowth.forEach(month => {
            month.cumulative += userCountBeforeYear;
        });

        res.status(200).json({
            status: 'success',
            message: 'User growth statistics fetched successfully',
            data: {
                year: targetYear,
                monthly_data: monthlySignups,
                cumulative_data: cumulativeGrowth,
                total_new_users: users.length,
                starting_user_count: userCountBeforeYear
            }
        });
    } catch (error) {
        console.error('Error fetching user growth stats:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch user growth statistics'
        });
    }
};

/**
 * Get gym attendance trends
 * Provides attendance data aggregated by day and gym
 */
export const getAttendanceTrends = async (req, res) => {
    try {
        const { days = 30, gym_id } = req.query;

        const daysBack = parseInt(days);
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - daysBack);

        // Build the where condition
        const whereCondition = {
            attendance_date: {
                gte: startDate
            }
        };

        if (gym_id) {
            whereCondition.gym_id = parseInt(gym_id);
        }

        // Get attendance records
        const attendanceRecords = await prisma.attendance.findMany({
            where: whereCondition,
            select: {
                attendance_date: true,
                gym_id: true
            },
            orderBy: {
                attendance_date: 'asc'
            }
        });

        // Get gym info
        const gyms = await prisma.gym.findMany({
            select: {
                gym_id: true,
                gym_name: true
            }
        });

        // Prepare daily attendance data
        const dailyAttendance = {};

        // Initialize the data structure with all days
        for (let i = 0; i <= daysBack; i++) {
            const date = new Date();
            date.setDate(date.getDate() - (daysBack - i));
            const dateStr = date.toISOString().split('T')[0];

            dailyAttendance[dateStr] = {
                date: dateStr,
                total: 0
            };

            // Initialize count for each gym
            gyms.forEach(gym => {
                dailyAttendance[dateStr][`gym_${gym.gym_id}`] = 0;
            });
        }

        // Count attendance for each day and gym
        attendanceRecords.forEach(record => {
            const dateStr = record.attendance_date.toISOString().split('T')[0];

            if (dailyAttendance[dateStr]) {
                dailyAttendance[dateStr].total++;

                if (record.gym_id) {
                    dailyAttendance[dateStr][`gym_${record.gym_id}`]++;
                }
            }
        });

        // Convert to array and add gym names to response
        const attendanceData = Object.values(dailyAttendance);

        res.status(200).json({
            status: 'success',
            message: 'Attendance trends fetched successfully',
            data: {
                gyms: gyms.map(gym => ({
                    id: gym.gym_id,
                    name: gym.gym_name,
                    key: `gym_${gym.gym_id}`
                })),
                attendance: attendanceData
            }
        });
    } catch (error) {
        console.error('Error fetching attendance trends:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch attendance trends'
        });
    }
};

/**
 * Get user demographics
 * Provides user distribution by gender, age group, and fitness level
 */
export const getUserDemographics = async (req, res) => {
    try {
        // Gender distribution
        const genderDistribution = await prisma.users.groupBy({
            by: ['gender'],
            _count: {
                user_id: true
            }
        });

        // Format gender data
        const genderData = genderDistribution.map(item => ({
            gender: item.gender || 'Unspecified',
            count: item._count.user_id
        }));

        // Fitness level distribution
        const fitnessLevelDistribution = await prisma.users.groupBy({
            by: ['fitness_level'],
            _count: {
                user_id: true
            }
        });

        // Format fitness level data
        const fitnessLevelData = fitnessLevelDistribution.map(item => ({
            fitness_level: item.fitness_level || 'Unspecified',
            count: item._count.user_id
        }));

        // Goal type distribution
        const goalTypeDistribution = await prisma.users.groupBy({
            by: ['goal_type'],
            _count: {
                user_id: true
            }
        });

        // Format goal type data
        const goalTypeData = goalTypeDistribution.map(item => ({
            goal_type: item.goal_type || 'Unspecified',
            count: item._count.user_id
        }));

        // Age distribution (calculated from birthdate)
        const users = await prisma.users.findMany({
            where: {
                birthdate: {
                    not: null
                }
            },
            select: {
                birthdate: true
            }
        });

        // Define age groups
        const ageGroups = {
            'Under 18': 0,
            '18-24': 0,
            '25-34': 0,
            '35-44': 0,
            '45-54': 0,
            '55+': 0
        };

        // Calculate age distribution
        const today = new Date();

        users.forEach(user => {
            if (user.birthdate) {
                const birthdate = new Date(user.birthdate);
                const age = today.getFullYear() - birthdate.getFullYear();

                // Adjust age if birthday hasn't occurred yet this year
                const hasBirthdayOccurred =
                    today.getMonth() > birthdate.getMonth() ||
                    (today.getMonth() === birthdate.getMonth() && today.getDate() >= birthdate.getDate());

                const adjustedAge = hasBirthdayOccurred ? age : age - 1;

                if (adjustedAge < 18) ageGroups['Under 18']++;
                else if (adjustedAge < 25) ageGroups['18-24']++;
                else if (adjustedAge < 35) ageGroups['25-34']++;
                else if (adjustedAge < 45) ageGroups['35-44']++;
                else if (adjustedAge < 55) ageGroups['45-54']++;
                else ageGroups['55+']++;
            }
        });

        // Format age group data
        const ageGroupData = Object.entries(ageGroups).map(([group, count]) => ({
            age_group: group,
            count
        }));

        // Get count of users without birthdate
        const usersWithoutBirthdate = await prisma.users.count({
            where: {
                birthdate: null
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'User demographics fetched successfully',
            data: {
                genderDistribution: genderData,
                fitnessLevelDistribution: fitnessLevelData,
                goalTypeDistribution: goalTypeData,
                ageDistribution: ageGroupData,
                usersMissingBirthdate: usersWithoutBirthdate
            }
        });
    } catch (error) {
        console.error('Error fetching user demographics:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch user demographics'
        });
    }
};