# KRA-Connect Repository Structure

## Overview

**This repository is the DOCUMENTATION AND PLANNING HUB for the KRA-Connect ecosystem.**

The actual SDKs are maintained in separate GitHub repositories.

## What's in THIS Repository

```
kra-connect/                          # THIS REPOSITORY (documentation & planning)
├── README.md                         # Main project README
├── REPOSITORY_STRUCTURE.md          # This file
├── CLAUDE.md                         # AI development guidelines
├── STATUS.md                         # Project status
├── kra-connect.md                    # Complete project roadmap
├── PUBLISHING_GUIDE.md               # SDK publishing instructions
├── USER_GUIDE.md                     # SDK usage guide
├── CONTRIBUTING.md                   # Contribution guidelines
│
├── docs/                             # Project documentation
│   ├── getting-started.md
│   ├── api-reference.md
│   ├── authentication.md
│   └── ...
│
├── packages/                         # Development tools ONLY
│   ├── README.md                    # About packages (IMPORTANT!)
│   ├── kra-mock-server/             # Mock API server (Go)
│   ├── kra-test-utils/              # Test data generators (TypeScript)
│   └── .gitignore excludes:         # SDK folders NOT tracked here
│       ├── kra-connect-python-sdk/  # (Exists in separate repo)
│       ├── kra-connect-node-sdk/    # (Exists in separate repo)
│       ├── kra-connect-php-sdk/     # (Exists in separate repo)
│       ├── kra-connect-go-sdk/      # (Exists in separate repo)
│       ├── kra-connect-flutter-sdk/ # (Exists in separate repo)
│       └── kra-cli/                 # (Exists in separate repo)
│
├── apps/                             # Business applications
│   ├── README.md                    # About apps (IMPORTANT!)
│   ├── dashboard/                   # SaaS dashboard (Next.js + Express)
│   │   ├── ARCHITECTURE.md
│   │   ├── README.md
│   │   ├── backend/
│   │   └── frontend/
│   ├── api-service/                 # (Placeholder - future)
│   └── mobile/                      # (Placeholder - future)
│
├── tools/                            # Testing tools
│   ├── README.md                    # About tools
│   └── api-collections/             # Postman/Insomnia collections
│       ├── KRA-GavaConnect.postman_collection.json
│       ├── KRA-GavaConnect.insomnia.json
│       ├── Development.postman_environment.json
│       ├── Production.postman_environment.json
│       └── README.md
│
└── .github/
    └── workflows/                    # CI/CD for THIS repo only
```

## What's in SEPARATE Repositories

Each SDK is maintained independently:

### 1. Python SDK
- **Repository:** [BerjisTech/kra-connect-python-sdk](https://github.com/BerjisTech/kra-connect-python-sdk)
- **Package:** `pip install kra-connect`
- **Registry:** PyPI

### 2. Node.js SDK
- **Repository:** [BerjisTech/kra-connect-node-sdk](https://github.com/BerjisTech/kra-connect-node-sdk)
- **Package:** `npm install @kra-connect/node`
- **Registry:** npm

### 3. PHP SDK
- **Repository:** [BerjisTech/kra-connect-php-sdk](https://github.com/BerjisTech/kra-connect-php-sdk)
- **Package:** `composer require kra-connect/php-sdk`
- **Registry:** Packagist

### 4. Go SDK
- **Repository:** [BerjisTech/kra-connect-go-sdk](https://github.com/BerjisTech/kra-connect-go-sdk)
- **Package:** `go get github.com/BerjisTech/kra-connect-go-sdk`
- **Registry:** pkg.go.dev

### 5. Flutter SDK
- **Repository:** [BerjisTech/kra-connect-flutter-sdk](https://github.com/BerjisTech/kra-connect-flutter-sdk)
- **Package:** `flutter pub add kra_connect`
- **Registry:** pub.dev

### 6. CLI Tool
- **Repository:** [BerjisTech/kra-cli](https://github.com/BerjisTech/kra-cli)
- **Install:** `go install github.com/BerjisTech/kra-cli@latest`

## Why This Structure?

### Multi-Repository Benefits

**For SDKs:**
- ✅ Independent versioning per language
- ✅ Focused PRs and issues per SDK
- ✅ Language-specific CI/CD workflows
- ✅ Faster clones (no multi-GB monorepo)
- ✅ Clear ownership by language maintainers
- ✅ Direct publishing to package registries

**For This Repository:**
- 📚 Central documentation hub
- 📋 Cross-SDK project planning
- 🔧 Shared development tools
- 🏢 Business applications
- 🎯 Unified issue tracking for architecture decisions

## Git Ignore Strategy

The [.gitignore](./.gitignore) file excludes SDK folders:

```gitignore
# Exclude SDK directories (managed in separate repos)
packages/kra-connect-python-sdk/
packages/kra-connect-node-sdk/
packages/kra-connect-php-sdk/
packages/kra-connect-go-sdk/
packages/kra-connect-flutter-sdk/
packages/kra-cli/
```

**This means:**
- SDK folders can be cloned locally into `packages/` for development
- Git will NOT track changes in those folders
- They won't be committed to this repository
- Keeps this repo focused on docs and tools

## Development Workflow

### Working on SDKs

```bash
# Clone the SDK repository you want to work on
git clone git@github.com:BerjisTech/kra-connect-node-sdk.git
cd kra-connect-node-sdk

# Make changes, test, commit, push
npm install
npm test
git commit -m "feat: add feature"
git push
```

### Working on Documentation

```bash
# Clone this repository
git clone git@github.com:BerjisTech/kra-connect.git
cd kra-connect

# Update docs
vim docs/api-reference.md

# Commit and push
git add docs/
git commit -m "docs: update API reference"
git push
```

### Working on Development Tools

```bash
# Clone this repository
git clone git@github.com:BerjisTech/kra-connect.git
cd kra-connect

# Work on mock server
cd packages/kra-mock-server
# ... make changes ...

# Commit and push
git add packages/kra-mock-server/
git commit -m "feat(mock-server): add new endpoint"
git push
```

### Working on Business Applications

```bash
# Clone this repository
git clone git@github.com:BerjisTech/kra-connect.git
cd kra-connect

# Work on dashboard
cd apps/dashboard/backend
# ... make changes ...

# Commit and push
git add apps/dashboard/
git commit -m "feat(dashboard): add compliance scoring"
git push
```

## Local Testing Setup

You can clone SDKs locally for testing alongside the tools:

```bash
# Clone this repo
git clone git@github.com:BerjisTech/kra-connect.git
cd kra-connect

# Clone SDKs into packages/ (optional, for local testing)
cd packages/
git clone git@github.com:BerjisTech/kra-connect-node-sdk.git
git clone git@github.com:BerjisTech/kra-connect-python-sdk.git
# etc...

# Start mock server
cd kra-mock-server
go run main.go handlers.go --port 8080

# Test SDK against mock server
cd ../kra-connect-node-sdk
export KRA_API_BASE_URL=http://localhost:8080
npm test
```

**Note:** Changes in the locally cloned SDKs won't be tracked by this repo's git.

## Publishing Workflow

### SDK Publishing
Each SDK repository has its own publishing workflow:

```bash
# In SDK repository
git tag v0.1.0
git push --tags
# CI/CD automatically publishes to npm/PyPI/etc.
```

### Documentation Publishing
This repository's documentation:

```bash
# In this repository
# Update docs, commit, push
# Deploy to docs.kra-connect.dev via CI/CD
```

## Contributing

### To an SDK
1. Clone the SDK's repository (see links above)
2. Make changes there
3. Create PR to that SDK repository

### To Documentation
1. Clone this repository
2. Update docs in this repo
3. Create PR to this repository

### To Development Tools
1. Clone this repository
2. Update tools in `packages/` or `tools/`
3. Create PR to this repository

### To Business Applications
1. Clone this repository
2. Update apps in `apps/`
3. Create PR to this repository

## Quick Reference

| What | Where |
|------|-------|
| **Python SDK code** | [kra-connect-python-sdk repo](https://github.com/BerjisTech/kra-connect-python-sdk) |
| **Node.js SDK code** | [kra-connect-node-sdk repo](https://github.com/BerjisTech/kra-connect-node-sdk) |
| **PHP SDK code** | [kra-connect-php-sdk repo](https://github.com/BerjisTech/kra-connect-php-sdk) |
| **Go SDK code** | [kra-connect-go-sdk repo](https://github.com/BerjisTech/kra-connect-go-sdk) |
| **Flutter SDK code** | [kra-connect-flutter-sdk repo](https://github.com/BerjisTech/kra-connect-flutter-sdk) |
| **CLI tool code** | [kra-cli repo](https://github.com/BerjisTech/kra-cli) |
| **Documentation** | THIS repository |
| **Mock server** | THIS repository (`packages/kra-mock-server/`) |
| **Test utilities** | THIS repository (`packages/kra-test-utils/`) |
| **API collections** | THIS repository (`tools/api-collections/`) |
| **Dashboard app** | THIS repository (`apps/dashboard/`) |
| **Project planning** | THIS repository (`kra-connect.md`, `STATUS.md`) |

## FAQ

**Q: Where do I report an SDK bug?**
A: In that SDK's repository issue tracker.

**Q: Where do I request a new SDK feature?**
A: In that SDK's repository issue tracker.

**Q: Where do I report a documentation issue?**
A: In this repository's issue tracker.

**Q: Where do I request a new development tool?**
A: In this repository's issue tracker.

**Q: Can I work on multiple SDKs at once?**
A: Yes, clone each SDK repository separately. They're independent.

**Q: Why can't I see SDK folders in this repo?**
A: Because they live in separate repositories. This is intentional.

**Q: Can I clone SDK repos into `packages/` for testing?**
A: Yes! `.gitignore` prevents them from being committed. This is for local development only.

**Q: Do I need to clone all SDK repos to contribute?**
A: No, only clone the SDK you want to work on.

---

**For more details, see:**
- [packages/README.md](./packages/README.md) - Detailed explanation of packages directory
- [apps/README.md](./apps/README.md) - Detailed explanation of apps directory
- [tools/README.md](./tools/README.md) - Detailed explanation of tools directory
- [README.md](./README.md) - Main project README
