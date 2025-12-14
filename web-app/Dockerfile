# Build stage
FROM oven/bun:1 as builder

WORKDIR /app

# Copy package files
COPY package.json bun.lockb* ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy source files
COPY . .

# Build the app
RUN bun run build

# Production stage
FROM oven/bun:1-slim

WORKDIR /app

# Copy built files and server
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/server.ts ./
COPY --from=builder /app/package.json ./

# Expose port
EXPOSE 3000

ENV PORT=3000

# Run the server
CMD ["bun", "run", "server.ts"]
