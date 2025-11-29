# KRA Tax Compliance Dashboard

A full-stack SaaS application for managing KRA tax compliance, supplier verification, and automated NIL return filing.

## 🏗️ Project Status

**Status**: Foundation & Architecture Complete ✅
**Phase**: Ready for Implementation

## 📋 What's Been Done

✅ Complete architecture design ([ARCHITECTURE.md](./ARCHITECTURE.md))
✅ Tech stack selection
✅ Database schema design
✅ API endpoint design
✅ Security architecture
✅ Deployment strategy
✅ Backend project structure
✅ Package.json with all dependencies

## 🚀 Quick Start

### Prerequisites

- Node.js 20+
- PostgreSQL 15+
- Redis 7+
- Docker (optional)

### Development Setup

**1. Clone and Install**
```bash
# Backend
cd apps/dashboard/backend
npm install

# Frontend
cd apps/dashboard/frontend
npm install
```

**2. Environment Setup**
```bash
# Backend (.env)
cp .env.example .env
# Configure DATABASE_URL, JWT_SECRET, KRA_API_KEY, etc.

# Frontend (.env.local)
cp .env.example .env.local
# Configure NEXT_PUBLIC_API_URL
```

**3. Database**
```bash
cd backend
npx prisma migrate dev
npx prisma seed
```

**4. Run**
```bash
# Backend (port 4000)
cd backend
npm run dev

# Frontend (port 3000)
cd frontend
npm run dev
```

Visit: http://localhost:3000

## 📦 Project Structure

```
apps/dashboard/
├── ARCHITECTURE.md          # Complete architecture documentation
├── README.md                # This file
├── backend/                 # Express API server
│   ├── src/
│   │   ├── modules/         # Feature modules
│   │   ├── common/          # Shared code
│   │   ├── config/          # Configuration
│   │   ├── database/        # Prisma setup
│   │   └── main.ts          # Entry point
│   ├── prisma/
│   │   └── schema.prisma    # Database schema
│   ├── tests/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── package.json
├── frontend/                # Next.js application
│   ├── src/
│   │   ├── app/             # App Router pages
│   │   ├── components/      # React components
│   │   ├── lib/             # Utilities
│   │   └── store/           # State management
│   ├── public/
│   ├── tests/
│   └── package.json
└── docker-compose.yml       # Full stack orchestration
```

## 🎯 Features

### Completed Architecture For:

**Authentication & Authorization**
- JWT-based authentication
- Role-based access control (RBAC)
- Multi-tenant organization support
- Email verification
- Password reset flow

**Verification Services**
- PIN verification (single & batch)
- TCC verification (single & batch)
- Verification history & analytics
- Rate limiting per subscription tier

**Supplier Management**
- CRUD operations
- Bulk import/export (CSV)
- Compliance tracking
- Auto-verification scheduling
- Compliance scoring

**NIL Return Filing**
- Automated filing
- Status tracking
- Reference number management
- Filing history

**Compliance Dashboard**
- Real-time compliance status
- Supplier compliance overview
- Verification statistics
- Custom reports
- Export functionality

**Notifications**
- Email notifications
- SMS notifications (Africa's Talking)
- In-app notifications
- Configurable preferences

**Multi-tenancy**
- Organization isolation
- Subscription tiers (FREE, PRO, BUSINESS, ENTERPRISE)
- Usage quotas
- API key management

## 🔐 Security Features

- Password hashing (bcrypt)
- JWT authentication
- API key encryption (AES-256)
- Rate limiting
- CORS protection
- CSRF protection
- SQL injection prevention (Prisma)
- XSS protection (Helmet.js)
- Audit logging
- Row-level security

## 📊 Subscription Tiers

| Feature | FREE | PRO | BUSINESS | ENTERPRISE |
|---------|------|-----|----------|------------|
| Verifications/month | 50 | 500 | 5,000 | Unlimited |
| Suppliers | 10 | 100 | 1,000 | Unlimited |
| Support | Email | Priority | Dedicated | 24/7 |
| Notifications | Email | Email+SMS | All | All |
| Analytics | Basic | Advanced | Advanced | Custom |
| API Access | ❌ | ❌ | ✅ | ✅ |
| Webhooks | ❌ | ❌ | ✅ | ✅ |
| White-label | ❌ | ❌ | ❌ | ✅ |
| On-premise | ❌ | ❌ | ❌ | ✅ |
| **Price** | Free | $49/mo | $199/mo | Custom |

## 🛠️ Tech Stack

### Backend
- **Runtime**: Node.js 20+ with TypeScript
- **Framework**: Express.js
- **Database**: PostgreSQL + Prisma ORM
- **Cache**: Redis
- **Authentication**: JWT + bcrypt
- **Validation**: Zod
- **Testing**: Jest + Supertest

### Frontend
- **Framework**: Next.js 14 (App Router)
- **UI**: shadcn/ui + Radix UI + Tailwind CSS
- **State**: Zustand
- **Forms**: React Hook Form + Zod
- **Data Fetching**: TanStack Query
- **Charts**: Recharts
- **Testing**: Jest + React Testing Library

### DevOps
- **Containerization**: Docker + Docker Compose
- **CI/CD**: GitHub Actions
- **Monitoring**: Sentry
- **Email**: SendGrid
- **SMS**: Africa's Talking

## 📚 API Documentation

Complete API documentation available at `/api/docs` when running in development.

### Key Endpoints

**Authentication**
- `POST /api/auth/register` - Register organization
- `POST /api/auth/login` - Login user
- `POST /api/auth/refresh` - Refresh token

**Verification**
- `POST /api/verify/pin` - Verify PIN
- `POST /api/verify/pins` - Batch verify PINs
- `POST /api/verify/tcc` - Verify TCC
- `GET /api/verify/history` - Verification history

**Suppliers**
- `GET /api/suppliers` - List suppliers
- `POST /api/suppliers` - Create supplier
- `PUT /api/suppliers/:id` - Update supplier
- `POST /api/suppliers/import` - Bulk import
- `POST /api/suppliers/:id/verify` - Verify supplier

**NIL Returns**
- `POST /api/nil-returns` - File NIL return
- `GET /api/nil-returns` - List returns
- `GET /api/nil-returns/:id` - Get return details

**Compliance**
- `GET /api/compliance/dashboard` - Dashboard data
- `GET /api/compliance/suppliers` - Supplier compliance
- `POST /api/compliance/reports` - Generate report

## 🧪 Testing

```bash
# Backend tests
cd backend
npm test
npm run test:cov

# Frontend tests
cd frontend
npm test
npm run test:e2e
```

## 🚢 Deployment

### Docker Compose (Recommended)

```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Manual Deployment

**Backend**
```bash
cd backend
npm run build
npm start
```

**Frontend**
```bash
cd frontend
npm run build
npm start
```

### Environment Variables

See [ARCHITECTURE.md](./ARCHITECTURE.md#environment-variables) for complete list.

## 📈 Development Roadmap

### Phase 1: MVP (Weeks 1-4)
- [ ] Backend API implementation
- [ ] Database migrations
- [ ] Authentication system
- [ ] Frontend layout & routing
- [ ] PIN/TCC verification UI
- [ ] Basic supplier management
- [ ] Dashboard analytics

### Phase 2: Core Features (Weeks 5-8)
- [ ] NIL return filing
- [ ] Bulk operations (CSV)
- [ ] Notification system
- [ ] Advanced supplier features
- [ ] Compliance scoring
- [ ] Report generation
- [ ] Subscription management

### Phase 3: Advanced Features (Weeks 9-12)
- [ ] Webhook support
- [ ] Public API
- [ ] Mobile app
- [ ] Advanced analytics
- [ ] White-labeling options
- [ ] Integration marketplace

## 🤝 Contributing

1. Follow the architecture in `ARCHITECTURE.md`
2. Use TypeScript for type safety
3. Write tests for new features
4. Follow ESLint rules
5. Update documentation

## 📄 License

MIT License - see [LICENSE](../../LICENSE)

## 💬 Support

- **Documentation**: See [ARCHITECTURE.md](./ARCHITECTURE.md)
- **Issues**: [GitHub Issues](https://github.com/kra-connect/kra-connect/issues)
- **Email**: support@kra-connect.dev

## 🔗 Related Projects

- [KRA Node.js SDK](../../packages/kra-connect-node-sdk)
- [KRA Mock Server](../../packages/kra-mock-server)
- [API Collections](../../tools/api-collections)
- [Testing Utilities](../../packages/kra-test-utils)

---

**Built with ❤️ for Kenyan businesses**

For detailed implementation guide, see [ARCHITECTURE.md](./ARCHITECTURE.md)
