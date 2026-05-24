# build stage 
FROM node:22-alpine AS builder

WORKDIR /app

RUN corepack enable


COPY package.json pnpm-lock.yaml ./


RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build-docker



# Runtime image 

FROM node:22-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV HOSTNAME=0.0.0.0
ENV PORT=3000

# Create non-root user
RUN addgroup -S app && adduser -S app -G app

# Copy ONLY production build output
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

# Prisma client only 
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma/client ./node_modules/@prisma/client

# Switch to non-root
USER app

EXPOSE 3000

CMD ["node", "server.js"]