// import { PrismaClient } from '@prisma/client';
import prisma from '../../prisma/prisma.js';
import { body, validationResult, param, query } from 'express-validator';

// const prisma = new PrismaClient();

/**
 * Get all attendance records with filtering options
 * Retrieves attendance records with pagination and multiple filters
 * Filters: date range, user ID, gym ID
 */
export const getAllAttendanceRecords = async (req, res) => {
  try {
    const { 
      start_date, 
      end_date, 
      user_id, 
      gym_id,
      page = 1, 
      limit = 20 
    } = req.query;

    // Build filter conditions
    const whereCondition = {};
    
    // Date range filter
    if (start_date || end_date) {
      whereCondition.attendance_date = {};
      
      if (start_date) {
        whereCondition.attendance_date.gte = new Date(start_date);
      }
      
      if (end_date) {
        whereCondition.attendance_date.lte = new Date(end_date);
      }
    }
    
    // User filter
    if (user_id) {
      whereCondition.user_id = parseInt(user_id);
    }
    
    // Gym filter
    if (gym_id) {
      whereCondition.gym_id = parseInt(gym_id);
    }

    // Calculate pagination
    const skip = (parseInt(page) - 1) * parseInt(limit);
    
    // Get paginated attendance records
    const attendanceRecords = await prisma.attendance.findMany({
      where: whereCondition,
      include: {
        users: {
          select: {
            user_id: true,
            user_name: true,
            full_name: true,
            email: true,
            role: true
          }
        }
      },
      orderBy: {
        attendance_date: 'desc'
      },
      skip,
      take: parseInt(limit)
    });
    
    // Get total count for pagination
    const totalRecords = await prisma.attendance.count({
      where: whereCondition
    });
    
    // Calculate total pages
    const totalPages = Math.ceil(totalRecords / parseInt(limit));
    
    res.status(200).json({
      status: 'success',
      message: 'Attendance records fetched successfully',
      data: {
        records: attendanceRecords,
        pagination: {
          total: totalRecords,
          pages: totalPages,
          current_page: parseInt(page),
          per_page: parseInt(limit)
        }
      }
    });
  } catch (error) {
    console.error('Error fetching attendance records:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch attendance records'
    });
  }
};

/**
 * Get attendance details for a specific user
 * Provides comprehensive attendance data including statistics for a specific user
 * Statistics: monthly counts, yearly counts, streak data, patterns by day
 */
export const getUserAttendanceForAdmin = async (req, res) => {
  try {
    // Validate user ID
    await param('id').isInt().withMessage('Valid user ID is required').run(req);
    
    // Validate query parameters
    await query('start_date').optional().isDate().withMessage('Valid start date is required').run(req);
    await query('end_date').optional().isDate().withMessage('Valid end date is required').run(req);
    
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: 'error',
        message: 'Validation failed',
        errors: errors.array()
      });
    }
    
    const { id } = req.params;
    const { start_date, end_date } = req.query;
    
    // Check if user exists
    const user = await prisma.users.findUnique({
      where: { user_id: parseInt(id) },
      select: {
        user_id: true,
        user_name: true,
        full_name: true,
        email: true,
        role: true
      }
    });
    
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    // Build date filter
    const dateFilter = {};
    if (start_date) dateFilter.gte = new Date(start_date);
    if (end_date) dateFilter.lte = new Date(end_date);
    
    // Get attendance records
    const attendanceRecords = await prisma.attendance.findMany({
      where: {
        user_id: parseInt(id),
        ...(Object.keys(dateFilter).length > 0 ? { attendance_date: dateFilter } : {})
      },
      orderBy: {
        attendance_date: 'desc'
      }
    });
    
    // Get attendance statistics
    const currentDate = new Date();
    const startOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const startOfYear = new Date(currentDate.getFullYear(), 0, 1);
    
    const thisMonthAttendance = await prisma.attendance.count({
      where: {
        user_id: parseInt(id),
        attendance_date: {
          gte: startOfMonth
        }
      }
    });
    
    const thisYearAttendance = await prisma.attendance.count({
      where: {
        user_id: parseInt(id),
        attendance_date: {
          gte: startOfYear
        }
      }
    });
    
    const totalAttendance = await prisma.attendance.count({
      where: {
        user_id: parseInt(id)
      }
    });
    
    // Get first and last attendance dates
    const firstAttendance = await prisma.attendance.findFirst({
      where: { user_id: parseInt(id) },
      orderBy: { attendance_date: 'asc' },
      select: { attendance_date: true }
    });
    
    const lastAttendance = await prisma.attendance.findFirst({
      where: { user_id: parseInt(id) },
      orderBy: { attendance_date: 'desc' },
      select: { attendance_date: true }
    });
    
    // Calculate attendance streak
    let currentStreak = 0;
    
    if (lastAttendance) {
      const lastAttendanceDate = new Date(lastAttendance.attendance_date);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      // Check if last attendance was today
      if (lastAttendanceDate.getTime() === today.getTime()) {
        currentStreak = 1;
        
        // Check previous consecutive days
        let checkDate = new Date(today);
        checkDate.setDate(checkDate.getDate() - 1);
        
        while (true) {
          const checkDateStr = checkDate.toISOString().split('T')[0];
          
          const checkAttendance = await prisma.attendance.findFirst({
            where: {
              user_id: parseInt(id),
              attendance_date: {
                equals: checkDate
              }
            }
          });
          
          if (checkAttendance) {
            currentStreak++;
            checkDate.setDate(checkDate.getDate() - 1);
          } else {
            break;
          }
        }
      }
    }
    
    // Calculate attendance pattern (days of the week)
    const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const attendanceByDay = {};
    
    daysOfWeek.forEach(day => {
      attendanceByDay[day] = 0;
    });
    
    attendanceRecords.forEach(record => {
      const day = daysOfWeek[new Date(record.attendance_date).getDay()];
      attendanceByDay[day]++;
    });
    
    res.status(200).json({
      status: 'success',
      message: 'User attendance fetched successfully',
      data: {
        user,
        attendance: {
          records: attendanceRecords,
          stats: {
            total: totalAttendance,
            thisMonth: thisMonthAttendance,
            thisYear: thisYearAttendance,
            firstAttendance: firstAttendance?.attendance_date || null,
            lastAttendance: lastAttendance?.attendance_date || null,
            currentStreak,
            attendanceByDay
          }
        }
      }
    });
  } catch (error) {
    console.error('Error fetching user attendance:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch user attendance details'
    });
  }
};

/**
 * Manually add attendance record
 * Allows admin to create an attendance record for any user on any date
 * Validates user existence and prevents duplicate entries
 */
export const addAttendanceRecord = async (req, res) => {
  try {
    // Validate request body
    await body('user_id').isInt().withMessage('Valid user ID is required').run(req);
    await body('attendance_date').isDate().withMessage('Valid attendance date is required').run(req);
    await body('gym_id').optional().isInt().withMessage('Valid gym ID is required').run(req);
    
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: 'error',
        message: 'Validation failed',
        errors: errors.array()
      });
    }
    
    const { user_id, attendance_date, gym_id } = req.body;
    
    // Check if user exists
    const user = await prisma.users.findUnique({
      where: { user_id: parseInt(user_id) }
    });
    
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    // Check if gym exists if provided
    if (gym_id) {
      const gym = await prisma.gym.findUnique({
        where: { gym_id: parseInt(gym_id) }
      });
      
      if (!gym) {
        return res.status(404).json({
          status: 'error',
          message: 'Gym not found'
        });
      }
    }
    
    // Check for existing attendance on the same date
    const existingAttendance = await prisma.attendance.findFirst({
      where: {
        user_id: parseInt(user_id),
        attendance_date: new Date(attendance_date)
      }
    });
    
    if (existingAttendance) {
      return res.status(400).json({
        status: 'error',
        message: 'Attendance for this date already exists'
      });
    }
    
    // Create attendance record
    const attendance = await prisma.attendance.create({
      data: {
        user_id: parseInt(user_id),
        attendance_date: new Date(attendance_date),
        gym_id: gym_id ? parseInt(gym_id) : null
      }
    });
    
    res.status(201).json({
      status: 'success',
      message: 'Attendance record added successfully',
      data: attendance
    });
  } catch (error) {
    console.error('Error adding attendance record:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to add attendance record'
    });
  }
};

/**
 * Delete attendance record
 * Removes an attendance record from the system
 */
export const deleteAttendanceRecord = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Check if record exists
    const attendance = await prisma.attendance.findUnique({
      where: { attendance_id: parseInt(id) }
    });
    
    if (!attendance) {
      return res.status(404).json({
        status: 'error',
        message: 'Attendance record not found'
      });
    }
    
    // Delete the record
    await prisma.attendance.delete({
      where: { attendance_id: parseInt(id) }
    });
    
    res.status(200).json({
      status: 'success',
      message: 'Attendance record deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting attendance record:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to delete attendance record'
    });
  }
};

/**
 * Get attendance overview statistics
 * Provides comprehensive attendance metrics for the admin dashboard
 * Includes: daily, weekly, monthly counts and trends
 */
export const getAttendanceStatistics = async (req, res) => {
  try {
    const currentDate = new Date();
    const startOfToday = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate());
    const startOfYesterday = new Date(startOfToday);
    startOfYesterday.setDate(startOfYesterday.getDate() - 1);
    const startOfWeek = new Date(startOfToday);
    startOfWeek.setDate(startOfWeek.getDate() - startOfWeek.getDay());
    const startOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const startOfYear = new Date(currentDate.getFullYear(), 0, 1);
    
    // Today's attendance
    const todayAttendance = await prisma.attendance.count({
      where: {
        attendance_date: {
          equals: startOfToday
        }
      }
    });
    
    // Yesterday's attendance
    const yesterdayAttendance = await prisma.attendance.count({
      where: {
        attendance_date: {
          equals: startOfYesterday
        }
      }
    });
    
    // Weekly attendance
    const weeklyAttendance = await prisma.attendance.count({
      where: {
        attendance_date: {
          gte: startOfWeek
        }
      }
    });
    
    // Monthly attendance
    const monthlyAttendance = await prisma.attendance.count({
      where: {
        attendance_date: {
          gte: startOfMonth
        }
      }
    });
    
    // Yearly attendance
    const yearlyAttendance = await prisma.attendance.count({
      where: {
        attendance_date: {
          gte: startOfYear
        }
      }
    });
    
    // Total users with at least one attendance
    const activeUsers = await prisma.attendance.groupBy({
      by: ['user_id'],
      _count: {
        user_id: true
      }
    });
    
    // Get attendance by gym
    const attendanceByGym = await prisma.attendance.groupBy({
      by: ['gym_id'],
      _count: {
        attendance_id: true
      }
    });
    
    // Get gym names
    const gyms = await prisma.gym.findMany({
      select: {
        gym_id: true,
        gym_name: true
      }
    });
    
    // Map gym IDs to names
    const gymAttendance = attendanceByGym.map(item => {
      const gym = gyms.find(g => g.gym_id === item.gym_id);
      return {
        gym_id: item.gym_id,
        gym_name: gym ? gym.gym_name : 'Unknown',
        count: item._count.attendance_id
      };
    });
    
    // Daily attendance for the past month (for trend graph)
    const pastMonthDate = new Date(currentDate);
    pastMonthDate.setMonth(pastMonthDate.getMonth() - 1);
    
    const dailyAttendance = await prisma.$queryRaw`
      SELECT DATE(attendance_date) as date, COUNT(*) as count
      FROM attendance
      WHERE attendance_date >= ${pastMonthDate}
      GROUP BY DATE(attendance_date)
      ORDER BY date ASC
    `;
    
    res.status(200).json({
      status: 'success',
      message: 'Attendance statistics fetched successfully',
      data: {
        overview: {
          today: todayAttendance,
          yesterday: yesterdayAttendance,
          thisWeek: weeklyAttendance,
          thisMonth: monthlyAttendance,
          thisYear: yearlyAttendance,
          totalActiveUsers: activeUsers.length
        },
        byGym: gymAttendance,
        dailyTrend: dailyAttendance
      }
    });
  } catch (error) {
    console.error('Error fetching attendance statistics:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch attendance statistics'
    });
  }
};