# KRA-Connect Packages Directory

## Purpose

This directory contains **development tools** for the KRA-Connect ecosystem.

**IMPORTANT:** The SDKs (Python, Node.js, PHP, Go, Flutter, CLI) are NOT stored in this repository. They are maintained in separate GitHub repositories.

## Repository Structure

### Production SDK Repositories (Published Packages)

Each SDK is maintained and published from its own repository:

1. **[kra-connect-python-sdk](https://github.com/BerjisTech/kra-connect-python-sdk)**
   - Published to PyPI as `kra-connect`
   - `pip install kra-connect`

2. **[kra-connect-node-sdk](https://github.com/BerjisTech/kra-connect-node-sdk)**
   - Published to npm as `@kra-connect/node`
   - `npm install @kra-connect/node`

3. **[kra-connect-php-sdk](https://github.com/BerjisTech/kra-connect-php-sdk)**
   - Published to Packagist as `kra-connect/php-sdk`
   - `composer require kra-connect/php-sdk`

4. **[kra-connect-go-sdk](https://github.com/BerjisTech/kra-connect-go-sdk)**
   - Available via Go modules
   - `go get github.com/BerjisTech/kra-connect-go-sdk`

5. **[kra-connect-flutter-sdk](https://github.com/BerjisTech/kra-connect-flutter-sdk)**
   - Published to pub.dev as `kra_connect`
   - `flutter pub add kra_connect`

6. **[kra-cli](https://github.com/BerjisTech/kra-cli)**
   - CLI tool published via Go install
   - `go install github.com/BerjisTech/kra-cli@latest`

### Contents of This Directory

```
packages/
├── README.md            # This file - documentation about packages
├── kra-mock-server/     # Mock API server for testing (KEPT IN MAIN REPO)
└── kra-test-utils/      # Test data generators (KEPT IN MAIN REPO)
```

**Note:** SDK folders are NOT tracked in this repository. They exist only in their separate repositories listed above.

## Development Tools in This Repository

### kra-mock-server
A Go-based mock API server that simulates KRA GavaConnect APIs:
- Used for testing SDKs without real API calls
- Configurable delays and error rates
- All 10 KRA API endpoints implemented
- Docker support for easy deployment
- See [kra-mock-server/README.md](./kra-mock-server/README.md)

**Location:** Lives in this repository (`packages/kra-mock-server/`)

### kra-test-utils
TypeScript utilities for generating test data:
- Valid PIN/TCC number generators
- Mock API response generators
- Test fixtures for all SDKs
- Deterministic data generation with seeds
- See [kra-test-utils/README.md](./kra-test-utils/README.md)

**Location:** Lives in this repository (`packages/kra-test-utils/`)

## Working with SDKs

### To Contribute to an SDK

All SDK work happens in their respective repositories:

```bash
# Clone the specific SDK repository
git clone git@github.com:BerjisTech/kra-connect-node-sdk.git
cd kra-connect-node-sdk

# Make changes, test, commit, push
npm install
npm test
git commit -m "feat: add new feature"
git push
```

### Testing with Development Tools

Use the mock server and test utilities from this repository:

```bash
# Start mock server
cd packages/kra-mock-server
go run main.go handlers.go --port 8080

# In your SDK repository, point to mock server
export KRA_API_BASE_URL=http://localhost:8080
npm test  # or python -m pytest, etc.
```

## Development Tools in This Directory

### kra-mock-server
A Go-based mock API server that simulates KRA GavaConnect APIs:
- Used for testing SDKs without real API calls
- Configurable delays and error rates
- See [kra-mock-server/README.md](./kra-mock-server/README.md)

### kra-test-utils
TypeScript utilities for generating test data:
- Valid PIN/TCC number generators
- Mock API response generators
- Test fixtures for all SDKs
- See [kra-test-utils/README.md](./kra-test-utils/README.md)

**Note:** These tools are NOT SDKs and live ONLY in this repository.

## Contributing

### To Contribute to an SDK

**SDK contributions go to their respective repositories, NOT this one:**

1. Clone the specific SDK repository (see links at top of this file)
2. Make changes in that repository
3. Create PR to that SDK repository

### To Contribute to Development Tools

For `kra-mock-server` or `kra-test-utils` in this repository:

1. Fork this repository
2. Make changes to the tool
3. Test locally
4. Create PR to this repository

## CI/CD

Each SDK repository has its own CI/CD pipeline:
- Python SDK: Publishes to PyPI
- Node.js SDK: Publishes to npm
- PHP SDK: Publishes to Packagist
- Go SDK: Tagged releases
- Flutter SDK: Publishes to pub.dev

This repository's CI/CD:
- Does NOT publish SDKs
- Builds and tests development tools only
- Generates unified documentation

## Why Separate Repositories?

**Benefits of Multi-Repo Architecture:**

1. **Independent Versioning**: Each SDK can version independently
2. **Focused PRs**: Contributors work on one language at a time
3. **Smaller Repositories**: Faster clones, focused history
4. **Language-Specific Workflows**: Python SDK uses Python tools, Node SDK uses Node tools
5. **Package Manager Integration**: Each repo publishes to its respective package manager
6. **Clear Ownership**: Teams can own specific SDK repositories

**This Repository's Role:**
- Central documentation
- Project planning and coordination
- Development tools (mock server, test utilities)
- Business applications (in `apps/` folder)

## FAQ

**Q: Where are the SDK folders?**
A: They are NOT in this repository. Each SDK lives in its own GitHub repository (see links at top).

**Q: What's in the `packages/` folder then?**
A: Only development tools: `kra-mock-server` and `kra-test-utils`. Plus this README.

**Q: Can I clone SDK code into `packages/` for local testing?**
A: Yes, but `.gitignore` prevents them from being committed. They're for local use only.

**Q: How do I publish an SDK?**
A: Each SDK repository has its own publishing workflow. See that repo's README.

**Q: Can I use code from `packages/` in production?**
A: Use published packages only: `npm install @kra-connect/node`, `pip install kra-connect`, etc.

---

**For SDK-specific questions, see the README in each SDK's repository.**
