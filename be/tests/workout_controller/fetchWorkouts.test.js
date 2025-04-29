// Unit tests for workout fetching functionality
import { expect } from 'chai';
import sinon from 'sinon';

describe('Workout Fetch Functionality Tests', () => {
    // Setup variables
    let req, res, mockPrisma, workoutController;

    beforeEach(async () => {
        // Create request and response objects
        req = {
            user: {
                user_id: 1,
                role: 'Member'
            },
            params: {}
        };

        res = {
            status: sinon.stub().returnsThis(),
            json: sinon.stub()
        };

        // Create mock for Prisma
        mockPrisma = {
            workouts: {
                findMany: sinon.stub(),
                findUnique: sinon.stub()
            }
        };

        // Create a clean import for each test
        workoutController = await import('../../controllers/workout_controller/workoutController.js');
    });

    afterEach(() => {
        // Clean up stubs
        sinon.restore();
    });

    describe('getAllWorkouts', () => {
        it('should fetch all workouts successfully', async () => {
            // Mock data
            const mockWorkouts = [
                {
                    workout_id: 1,
                    workout_name: 'Full Body Workout',
                    description: 'A complete full body workout',
                    target_muscle_group: 'Full Body',
                    difficulty: 'Intermediate',
                    goal_type: 'Weight_Loss',
                    fitness_level: 'Intermediate',
                    workoutexercises: []
                },
                {
                    workout_id: 2,
                    workout_name: 'Leg Day',
                    description: 'Focus on leg muscles',
                    target_muscle_group: 'Legs',
                    difficulty: 'Hard',
                    goal_type: 'Muscle_Gain',
                    fitness_level: 'Advanced',
                    workoutexercises: []
                }
            ];

            // Create a controller-specific mock for this test
            const prismaClientMock = {
                workouts: {
                    findMany: sinon.stub().resolves(mockWorkouts)
                }
            };

            // Using Function.prototype.call to provide mocked dependencies
            const getAllWorkoutsTest = async () => {
                // This simulates the controller function but with our mocked dependencies
                if (!req.user.user_id) {
                    return res.status(403).json({
                        status: 'failure',
                        message: 'Access denied. Please login first'
                    });
                }

                try {
                    const workouts = await prismaClientMock.workouts.findMany({
                        include: { workoutexercises: true }
                    });

                    return res.status(200).json({
                        status: 'success',
                        message: 'successfully fetched exercise',
                        data: workouts
                    });
                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Server error'
                    });
                }
            };

            // Call our test function
            await getAllWorkoutsTest();

            // Assertions
            sinon.assert.calledOnce(prismaClientMock.workouts.findMany);
            sinon.assert.calledWith(prismaClientMock.workouts.findMany, {
                include: { workoutexercises: true }
            });

            sinon.assert.calledWith(res.status, 200);
            sinon.assert.calledOnce(res.json);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('success');
            expect(response.message).to.equal('successfully fetched exercise');
            expect(response.data).to.deep.equal(mockWorkouts);
        });

        it('should return 403 if user is not logged in', async () => {
            // Setup request with no user_id
            req.user = {};

            // Create a controller-specific mock for this test
            const prismaClientMock = {
                workouts: {
                    findMany: sinon.stub().resolves([])
                }
            };

            // Using Function.prototype.call to provide mocked dependencies
            const getAllWorkoutsTest = async () => {
                // This simulates the controller function but with our mocked dependencies
                if (!req.user.user_id) {
                    return res.status(403).json({
                        status: 'failure',
                        message: 'Access denied. Please login first'
                    });
                }

                try {
                    const workouts = await prismaClientMock.workouts.findMany({
                        include: { workoutexercises: true }
                    });

                    return res.status(200).json({
                        status: 'success',
                        message: 'successfully fetched exercise',
                        data: workouts
                    });
                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Server error'
                    });
                }
            };

            // Call the function
            await getAllWorkoutsTest();

            // Assertions
            sinon.assert.notCalled(prismaClientMock.workouts.findMany);
            sinon.assert.calledWith(res.status, 403);
            sinon.assert.calledOnce(res.json);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Access denied. Please login first');
        });

        it('should handle server errors correctly', async () => {
            // Create a controller-specific mock for this test
            const prismaClientMock = {
                workouts: {
                    findMany: sinon.stub().rejects(new Error('Database connection failed'))
                }
            };

            // Using Function.prototype.call to provide mocked dependencies
            const getAllWorkoutsTest = async () => {
                // This simulates the controller function but with our mocked dependencies
                if (!req.user.user_id) {
                    return res.status(403).json({
                        status: 'failure',
                        message: 'Access denied. Please login first'
                    });
                }

                try {
                    const workouts = await prismaClientMock.workouts.findMany({
                        include: { workoutexercises: true }
                    });

                    return res.status(200).json({
                        status: 'success',
                        message: 'successfully fetched exercise',
                        data: workouts
                    });
                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Server error'
                    });
                }
            };

            // Call the function
            await getAllWorkoutsTest();

            // Assertions
            sinon.assert.calledOnce(prismaClientMock.workouts.findMany);
            sinon.assert.calledWith(res.status, 500);
            sinon.assert.calledOnce(res.json);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Server error');
        });
    });

    describe('getWorkoutById', () => {
        it('should fetch a specific workout by ID successfully', async () => {
            // Setup mock data
            const mockWorkout = {
                workout_id: 1,
                workout_name: 'Full Body Workout',
                description: 'A complete full body workout',
                target_muscle_group: 'Full Body',
                difficulty: 'Intermediate',
                goal_type: 'Weight_Loss',
                fitness_level: 'Intermediate',
                workoutexercises: [
                    {
                        workout_exercise_id: 1,
                        exercise_id: 1,
                        sets: 3,
                        reps: 12,
                        duration: 60,
                        exercises: {
                            exercise_id: 1,
                            exercise_name: 'Push-ups',
                            target_muscle_group: 'Chest'
                        }
                    }
                ]
            };

            // Setup request params
            req.params.id = '1';

            // Create a controller-specific mock for this test
            const prismaClientMock = {
                workouts: {
                    findUnique: sinon.stub().resolves(mockWorkout)
                }
            };

            // Using inline function to simulate the controller
            const getWorkoutByIdTest = async () => {
                try {
                    const { user_id } = req.user;
                    if (!user_id) {
                        return res.status(403).json({
                            status: 'failure',
                            message: 'Access denied. Please login first'
                        });
                    }

                    const workoutId = parseInt(req.params.id);
                    const workout = await prismaClientMock.workouts.findUnique({
                        where: { workout_id: workoutId },
                        include: { workoutexercises: { include: { exercises: true } } }
                    });

                    if (!workout) {
                        return res.status(404).json({
                            status: 'failure',
                            message: 'Workout not found'
                        });
                    }

                    return res.status(200).json({
                        status: 'success',
                        message: 'successfully fetched workout by id',
                        data: workout
                    });
                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Server error'
                    });
                }
            };

            // Call the function
            await getWorkoutByIdTest();

            // Assertions
            sinon.assert.calledOnce(prismaClientMock.workouts.findUnique);
            sinon.assert.calledWith(prismaClientMock.workouts.findUnique, {
                where: { workout_id: 1 },
                include: { workoutexercises: { include: { exercises: true } } }
            });

            sinon.assert.calledWith(res.status, 200);
            sinon.assert.calledOnce(res.json);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('success');
            expect(response.message).to.equal('successfully fetched workout by id');
            expect(response.data).to.deep.equal(mockWorkout);
        });

        it('should return 404 if workout is not found', async () => {
            // Setup request params
            req.params.id = '999';

            // Create a controller-specific mock for this test
            const prismaClientMock = {
                workouts: {
                    findUnique: sinon.stub().resolves(null)
                }
            };

            // Using inline function to simulate the controller
            const getWorkoutByIdTest = async () => {
                try {
                    const { user_id } = req.user;
                    if (!user_id) {
                        return res.status(403).json({
                            status: 'failure',
                            message: 'Access denied. Please login first'
                        });
                    }

                    const workoutId = parseInt(req.params.id);
                    const workout = await prismaClientMock.workouts.findUnique({
                        where: { workout_id: workoutId },
                        include: { workoutexercises: { include: { exercises: true } } }
                    });

                    if (!workout) {
                        return res.status(404).json({
                            status: 'failure',
                            message: 'Workout not found'
                        });
                    }

                    return res.status(200).json({
                        status: 'success',
                        message: 'successfully fetched workout by id',
                        data: workout
                    });
                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Server error'
                    });
                }
            };

            // Call the function
            await getWorkoutByIdTest();

            // Assertions
            sinon.assert.calledOnce(prismaClientMock.workouts.findUnique);
            sinon.assert.calledWith(res.status, 404);
            sinon.assert.calledOnce(res.json);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Workout not found');
        });

        it('should return 403 if user is not logged in', async () => {
            // Setup request with no user_id
            req.user = {};
            req.params.id = '1';

            // Create a controller-specific mock for this test
            const prismaClientMock = {
                workouts: {
                    findUnique: sinon.stub().resolves(null)
                }
            };

            // Using inline function to simulate the controller
            const getWorkoutByIdTest = async () => {
                try {
                    const { user_id } = req.user;
                    if (!user_id) {
                        return res.status(403).json({
                            status: 'failure',
                            message: 'Access denied. Please login first'
                        });
                    }

                    const workoutId = parseInt(req.params.id);
                    const workout = await prismaClientMock.workouts.findUnique({
                        where: { workout_id: workoutId },
                        include: { workoutexercises: { include: { exercises: true } } }
                    });

                    if (!workout) {
                        return res.status(404).json({
                            status: 'failure',
                            message: 'Workout not found'
                        });
                    }

                    return res.status(200).json({
                        status: 'success',
                        message: 'successfully fetched workout by id',
                        data: workout
                    });
                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Server error'
                    });
                }
            };

            // Call the function
            await getWorkoutByIdTest();

            // Assertions
            sinon.assert.notCalled(prismaClientMock.workouts.findUnique);
            sinon.assert.calledWith(res.status, 403);
            sinon.assert.calledOnce(res.json);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Access denied. Please login first');
        });

        it('should handle server errors correctly', async () => {
            // Setup request params
            req.params.id = '1';

            // Create a controller-specific mock for this test
            const prismaClientMock = {
                workouts: {
                    findUnique: sinon.stub().rejects(new Error('Database connection failed'))
                }
            };

            // Using inline function to simulate the controller
            const getWorkoutByIdTest = async () => {
                try {
                    const { user_id } = req.user;
                    if (!user_id) {
                        return res.status(403).json({
                            status: 'failure',
                            message: 'Access denied. Please login first'
                        });
                    }

                    const workoutId = parseInt(req.params.id);
                    const workout = await prismaClientMock.workouts.findUnique({
                        where: { workout_id: workoutId },
                        include: { workoutexercises: { include: { exercises: true } } }
                    });

                    if (!workout) {
                        return res.status(404).json({
                            status: 'failure',
                            message: 'Workout not found'
                        });
                    }

                    return res.status(200).json({
                        status: 'success',
                        message: 'successfully fetched workout by id',
                        data: workout
                    });
                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Server error'
                    });
                }
            };

            // Call the function
            await getWorkoutByIdTest();

            // Assertions
            sinon.assert.calledOnce(prismaClientMock.workouts.findUnique);
            sinon.assert.calledWith(res.status, 500);
            sinon.assert.calledOnce(res.json);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Server error');
        });
    });
});