# Docker Setup for Gymify Backend and PostgreSQL

This document provides detailed instructions for setting up and running the Gymify backend and PostgreSQL database using Docker and Docker Compose.

---

## Prerequisites

1. Install [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/).
2. Ensure the `.env` file is properly configured with the required environment variables.

---

## Environment Variables

The `.env` file should include the necessary variables for the backend and database. Below is an example structure (do not expose sensitive information in public repositories):

```properties
DATABASE_URL="<your-database-url>"
JWT_SECRET="<your-jwt-secret>"
PORT="<your-port>"

CLOUDINARY_URL="<your-cloudinary-url>"
CLOUDINARY_API_KEY="<your-cloudinary-api-key>"
CLOUDINARY_API_SECRET="<your-cloudinary-api-secret>"
CLOUD_NAME="<your-cloud-name>"

EMAIL_USER="<your-email-user>"
EMAIL_PASS="<your-email-password>"

KHALTI_SECRET_KEY="<your-khalti-secret-key>"
NODE_ENV="<your-node-environment>"
BASE_URL="<your-base-url>"
```

---

## Docker Setup

### 1. **Docker Compose File**

The `docker-compose.yml` file defines the services for the backend and PostgreSQL database:

```yaml
version: '3.8'

services:
  backend:
    build:
      context: .
      dockerfile: DockerFile
    ports:
      - "8000:8000" # Map backend container port 8000 to host port 8000
    env_file:
      - .env # Load environment variables from .env file
    depends_on:
      - postgres # Ensure PostgreSQL starts before the backend
    command: sh -c "npx prisma migrate deploy && npm start" # Run migrations and start the app

  postgres:
    image: postgres:15 # Use PostgreSQL version 15
    container_name: gymify-postgres # Name the PostgreSQL container
    restart: always # Restart the container automatically if it stops
    environment:
      POSTGRES_USER: <your-postgres-user> # PostgreSQL username
      POSTGRES_PASSWORD: <your-postgres-password> # PostgreSQL password
      POSTGRES_DB: <your-database-name> # PostgreSQL database name
    ports:
      - "5432:5432" # Map PostgreSQL container port 5432 to host port 5432
    volumes:
      - postgres_data:/var/lib/postgresql/data # Persist PostgreSQL data

volumes:
  postgres_data: # Named volume to persist PostgreSQL data
```

---

### 2. **DockerFile**

The `DockerFile` for the backend ensures that dependencies are installed, the Prisma client is generated, and the app is started:

```dockerfile
FROM node:22

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all application files to the working directory
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Expose the port the app will run on
EXPOSE 8000

# Run migrations and start the app
CMD ["sh", "-c", "npx prisma migrate deploy && npm start"]
```

---

## Steps to Build and Run the Containers

### 1. **Build the Containers**
Run the following command to build the backend and PostgreSQL containers:
```bash
docker-compose build
```

### 2. **Start the Containers**
Start the containers using:
```bash
docker-compose up -d
```
- `-d`: Runs the containers in detached mode.

### 3. **Verify the Setup**

#### Check Running Containers:
```bash
docker ps
```
You should see two containers: one for the backend and one for PostgreSQL.

#### Access the Backend:
Open your browser or use a tool like Postman to access the backend at:
```
http://localhost:8000
```

#### Access PostgreSQL:
You can access the PostgreSQL container to verify the database:
```bash
docker exec -it gymify-postgres psql -U <your-postgres-user> -d <your-database-name>
```

---

## Importing Data into PostgreSQL

If you have a database dump file (e.g., `backup.sql`), follow these steps to import it into the PostgreSQL container:

1. **Copy the Dump File into the PostgreSQL Container**:
   ```bash
   docker cp backup.sql gymify-postgres:/backup.sql
   ```

2. **Access the PostgreSQL Container**:
   ```bash
   docker exec -it gymify-postgres sh
   ```

3. **Restore the Database**:
   Inside the container, run:
   ```bash
   psql -U <your-postgres-user> -d <your-database-name> < /backup.sql
   ```

4. **Verify the Data**:
   Run SQL queries to verify the imported data:
   ```sql
   \dt; -- List all tables
   SELECT * FROM users; -- Example query
   ```

---

## Logs and Debugging

### View Backend Logs:
```bash
docker logs <backend-container-name>
```

### View PostgreSQL Logs:
```bash
docker logs gymify-postgres
```

---

## Stopping and Removing Containers

### Stop the Containers:
```bash
docker-compose down
```

### Remove All Containers, Volumes, and Networks:
```bash
docker-compose down --volumes
```

---

## Notes

- Ensure your `.env` file is secure and does not expose sensitive credentials in production.
- Use `docker-compose down --volumes` cautiously, as it will delete all database data.

---

## Troubleshooting

### Error: `P1001: Can't reach database server`
- Ensure the `DATABASE_URL` in `.env` points to the `postgres` service in `docker-compose.yml`.
- Verify that the PostgreSQL container is running:
  ```bash
  docker ps
  ```

### Error: `@prisma/client did not initialize`
- Ensure `npx prisma generate` is run during the Docker build process.
- Rebuild the containers:
  ```bash
  docker-compose build
  docker-compose up -d
  ```

---

## Additional Commands

### Access the Backend Container:
```bash
docker exec -it <backend-container-name> sh
```

### Access the PostgreSQL Container:
```bash
docker exec -it gymify-postgres sh
```

---

This completes the setup for the Gymify backend and PostgreSQL database using Docker. Let me know if you encounter any issues!