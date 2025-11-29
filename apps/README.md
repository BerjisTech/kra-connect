# KRA-Connect Business Applications

This directory contains deployable business applications built on top of the KRA-Connect SDKs.

## Purpose

While the KRA-Connect SDKs (in separate repositories) provide developer libraries, this directory contains **end-user applications** that businesses can deploy and use directly.

## Current Applications

### 1. Dashboard (`dashboard/`)
A full-stack SaaS web application for managing KRA tax compliance:
- Multi-tenant organization support
- PIN/TCC verification (single & batch)
- Supplier management with compliance tracking
- Automated NIL return filing
- Real-time compliance dashboard
- Subscription-based pricing tiers

**Tech Stack:**
- Backend: Node.js + Express + TypeScript + Prisma + PostgreSQL
- Frontend: Next.js 14 + shadcn/ui + Tailwind CSS
- See [dashboard/ARCHITECTURE.md](./dashboard/ARCHITECTURE.md) for details

**Status:** ✅ Architecture complete, ready for implementation

## Planned Applications

### 2. API Service (`api-service/`)
**Status:** 🚧 Not started - folder placeholder

A standalone API gateway service that provides:
- REST API endpoints for web/mobile apps
- GraphQL API for flexible querying
- WebSocket support for real-time updates
- API key management and rate limiting
- Multi-tenant request routing

**Planned Tech Stack:**
- Node.js + NestJS OR Go + Fiber
- PostgreSQL + Redis
- API documentation with Swagger/OpenAPI

### 3. Mobile App (`mobile/`)
**Status:** 🚧 Not started - folder placeholder

Cross-platform mobile application for on-the-go KRA compliance:
- PIN verification with QR code scanning
- Supplier compliance checking
- Push notifications for expiring TCCs
- Offline mode with sync
- Biometric authentication

**Planned Tech Stack:**
- Flutter (iOS + Android)
- SQLite for offline storage
- Firebase for push notifications

## Repository Structure

```
apps/
├── README.md              # This file
├── dashboard/             # Web dashboard (in development)
│   ├── backend/          # Express API server
│   ├── frontend/         # Next.js application
│   ├── ARCHITECTURE.md   # Complete architecture doc
│   └── README.md         # Dashboard-specific docs
├── api-service/          # Future: API gateway service
└── mobile/               # Future: Mobile application
```

## Development Guidelines

### Adding New Applications

When adding a new application to this directory:

1. **Create a dedicated folder** with a descriptive name
2. **Add a README.md** explaining:
   - Purpose and features
   - Tech stack
   - Setup instructions
   - Deployment guide
3. **Include architecture documentation** for complex applications
4. **Set up CI/CD** in the application's folder
5. **Add to this README** with status and description

### Application vs SDK

**Applications (apps/):**
- Deployable end-user software
- Have their own databases and infrastructure
- Use KRA-Connect SDKs as dependencies
- Examples: Web dashboard, mobile app, admin portal

**SDKs (separate repositories):**
- Developer libraries/packages
- No UI or deployment infrastructure
- Published to package managers (npm, pip, composer, etc.)
- Examples: @kra-connect/node, kra-connect (Python)

### Integration with SDKs

All applications in this directory should:
- Import and use the published KRA-Connect SDKs
- NOT duplicate SDK functionality
- Contribute bug reports/feature requests back to SDK repositories
- Follow SDK best practices and patterns

Example:
```typescript
// In dashboard/backend/src/services/verification.service.ts
import { KraClient } from '@kra-connect/node'; // Use the published SDK

export class VerificationService {
  private kraClient: KraClient;

  constructor() {
    this.kraClient = new KraClient({
      apiKey: process.env.KRA_API_KEY
    });
  }

  async verifyPin(pin: string) {
    return await this.kraClient.verifyPin(pin);
  }
}
```

## Deployment

Each application has its own deployment requirements:

- **Dashboard**: Docker Compose or Kubernetes, see [dashboard/README.md](./dashboard/README.md)
- **API Service**: TBD
- **Mobile**: App Store + Google Play Store

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for general guidelines.

For application-specific contributions, see the README in each application folder.

## Support

- **Documentation**: [https://docs.kra-connect.dev](https://docs.kra-connect.dev)
- **Issues**: [GitHub Issues](https://github.com/BerjisTech/kra-connect/issues)
- **Email**: support@kra-connect.dev

---

**Note:** The `api-service/` and `mobile/` folders are placeholders for future development. They are empty but retained to document the planned application roadmap.
