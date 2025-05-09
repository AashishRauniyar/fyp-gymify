import prisma from '../../prisma/prisma.js';
import { body, validationResult } from 'express-validator';
import moment from 'moment-timezone';
import { sendWelcomeEmail } from '../../utils/sendMail.js';



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

        // Get current time in Nepal timezone
        const nepalDateTime = moment().tz('Asia/Kathmandu');

        // Start of day in Nepal for checking existing attendance
        const nepalStartOfDay = nepalDateTime.clone().startOf('day').toDate();
        const nepalEndOfDay = nepalDateTime.clone().endOf('day').toDate();

        // Check for existing attendance today
        const existingAttendance = await prisma.attendance.findFirst({
            where: {
                user_id: user.user_id,
                attendance_date: {
                    gte: nepalStartOfDay,
                    lte: nepalEndOfDay
                }
            }
        });

        // if (existingAttendance) {
        //     return res.status(400).json({
        //         status: 'failure',
        //         message: 'Attendance already marked for today'
        //     });
        // }

        // Change this part in your markAttendance function
        if (existingAttendance) {
            // Instead of returning an error, send a successful response
            // but with a note that attendance was already marked
            return res.status(200).json({
                status: 'success',
                message: 'Attendance was already marked today, but access granted',
                data: {
                    user_name: user.user_name,
                    previous_attendance: true
                }
            });
        }

        // Mark attendance with current Nepal time
        const attendance = await prisma.attendance.create({
            data: {
                user_id: user.user_id,
                attendance_date: nepalDateTime.toDate() // Store the full Nepal datetime
            }
        });

        // Send welcome email after marking attendance
        const emailSent = await sendWelcomeEmail(user.email, user.user_name);
        if (!emailSent) {
            console.error("Failed to send welcome email");
        }

        res.status(201).json({
            status: 'success',
            message: 'Attendance marked successfully',
            data: {
                attendance_id: attendance.attendance_id,
                user_name: user.user_name,
                date: attendance.attendance_date,
                nepal_datetime: nepalDateTime.format('YYYY-MM-DD HH:mm:ss')
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

//         // Get current time in Nepal timezone
//         const nepalDateTime = moment().tz('Asia/Kathmandu');

//         // Start of day in Nepal for checking existing attendance
//         const nepalStartOfDay = nepalDateTime.clone().startOf('day').toDate();
//         const nepalEndOfDay = nepalDateTime.clone().endOf('day').toDate();

//         // Check for existing attendance today
//         const existingAttendance = await prisma.attendance.findFirst({
//             where: {
//                 user_id: user.user_id,
//                 attendance_date: {
//                     gte: nepalStartOfDay,
//                     lte: nepalEndOfDay
//                 }
//             }
//         });

//         if (existingAttendance) {
//             return res.status(400).json({
//                 status: 'failure',
//                 message: 'Attendance already marked for today'
//             });
//         }

//         // Mark attendance with current Nepal time
//         const attendance = await prisma.attendance.create({
//             data: {
//                 user_id: user.user_id,
//                 attendance_date: nepalDateTime.toDate() // Store the full Nepal datetime
//             }
//         });

//         res.status(201).json({
//             status: 'success',
//             message: 'Attendance marked successfully',
//             data: {
//                 attendance_id: attendance.attendance_id,
//                 user_name: user.user_name,
//                 date: attendance.attendance_date,
//                 nepal_datetime: nepalDateTime.format('YYYY-MM-DD HH:mm:ss')
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

        const totalAttendance = await prisma.attendance.count({
            where: {
                user_id: parseInt(user_id)
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Attendance history fetched successfully',
            data: {
                attendance: attendanceHistory,
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
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const attendance = await prisma.attendance.findMany({
            where: {
                attendance_date: {
                    equals: today
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

        res.status(200).json({
            status: 'success',
            message: 'Today\'s attendance fetched successfully',
            data: attendance
        });

    } catch (error) {
        console.error('Error fetching today\'s attendance:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};
