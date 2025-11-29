# KRA-Connect

> Production-ready SDKs and tools for integrating with Kenya Revenue Authority's GavaConnect APIs

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

## 🎯 Overview

KRA-Connect is a comprehensive ecosystem that provides Kenyan businesses and developers with production-ready tools to integrate with Kenya Revenue Authority's APIs for tax compliance, verification, and automation.

## 📦 Packages

Each SDK is maintained in its own repository for easier maintenance and distribution:

### SDKs
- **[kra-connect-python-sdk](https://github.com/BerjisTech/kra-connect-python-sdk)** - Python SDK
  ```bash
  pip install kra-connect
  ```

- **[kra-connect-node-sdk](https://github.com/BerjisTech/kra-connect-node-sdk)** - TypeScript/Node.js SDK
  ```bash
  npm install @kra-connect/node
  ```

- **[kra-connect-php-sdk](https://github.com/BerjisTech/kra-connect-php-sdk)** - PHP SDK
  ```bash
  composer require kra-connect/php-sdk
  ```

- **[kra-connect-go-sdk](https://github.com/BerjisTech/kra-connect-go-sdk)** - Go SDK
  ```bash
  go get github.com/BerjisTech/kra-connect-go-sdk
  ```

- **[kra-connect-flutter-sdk](https://github.com/BerjisTech/kra-connect-flutter-sdk)** - Flutter/Dart SDK
  ```bash
  flutter pub add kra_connect
  ```

### Developer Tools
- **[kra-cli](https://github.com/BerjisTech/kra-cli)** - Command-line interface for KRA operations
  ```bash
  go install github.com/BerjisTech/kra-cli@latest
  ```

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

This repository contains project documentation and planning. Each SDK is developed in its own repository:

### Contributing to SDKs

Clone the specific SDK repository you want to contribute to:

```bash
# Python SDK
git clone git@github.com:BerjisTech/kra-connect-python-sdk.git

# Node.js SDK
git clone git@github.com:BerjisTech/kra-connect-node-sdk.git

# PHP SDK
git clone git@github.com:BerjisTech/kra-connect-php-sdk.git

# Go SDK
git clone git@github.com:BerjisTech/kra-connect-go-sdk.git

# Flutter SDK
git clone git@github.com:BerjisTech/kra-connect-flutter-sdk.git

# CLI Tool
git clone git@github.com:BerjisTech/kra-cli.git
```

Each repository has its own development setup, testing, and contribution guidelines.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Guidelines
- Follow the [AI Assistant Guidelines](CLAUDE.md) for code quality
- Write comprehensive tests (90%+ coverage)
- Document all public APIs
- Follow language-specific conventions
- Keep PRs focused and small

## 📋 Project Status

### Completed Components
- ✅ **Python SDK** - Production ready
- ✅ **Node.js SDK** - Production ready
- ✅ **PHP SDK** - Production ready (Laravel & Symfony support)
- ✅ **Go SDK** - Production ready
- ✅ **Flutter SDK** - Production ready
- ✅ **CLI Tool** - Core features complete

### Next Phase
- ⏳ Documentation website
- ⏳ Mock API server for testing
- ⏳ Business applications (Dashboard, Mobile App)

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
