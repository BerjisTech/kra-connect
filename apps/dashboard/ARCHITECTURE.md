# KRA Tax Compliance Dashboard - Architecture

## Overview

A full-stack SaaS application for managing KRA tax compliance, supplier verification, and automated NIL return filing.

## Tech Stack

### Backend
- **Runtime**: Node.js 20+
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: PostgreSQL 15+
- **Cache**: Redis
- **ORM**: Prisma
- **Authentication**: JWT + bcrypt
- **API Documentation**: Swagger/OpenAPI
- **Testing**: Jest + Supertest

### Frontend
- **Framework**: Next.js 14+ (App Router)
- **Language**: TypeScript
- **UI Library**: shadcn/ui + Radix UI
- **Styling**: Tailwind CSS
- **State Management**: Zustand
- **Forms**: React Hook Form + Zod
- **Data Fetching**: TanStack Query (React Query)
- **Charts**: Recharts
- **Testing**: Jest + React Testing Library

### Infrastructure
- **Containerization**: Docker + Docker Compose
- **API Gateway**: Nginx (production)
- **File Storage**: Local/S3
- **Email**: SendGrid/SMTP
- **SMS**: Africa's Talking
- **Monitoring**: Sentry
- **CI/CD**: GitHub Actions

## Architecture Patterns

### Backend Architecture

```
apps/dashboard/backend/
├── src/
│   ├── modules/           # Feature modules
│   │   ├── auth/          # Authentication & authorization
│   │   ├── users/         # User management
│   │   ├── organizations/ # Multi-tenant organizations
│   │   ├── verification/  # PIN/TCC verification
│   │   ├── suppliers/     # Supplier management
│   │   ├── nil-returns/   # NIL return filing
│   │   ├── compliance/    # Compliance tracking
│   │   └── notifications/ # Email/SMS notifications
│   ├── common/            # Shared code
│   │   ├── middleware/    # Express middleware
│   │   ├── guards/        # Auth guards
│   │   ├── decorators/    # Custom decorators
│   │   ├── filters/       # Error filters
│   │   ├── interceptors/  # Request/response interceptors
│   │   └── utils/         # Utility functions
│   ├── config/            # Configuration
│   ├── database/          # Database setup
│   │   ├── migrations/    # Prisma migrations
│   │   ├── seeds/         # Seed data
│   │   └── prisma.ts      # Prisma client
│   └── main.ts            # Application entry point
├── tests/                 # Test files
├── prisma/
│   └── schema.prisma      # Database schema
├── docker-compose.yml
├── Dockerfile
└── package.json
```

### Frontend Architecture

```
apps/dashboard/frontend/
├── src/
│   ├── app/               # Next.js App Router
│   │   ├── (auth)/        # Auth routes
│   │   │   ├── login/
│   │   │   ├── register/
│   │   │   └── forgot-password/
│   │   ├── (dashboard)/   # Dashboard routes
│   │   │   ├── page.tsx   # Dashboard home
│   │   │   ├── verify/    # PIN/TCC verification
│   │   │   ├── suppliers/ # Supplier management
│   │   │   ├── compliance/# Compliance tracking
│   │   │   ├── nil-returns/# NIL returns
│   │   │   └── settings/  # Settings
│   │   ├── api/           # API routes (if needed)
│   │   ├── layout.tsx     # Root layout
│   │   └── globals.css    # Global styles
│   ├── components/        # React components
│   │   ├── ui/            # shadcn/ui components
│   │   ├── forms/         # Form components
│   │   ├── charts/        # Chart components
│   │   ├── tables/        # Table components
│   │   └── layouts/       # Layout components
│   ├── lib/               # Utilities
│   │   ├── api/           # API client
│   │   ├── hooks/         # Custom hooks
│   │   ├── utils/         # Utility functions
│   │   ├── validations/   # Zod schemas
│   │   └── constants/     # Constants
│   ├── store/             # Zustand stores
│   ├── types/             # TypeScript types
│   └── styles/            # Additional styles
├── public/                # Static assets
├── tests/                 # Test files
├── next.config.js
├── tailwind.config.js
└── package.json
```

## Database Schema

### Core Tables

#### users
- id (uuid, PK)
- email (unique)
- password_hash
- first_name
- last_name
- phone_number
- role (ADMIN, USER, VIEWER)
- organization_id (FK)
- email_verified
- is_active
- last_login_at
- created_at
- updated_at

#### organizations
- id (uuid, PK)
- name
- slug (unique)
- kra_pin
- tcc_number
- subscription_tier (FREE, PRO, BUSINESS, ENTERPRISE)
- subscription_status
- subscription_expires_at
- api_key (encrypted)
- settings (JSONB)
- created_at
- updated_at

#### suppliers
- id (uuid, PK)
- organization_id (FK)
- name
- kra_pin
- tcc_number
- email
- phone_number
- address
- category
- status (ACTIVE, INACTIVE, BLACKLISTED)
- last_verified_at
- verification_status
- compliance_score
- notes
- metadata (JSONB)
- created_at
- updated_at

#### verification_logs
- id (uuid, PK)
- organization_id (FK)
- supplier_id (FK, nullable)
- user_id (FK)
- verification_type (PIN, TCC)
- identifier (PIN or TCC number)
- result (JSONB)
- status (SUCCESS, FAILED, PENDING)
- error_message
- created_at

#### nil_returns
- id (uuid, PK)
- organization_id (FK)
- user_id (FK)
- kra_pin
- obligation_id
- period (YYYYMM)
- status (PENDING, ACCEPTED, REJECTED)
- reference_number
- filed_at
- response (JSONB)
- created_at
- updated_at

#### compliance_checks
- id (uuid, PK)
- organization_id (FK)
- supplier_id (FK)
- check_type (PIN, TCC, BOTH)
- status (COMPLIANT, NON_COMPLIANT, UNKNOWN)
- issues (JSONB array)
- checked_at
- next_check_at
- created_at

#### notifications
- id (uuid, PK)
- organization_id (FK)
- user_id (FK, nullable)
- type (EMAIL, SMS, IN_APP)
- channel
- recipient
- subject
- message
- status (PENDING, SENT, FAILED)
- sent_at
- created_at

#### audit_logs
- id (uuid, PK)
- organization_id (FK)
- user_id (FK, nullable)
- action
- resource_type
- resource_id
- changes (JSONB)
- ip_address
- user_agent
- created_at

### Indexes
- users.email
- users.organization_id
- organizations.slug
- suppliers.organization_id
- suppliers.kra_pin
- verification_logs.organization_id, created_at
- compliance_checks.supplier_id, next_check_at

## API Design

### Authentication Endpoints

```
POST   /api/auth/register           # Register new organization
POST   /api/auth/login              # Login user
POST   /api/auth/logout             # Logout user
POST   /api/auth/refresh            # Refresh JWT token
POST   /api/auth/forgot-password    # Request password reset
POST   /api/auth/reset-password     # Reset password
GET    /api/auth/verify-email/:token# Verify email
```

### User Management

```
GET    /api/users                   # List users (org admin)
GET    /api/users/:id               # Get user details
PUT    /api/users/:id               # Update user
DELETE /api/users/:id               # Delete user
POST   /api/users                   # Invite new user
```

### Organization Management

```
GET    /api/organizations/me        # Get current org
PUT    /api/organizations/me        # Update org
GET    /api/organizations/settings  # Get settings
PUT    /api/organizations/settings  # Update settings
POST   /api/organizations/api-key/rotate # Rotate API key
```

### Verification

```
POST   /api/verify/pin              # Verify single PIN
POST   /api/verify/pins             # Verify multiple PINs
POST   /api/verify/tcc              # Verify single TCC
POST   /api/verify/tccs             # Verify multiple TCCs
GET    /api/verify/history          # Verification history
GET    /api/verify/stats            # Verification statistics
```

### Supplier Management

```
GET    /api/suppliers               # List suppliers
POST   /api/suppliers               # Create supplier
GET    /api/suppliers/:id           # Get supplier
PUT    /api/suppliers/:id           # Update supplier
DELETE /api/suppliers/:id           # Delete supplier
POST   /api/suppliers/import        # Bulk import (CSV)
GET    /api/suppliers/export        # Export (CSV)
POST   /api/suppliers/:id/verify    # Verify supplier compliance
GET    /api/suppliers/:id/history   # Supplier verification history
```

### NIL Returns

```
GET    /api/nil-returns             # List NIL returns
POST   /api/nil-returns             # File NIL return
GET    /api/nil-returns/:id         # Get NIL return details
GET    /api/nil-returns/pending     # Get pending returns
```

### Compliance

```
GET    /api/compliance/dashboard    # Compliance dashboard data
GET    /api/compliance/suppliers    # Suppliers compliance status
POST   /api/compliance/check        # Run compliance check
GET    /api/compliance/reports      # Generate reports
```

### Notifications

```
GET    /api/notifications           # List notifications
PUT    /api/notifications/:id/read  # Mark as read
DELETE /api/notifications/:id       # Delete notification
POST   /api/notifications/settings  # Update notification preferences
```

## Security

### Authentication Flow

1. User registers/logs in
2. Server generates JWT with:
   - user_id
   - organization_id
   - role
   - exp (24h)
3. Client stores JWT in httpOnly cookie
4. Refresh token stored in database (30 days)
5. Client sends JWT with each request
6. Server validates JWT middleware
7. Refresh flow when token expires

### Authorization

- **Role-Based Access Control (RBAC)**:
  - ADMIN: Full access to organization
  - USER: Can verify, manage suppliers, file returns
  - VIEWER: Read-only access

- **Organization Isolation**:
  - All queries filtered by organization_id
  - Row-level security in database

### Data Protection

- Passwords: bcrypt (12 rounds)
- API keys: AES-256 encryption
- PII: Encrypted at rest
- Audit logging: All critical operations
- Rate limiting: Per user/organization
- CORS: Strict origin policy
- CSRF protection: SameSite cookies

## Subscription Tiers

### FREE
- 50 verifications/month
- 10 suppliers
- Basic support
- Email notifications

### PRO ($49/month)
- 500 verifications/month
- 100 suppliers
- Priority support
- Email + SMS notifications
- Advanced analytics
- CSV import/export

### BUSINESS ($199/month)
- 5,000 verifications/month
- 1,000 suppliers
- Dedicated support
- All notifications
- Custom reports
- API access
- Webhook support

### ENTERPRISE (Custom)
- Unlimited verifications
- Unlimited suppliers
- 24/7 support
- White-label options
- On-premise deployment
- SLA guarantees
- Custom integrations

## Deployment

### Development
```bash
# Backend
cd apps/dashboard/backend
npm install
npm run dev

# Frontend
cd apps/dashboard/frontend
npm install
npm run dev

# Database
docker-compose up postgres redis
npx prisma migrate dev
npx prisma seed
```

### Production
```bash
# Docker Compose
docker-compose -f docker-compose.prod.yml up -d

# Or individual services
docker build -t kra-dashboard-backend ./backend
docker build -t kra-dashboard-frontend ./frontend
```

### Environment Variables

**Backend:**
```
NODE_ENV=production
PORT=4000
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
JWT_SECRET=...
JWT_EXPIRES_IN=24h
REFRESH_TOKEN_SECRET=...
REFRESH_TOKEN_EXPIRES_IN=30d
KRA_API_KEY=...
KRA_API_BASE_URL=...
SENDGRID_API_KEY=...
AFRICASTALKING_API_KEY=...
SENTRY_DSN=...
```

**Frontend:**
```
NEXT_PUBLIC_API_URL=http://localhost:4000/api
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## Monitoring & Observability

- **Error Tracking**: Sentry
- **Logging**: Winston (JSON format)
- **Metrics**: Prometheus + Grafana
- **Uptime**: UptimeRobot
- **APM**: New Relic / Datadog

## Roadmap

### Phase 1: MVP (Weeks 1-4)
- [x] Architecture & design
- [ ] Backend API setup
- [ ] Database schema & migrations
- [ ] Authentication system
- [ ] Frontend setup & layout
- [ ] PIN/TCC verification
- [ ] Basic supplier management
- [ ] Dashboard analytics

### Phase 2: Core Features (Weeks 5-8)
- [ ] NIL return filing
- [ ] Bulk operations
- [ ] Notification system
- [ ] Advanced supplier management
- [ ] Compliance scoring
- [ ] Report generation

### Phase 3: Advanced Features (Weeks 9-12)
- [ ] Webhook support
- [ ] API key management
- [ ] Custom integrations
- [ ] Mobile app
- [ ] Advanced analytics
- [ ] White-labeling

## Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
- [shadcn/ui Components](https://ui.shadcn.com)
- [Express Best Practices](https://expressjs.com/en/advanced/best-practice-security.html)
