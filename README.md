# KRA-Connect

> Production-ready SDKs and tools for integrating with Kenya Revenue Authority's GavaConnect APIs

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

## 🎯 Overview

KRA-Connect is a comprehensive ecosystem that provides Kenyan businesses and developers with production-ready tools to integrate with Kenya Revenue Authority's APIs for tax compliance, verification, and automation.

## 📦 Packages

### SDKs
- **[@kra-connect/node](./packages/node-sdk)** - TypeScript/Node.js SDK
- **[kra-python](./packages/python-sdk)** - Python SDK
- **[kra-connect-php](./packages/php-sdk)** - PHP SDK
- **[go-kra-connect](./packages/go-sdk)** - Go SDK
- **[kra_connect](./packages/flutter-sdk)** - Flutter/Dart SDK

### Developer Tools
- **[kra-cli](./tools/cli)** - Command-line interface for KRA operations
- **[kra-mock-server](./tools/mock-server)** - Mock GavaConnect API server for testing
- **[kra-test-utils](./tools/test-utils)** - Testing utilities and fixtures

### Business Applications
- **[Dashboard](./apps/dashboard)** - Tax compliance dashboard (Angular)
- **[API Service](./apps/api-service)** - Supplier verification API service
- **[Mobile App](./apps/mobile)** - Flutter mobile application

## 🚀 Quick Start

### Node.js/TypeScript
```bash
npm install @kra-connect/node
```

```typescript
import { KraClient } from '@kra-connect/node';

const client = new KraClient({ apiKey: process.env.KRA_API_KEY });

// Verify a PIN
const result = await client.verifyPin('P051234567A');
console.log(result.taxpayerName);
```

### Python
```bash
pip install kra-connect
```

```python
from kra_connect import KraClient

client = KraClient(api_key=os.getenv('KRA_API_KEY'))

# Verify a PIN
result = client.verify_pin('P051234567A')
print(result.taxpayer_name)
```

## 🔑 Features

- ✅ **Multiple SDKs** - Support for Python, Node.js, PHP, Go, and Flutter
- ✅ **Type Safety** - Full TypeScript definitions and type hints
- ✅ **Authentication** - Secure API key management
- ✅ **Error Handling** - Comprehensive error types and messages
- ✅ **Rate Limiting** - Built-in rate limiting with configurable policies
- ✅ **Caching** - Response caching for improved performance
- ✅ **Retry Logic** - Automatic retry with exponential backoff
- ✅ **Testing Tools** - Mock server and test utilities
- ✅ **CLI Tools** - Command-line interface for common operations
- ✅ **Business Apps** - Ready-to-deploy dashboard and mobile apps

## 📚 Documentation

- [Getting Started Guide](./docs/getting-started.md)
- [API Reference](./docs/api-reference.md)
- [Authentication](./docs/authentication.md)
- [Error Handling](./docs/error-handling.md)
- [Best Practices](./docs/best-practices.md)
- [Examples](./docs/examples)

## 🛠️ Development

### Prerequisites
- Node.js 18+
- Python 3.9+
- PHP 8.1+
- Go 1.21+
- Flutter 3.0+
- Docker & Docker Compose

### Setup
```bash
# Clone the repository
git clone https://github.com/your-org/kra-connect.git
cd kra-connect

# Install dependencies for all packages
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your API credentials

# Run tests
npm test

# Start development environment
docker-compose up -d
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Guidelines
- Follow the [AI Assistant Guidelines](CLAUDE.md) for code quality
- Write comprehensive tests (90%+ coverage)
- Document all public APIs
- Follow language-specific conventions
- Keep PRs focused and small

## 📋 Project Status

This project is currently in active development. See our [Project Board](https://github.com/your-org/kra-connect/projects/1) for current status and [Roadmap](./ROADMAP.md) for planned features.

### Current Phase
**Phase 2: Core SDK Development** (Weeks 3-6)
- ✅ Project infrastructure setup
- 🚧 Python SDK development
- 🚧 Node.js SDK development
- ⏳ PHP SDK development
- ⏳ Go SDK development
- ⏳ Flutter SDK development

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Kenya Revenue Authority for providing the GavaConnect API
- All contributors who help improve this project

## 📞 Support

- **Documentation**: [https://docs.kra-connect.dev](https://docs.kra-connect.dev)
- **Issues**: [GitHub Issues](https://github.com/your-org/kra-connect/issues)
- **Discord**: [Join our community](https://discord.gg/kra-connect)
- **Email**: support@kra-connect.dev

## ⚖️ Disclaimer

This is an independent project and is not officially affiliated with or endorsed by the Kenya Revenue Authority.

---

**Made with ❤️ for the Kenyan developer community**
