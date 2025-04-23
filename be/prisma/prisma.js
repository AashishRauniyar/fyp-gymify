import { PrismaClient } from '@prisma/client';

// PrismaClient is attached to the `global` object in development to prevent
// exhausting your database connection limit.
// Learn more: https://pris.ly/d/help/next-js-best-practices

// Check if we've already instantiated a Prisma client in the global object
const globalForPrisma = global;

// Initialize the singleton Prisma client with enhanced monitoring
export const prisma = globalForPrisma.prisma ||
    new PrismaClient({
        log: ['error', 'warn'],
    });

// Connection management and monitoring
let isConnected = true;

// Add event listeners for connection issues
prisma.$on('query', () => {
    if (!isConnected) {
        console.log('Database connection restored');
        isConnected = true;
    }
});

prisma.$on('error', (e) => {
    console.error('Prisma Client error:', e);
    isConnected = false;
});

// Implement connection recovery function
export async function ensureConnection() {
    if (!isConnected) {
        try {
            await prisma.$disconnect();
            await prisma.$connect();
            isConnected = true;
            console.log('Database connection re-established');
        } catch (error) {
            console.error('Failed to re-establish database connection:', error);
            throw error;
        }
    }
}

// Auto-recovery function that can be called before critical operations
export async function withRecovery(fn) {
    try {
        await ensureConnection();
        return await fn();
    } catch (error) {
        if (error.message.includes('connection') || error.code === 'P2037') {
            console.error('Connection error detected, attempting recovery...');
            await ensureConnection();
            return await fn(); // Retry the operation
        }
        throw error;
    }
}

// Save the client to the global object in development
if (process.env.NODE_ENV !== 'production') {
    globalForPrisma.prisma = prisma;
}

// Export a function to explicitly disconnect if needed (for testing, etc.)
export async function disconnectPrisma() {
    await prisma.$disconnect();
    isConnected = false;
}

// Export a default export for easier importing
export default prisma;