// import { PrismaClient } from '@prisma/client';

// import { body, validationResult } from 'express-validator';

// const prisma = new PrismaClient();


// export const markAttendance = async (req, res) => {
//     try {
//         // Validate card number
//         await body('card_number').notEmpty().withMessage('Card number is required').run(req);

//         const errors = validationResult(req);
//         if (!errors.isEmpty()) {
//             return res.status(400).json({
//                 status: 'failure',
//                 message: 'Validation failed',
//                 errors: errors.array()
//             });
//         }

//         const { card_number } = req.body;

//         // Find user by card number
//         const user = await prisma.users.findFirst({
//             where: { card_number },
//             include: {
//                 memberships: {
//                     where: {
//                         status: 'Active',
//                         end_date: {
//                             gte: new Date().toISOString()
//                         }
//                     }
//                 }
//             }
//         });

//         if (!user) {
//             return res.status(404).json({
//                 status: 'failure',
//                 message: 'Invalid card or user not found'
//             });
//         }

//         // Check for active membership
//         if (!user.memberships || user.memberships.length === 0) {
//             return res.status(403).json({
//                 status: 'failure',
//                 message: 'No active membership found'
//             });
//         }

//         // Check for existing attendance today
//         const today = new Date();
//         today.setHours(0, 0, 0, 0);

//         const existingAttendance = await prisma.attendance.findFirst({
//             where: {
//                 user_id: user.user_id,
//                 attendance_date: {
//                     equals: today
//                 }
//             }
//         });

//         if (existingAttendance) {
//             return res.status(400).json({
//                 status: 'failure',
//                 message: 'Attendance already marked for today'
//             });
//         }

//         // Mark attendance
//         const attendance = await prisma.attendance.create({
//             data: {
//                 user_id: user.user_id,
//                 attendance_date: today
//             }
//         });

//         res.status(201).json({
//             status: 'success',
//             message: 'Attendance marked successfully',
//             data: {
//                 attendance_id: attendance.attendance_id,
//                 user_name: user.user_name,
//                 date: attendance.attendance_date
//             }
//         });

//     } catch (error) {
//         console.error('Error marking attendance:', error);
//         res.status(500).json({
//             status: 'failure',
//             message: 'Server error'
//         });
//     }
// };


// // Get attendance history
// export const getAttendanceHistory = async (req, res) => {
//     try {
//         const { user_id } = req.params;
//         const { start_date, end_date } = req.query;

//         const attendanceHistory = await prisma.attendance.findMany({
//             where: {
//                 user_id: parseInt(user_id),
//                 attendance_date: {
//                     gte: start_date ? new Date(start_date) : undefined,
//                     lte: end_date ? new Date(end_date) : undefined
//                 }
//             },
//             orderBy: {
//                 attendance_date: 'desc'
//             },
//             include: {
//                 users: {
//                     select: {
//                         user_name: true,
//                         full_name: true
//                     }
//                 }
//             }
//         });

//         const totalAttendance = await prisma.attendance.count({
//             where: {
//                 user_id: parseInt(user_id)
//             }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Attendance history fetched successfully',
//             data: {
//                 attendance: attendanceHistory,
//                 total: totalAttendance
//             }
//         });

//     } catch (error) {
//         console.error('Error fetching attendance history:', error);
//         res.status(500).json({
//             status: 'failure',
//             message: 'Server error'
//         });
//     }
// };

// // Get today's attendance
// export const getTodayAttendance = async (req, res) => {
//     try {
//         const today = new Date();
//         today.setHours(0, 0, 0, 0);

//         const attendance = await prisma.attendance.findMany({
//             where: {
//                 attendance_date: {
//                     equals: today
//                 }
//             },
//             include: {
//                 users: {
//                     select: {
//                         user_name: true,
//                         full_name: true
//                     }
//                 }
//             },
//             orderBy: {
//                 attendance_date: 'desc'
//             }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Today\'s attendance fetched successfully',
//             data: attendance
//         });

//     } catch (error) {
//         console.error('Error fetching today\'s attendance:', error);
//         res.status(500).json({
//             status: 'failure',
//             message: 'Server error'
//         });
//     }
// };

import { PrismaClient } from '@prisma/client';
import { body, validationResult } from 'express-validator';

const prisma = new PrismaClient();

export const markAttendance = async (req, res) => {
    try {
        // Validate card number
        await body('card_number').notEmpty().withMessage('Card number is required').run(req);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { card_number } = req.body;

        // Find user by card number
        const user = await prisma.users.findFirst({
            where: { card_number },
            include: {
                memberships: {
                    where: {
                        status: 'Active',
                        end_date: {
                            gte: new Date().toISOString()
                        }
                    }
                }
            }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'Invalid card or user not found'
            });
        }

        // Check for active membership
        if (!user.memberships || user.memberships.length === 0) {
            return res.status(403).json({
                status: 'failure',
                message: 'No active membership found'
            });
        }

        // Get current date (based on system time which should be set to Nepal timezone on the server)
        const today = new Date();
        // Set to beginning of day to ignore time portion
        today.setHours(0, 0, 0, 0);
        
        // Get end of day
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);
        
        // Check for existing attendance today
        const existingAttendance = await prisma.attendance.findFirst({
            where: {
                user_id: user.user_id,
                attendance_date: {
                    gte: today,
                    lt: tomorrow
                }
            }
        });

        if (existingAttendance) {
            return res.status(400).json({
                status: 'failure',
                message: 'Attendance already marked for today'
            });
        }

        // Mark attendance
        const attendance = await prisma.attendance.create({
            data: {
                user_id: user.user_id,
                attendance_date: today
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'Attendance marked successfully',
            data: {
                attendance_id: attendance.attendance_id,
                user_name: user.user_name,
                date: today.toISOString().split('T')[0]  // Just return YYYY-MM-DD
            }
        });

    } catch (error) {
        console.error('Error marking attendance:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};

// Get attendance history
export const getAttendanceHistory = async (req, res) => {
    try {
        const { user_id } = req.params;
        const { start_date, end_date } = req.query;

        const attendanceHistory = await prisma.attendance.findMany({
            where: {
                user_id: parseInt(user_id),
                attendance_date: {
                    gte: start_date ? new Date(start_date) : undefined,
                    lte: end_date ? new Date(end_date) : undefined
                }
            },
            orderBy: {
                attendance_date: 'desc'
            },
            include: {
                users: {
                    select: {
                        user_name: true,
                        full_name: true
                    }
                }
            }
        });

        // Format dates in the response
        const formattedHistory = attendanceHistory.map(record => ({
            ...record,
            attendance_date: record.attendance_date.toISOString().split('T')[0] // YYYY-MM-DD format
        }));

        const totalAttendance = await prisma.attendance.count({
            where: {
                user_id: parseInt(user_id)
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Attendance history fetched successfully',
            data: {
                attendance: formattedHistory,
                total: totalAttendance
            }
        });

    } catch (error) {
        console.error('Error fetching attendance history:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};

// Get today's attendance
export const getTodayAttendance = async (req, res) => {
    try {
        // Get current date (based on system time)
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        // Get end of day
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);

        const attendance = await prisma.attendance.findMany({
            where: {
                attendance_date: {
                    gte: today,
                    lt: tomorrow
                }
            },
            include: {
                users: {
                    select: {
                        user_name: true,
                        full_name: true
                    }
                }
            },
            orderBy: {
                attendance_date: 'desc'
            }
        });

        // Format the response
        const formattedAttendance = attendance.map(record => ({
            ...record,
            attendance_date: record.attendance_date.toISOString().split('T')[0] // YYYY-MM-DD format
        }));

        res.status(200).json({
            status: 'success',
            message: 'Today\'s attendance fetched successfully',
            data: formattedAttendance,
            today: today.toISOString().split('T')[0]
        });

    } catch (error) {
        console.error('Error fetching today\'s attendance:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};