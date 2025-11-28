# KRA-Connect Quick Start Guide

## 🚀 What Has Been Built

### ✅ Complete & Production-Ready

#### **Python SDK** (100% Complete)
The Python SDK is **fully functional and production-ready**. You can start using it immediately!

**Installation:**
```bash
cd packages/python-sdk
poetry install
```

**Usage:**
```python
from kra_connect import KraClient

client = KraClient(api_key='your-api-key')
result = client.verify_pin('P051234567A')
print(f"Valid: {result.is_valid}, Taxpayer: {result.taxpayer_name}")
```

**Features:**
- ✅ PIN verification
- ✅ TCC verification
- ✅ E-slip validation
- ✅ NIL return filing
- ✅ Taxpayer details
- ✅ Async support (AsyncKraClient)
- ✅ Caching & rate limiting
- ✅ Comprehensive error handling
- ✅ Full type hints with Pydantic

**Examples:** See [`packages/python-sdk/examples/`](./packages/python-sdk/examples/)

---

#### **Node.js SDK** (60% Complete)
Core infrastructure is ready. Needs cache, rate limiter, and main client.

**What's Ready:**
- ✅ TypeScript types & interfaces
- ✅ Exception classes
- ✅ Configuration management
- ✅ Input validators
- ✅ HTTP client with retry logic

**What's Needed:**
- ⏳ Cache manager
- ⏳ Rate limiter
- ⏳ Main KraClient class
- ⏳ Examples & tests

---

### 📁 Project Structure

```
kra-connect/
├── packages/
│   ├── python-sdk/          ✅ COMPLETE & READY
│   ├── node-sdk/            🚧 60% COMPLETE
│   ├── php-sdk/             ⏳ Not started
│   ├── go-sdk/              ⏳ Not started
│   └── flutter-sdk/         ⏳ Not started
├── apps/
│   ├── dashboard/           ⏳ Not started
│   ├── api-service/         ⏳ Not started
│   └── mobile/              ⏳ Not started
├── tools/
│   ├── cli/                 ⏳ Not started
│   ├── mock-server/         ⏳ Not started
│   └── test-utils/          ⏳ Not started
└── docs/                    ⏳ Not started
```

---

## 🎯 Next Steps (Priority Order)

### 1. Complete Node.js SDK (1-2 days)
```bash
cd packages/node-sdk
```

**Tasks:**
- [ ] Create `src/cache.ts` (copy logic from Python SDK)
- [ ] Create `src/rate-limiter.ts` (token bucket implementation)
- [ ] Create `src/client.ts` (main KraClient class)
- [ ] Create `src/index.ts` (exports)
- [ ] Add examples in `examples/`
- [ ] Write Jest tests
- [ ] Build: `npm run build`

### 2. Set Up CI/CD (4-6 hours)
```bash
mkdir -p .github/workflows
```

**Tasks:**
- [ ] Create `.github/workflows/python-sdk.yml`
- [ ] Create `.github/workflows/node-sdk.yml`
- [ ] Add lint, test, build steps
- [ ] Add npm/PyPI publishing workflow

### 3. PHP SDK (2-3 days)
```bash
cd packages/php-sdk
composer init
```

**Tasks:**
- [ ] Set up Composer project
- [ ] Create PSR-4 autoloading
- [ ] Implement core classes (mirror Python SDK structure)
- [ ] Laravel service provider
- [ ] PHPUnit tests

### 4. Flutter SDK (2-3 days)
```bash
cd packages/flutter-sdk
flutter create --template=package .
```

**Tasks:**
- [ ] Set up Flutter package
- [ ] Create Dart models
- [ ] Implement API client with dio
- [ ] Widget tests
- [ ] Example app

### 5. Go SDK (2-3 days)
```bash
cd packages/go-sdk
go mod init github.com/your-org/kra-connect/go-sdk
```

**Tasks:**
- [ ] Initialize Go module
- [ ] Create struct types
- [ ] Implement HTTP client
- [ ] Write tests with testify
- [ ] Generate GoDoc

### 6. CLI Tool (1-2 days)
```bash
cd tools/cli
```

**Tasks:**
- [ ] Choose implementation (Go/Node.js)
- [ ] Implement commands: verify-pin, check-tcc, etc.
- [ ] Add batch processing
- [ ] Create installers

---

## 📚 Documentation

- **[README.md](./README.md)** - Project overview
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** - Contribution guidelines
- **[AGENTS.md](./AGENTS.md)** - AI development guidelines (IMPORTANT!)
- **[IMPLEMENTATION_STATUS.md](./IMPLEMENTATION_STATUS.md)** - Detailed progress
- **[kra-connect.md](./kra-connect.md)** - Full project specification

---

## 🛠️ Development Commands

### Python SDK
```bash
cd packages/python-sdk

# Install dependencies
poetry install

# Run tests
poetry run pytest

# Format code
poetry run black src/ tests/
poetry run isort src/ tests/

# Type check
poetry run mypy src/

# Build
poetry build
```

### Node.js SDK
```bash
cd packages/node-sdk

# Install dependencies
npm install

# Build
npm run build

# Run tests
npm test

# Lint & format
npm run lint
npm run format
```

### Monorepo (Root)
```bash
# Install all dependencies
npm install

# Build all packages
npm run build

# Test all packages
npm test

# Format all code
npm run format
```

---

## 🔑 Environment Variables

Create a `.env` file in the project root:

```env
# KRA API Configuration
KRA_API_KEY=your_api_key_here
KRA_API_BASE_URL=https://api.kra.go.ke/gavaconnect/v1
KRA_TIMEOUT=30000

# Optional Configuration
KRA_MAX_RETRIES=3
KRA_CACHE_ENABLED=true
KRA_CACHE_TTL=3600
KRA_RATE_LIMIT_MAX_REQUESTS=100
KRA_RATE_LIMIT_WINDOW_SECONDS=60
```

---

## 🧪 Testing the Python SDK

### Quick Test
```bash
cd packages/python-sdk

# Create test script
cat > test_quick.py << 'EOF'
from kra_connect import KraClient

# Initialize client
client = KraClient(api_key='your-test-api-key')

# Test PIN verification
try:
    result = client.verify_pin('P051234567A')
    print(f"✓ PIN Verification works!")
    print(f"  Valid: {result.is_valid}")
    print(f"  Taxpayer: {result.taxpayer_name}")
except Exception as e:
    print(f"✗ Error: {e}")

client.close()
EOF

# Run test
poetry run python test_quick.py
```

### Run Example Scripts
```bash
# Basic PIN verification
poetry run python examples/basic_pin_verification.py

# Async batch processing
poetry run python examples/async_batch_processing.py
```

---

## 📦 Publishing SDKs

### Python SDK to PyPI
```bash
cd packages/python-sdk

# Build package
poetry build

# Publish to PyPI
poetry publish --username __token__ --password $PYPI_TOKEN
```

### Node.js SDK to npm
```bash
cd packages/node-sdk

# Build package
npm run build

# Publish to npm
npm publish --access public
```

---

## 🎓 Code Quality Standards

All code follows the guidelines in **[AGENTS.md](./AGENTS.md)**:

### Key Principles
1. ✅ **Documentation is non-negotiable** - Every function documented
2. ✅ **Descriptive naming** - No abbreviations
3. ✅ **Type safety** - Pydantic (Python), TypeScript (Node.js)
4. ✅ **Error handling** - Comprehensive exception classes
5. ✅ **Testing** - Aim for 90%+ coverage

### Example Documentation
```python
def verify_pin(pin_number: str) -> PinVerificationResult:
    """
    Verify a KRA PIN number.

    Args:
        pin_number: The PIN to verify (format: P + 9 digits + letter)

    Returns:
        PinVerificationResult with taxpayer details

    Raises:
        InvalidPinFormatError: If PIN format is invalid
        ApiAuthenticationError: If API key is invalid

    Example:
        >>> result = client.verify_pin('P051234567A')
        >>> print(result.taxpayer_name)
    """
```

---

## 🐛 Troubleshooting

### Python SDK Issues

**Issue: ModuleNotFoundError**
```bash
cd packages/python-sdk
poetry install
poetry shell
```

**Issue: Import errors**
```bash
# Ensure you're in the poetry environment
poetry shell
# Or prefix commands with poetry run
poetry run python your_script.py
```

### Node.js SDK Issues

**Issue: TypeScript errors**
```bash
cd packages/node-sdk
npm install
npm run typecheck
```

**Issue: Build fails**
```bash
npm run clean
npm run build
```

---

## 📞 Support & Resources

- **GitHub Issues**: [Report bugs or request features](https://github.com/your-org/kra-connect/issues)
- **Documentation**: Coming soon at https://docs.kra-connect.dev
- **Email**: developers@kra-connect.dev

---

## 🎉 Ready to Use

The **Python SDK is production-ready**! You can:
1. Install it: `cd packages/python-sdk && poetry install`
2. Use it in your projects
3. Run the examples
4. Build your own applications

For the Node.js SDK and others, follow the "Next Steps" section above to complete the implementation.

---

**Happy Coding! 🚀**
