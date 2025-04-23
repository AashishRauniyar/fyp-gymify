import { PrismaClient } from '@prisma/client';

// PrismaClient is attached to the `global` object in development to prevent
// exhausting your database connection limit.
// Learn more: https://pris.ly/d/help/next-js-best-practices

// Check if we've already instantiated a Prisma client in the global object
const globalForPrisma = global;

// Initialize the singleton Prisma client
export const prisma = globalForPrisma.prisma ||
    new PrismaClient({
        log: ['error', 'warn'],
    });

// Save the client to the global object in development
if (process.env.NODE_ENV !== 'production') {
    globalForPrisma.prisma = prisma;
}

// Export a function to explicitly disconnect if needed (for testing, etc.)
export async function disconnectPrisma() {
    await prisma.$disconnect();
}

// Export a default export for easier importing
export default prisma;