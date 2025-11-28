# CI/CD Guide for KRA-Connect

## Overview

This guide explains the Continuous Integration and Continuous Deployment (CI/CD) pipeline for the KRA-Connect project.

---

## 📋 Table of Contents

- [Workflows](#workflows)
- [Required Secrets](#required-secrets)
- [Branch Strategy](#branch-strategy)
- [Publishing Process](#publishing-process)
- [Troubleshooting](#troubleshooting)

---

## 🔄 Workflows

### 1. CI Workflow (`ci.yml`)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`

**Jobs:**
- **changes**: Detects which packages have changed
- **lint**: Code formatting and linting checks
- **test-python-sdk**: Python SDK tests (Python 3.9-3.12)
- **test-node-sdk**: Node.js SDK tests (Node 18, 20, 21)
- **test-php-sdk**: PHP SDK tests (PHP 8.1, 8.2, 8.3)
- **test-go-sdk**: Go SDK tests (Go 1.21, 1.22)
- **test-flutter-sdk**: Flutter SDK tests
- **build-status**: Overall build status check

**Features:**
- Smart change detection (only tests changed packages)
- Multi-version testing
- Code coverage upload to Codecov
- Parallel job execution

### 2. Code Quality Workflow (`code-quality.yml`)

**Triggers:**
- Push to `main` or `develop`
- Pull requests

**Checks:**
- Prettier formatting
- ESLint (Node.js)
- Black & isort (Python)
- mypy type checking (Python)
- pylint (Python)
- TypeScript type checking
- Security scanning (Trivy)
- npm audit
- Documentation validation
- License verification
- Commit message linting

### 3. Publish Workflow (`publish.yml`)

**Triggers:**
- GitHub releases
- Manual workflow dispatch

**Jobs:**
- **publish-python-sdk**: Publishes to PyPI
- **publish-node-sdk**: Publishes to npm
- **publish-php-sdk**: Triggers Packagist update
- **publish-go-sdk**: Creates Git tags for Go module
- **publish-flutter-sdk**: Publishes to pub.dev

---

## 🔐 Required Secrets

Configure these secrets in your GitHub repository settings:

### Python SDK (PyPI)

1. Go to [https://pypi.org/manage/account/](https://pypi.org/manage/account/)
2. Generate an API token
3. Add to GitHub Secrets:
   - `PYPI_TOKEN`: Production PyPI token
   - `TEST_PYPI_TOKEN`: Test PyPI token (optional)

### Node.js SDK (npm)

1. Go to [https://www.npmjs.com/settings/~/tokens](https://www.npmjs.com/settings/~/tokens)
2. Generate an automation token
3. Add to GitHub Secrets:
   - `NPM_TOKEN`: npm authentication token

### Flutter SDK (pub.dev)

1. Run `dart pub token add https://pub.dev` locally
2. Copy the credentials from `~/.pub-cache/credentials.json`
3. Add to GitHub Secrets:
   - `PUB_CREDENTIALS`: Content of credentials.json

### Codecov (Code Coverage)

1. Go to [https://codecov.io](https://codecov.io)
2. Sign in with GitHub
3. Add your repository
4. Get the upload token
5. Add to GitHub Secrets:
   - `CODECOV_TOKEN`: Codecov upload token

---

## 🌳 Branch Strategy

### Main Branches

- **`main`**: Production-ready code
  - All commits must pass CI
  - Only accepts merges from `develop` or hotfix branches
  - Tagged releases are created from this branch

- **`develop`**: Integration branch
  - Active development happens here
  - Feature branches merge into `develop`
  - Regularly merged into `main` for releases

### Supporting Branches

- **`feature/*`**: New features
  - Branch from: `develop`
  - Merge back to: `develop`
  - Example: `feature/add-batch-verification`

- **`bugfix/*`**: Bug fixes
  - Branch from: `develop`
  - Merge back to: `develop`
  - Example: `bugfix/fix-timeout-error`

- **`hotfix/*`**: Critical production fixes
  - Branch from: `main`
  - Merge back to: `main` and `develop`
  - Example: `hotfix/security-patch`

- **`release/*`**: Release preparation
  - Branch from: `develop`
  - Merge back to: `main` and `develop`
  - Example: `release/v0.2.0`

---

## 📦 Publishing Process

### Automatic Publishing (Recommended)

#### 1. Create a GitHub Release

```bash
# Tag the release
git tag -a python-sdk-v0.1.0 -m "Release Python SDK v0.1.0"
git push origin python-sdk-v0.1.0

# Or for Node.js SDK
git tag -a node-sdk-v0.1.0 -m "Release Node.js SDK v0.1.0"
git push origin node-sdk-v0.1.0
```

#### 2. Create Release on GitHub

1. Go to your repository on GitHub
2. Click "Releases" → "Create a new release"
3. Select your tag
4. Write release notes
5. Click "Publish release"

The publish workflow will automatically:
- Build the package
- Run tests
- Publish to package registry
- Upload build artifacts

### Manual Publishing

#### Using Workflow Dispatch

1. Go to Actions tab on GitHub
2. Select "Publish Packages" workflow
3. Click "Run workflow"
4. Select:
   - Package to publish
   - Version number
5. Click "Run workflow"

### Local Publishing (Emergency)

#### Python SDK

```bash
cd packages/python-sdk

# Update version
poetry version 0.1.0

# Build
poetry build

# Publish to Test PyPI
poetry publish -r testpypi

# Publish to PyPI
poetry publish
```

#### Node.js SDK

```bash
cd packages/node-sdk

# Update version
npm version 0.1.0

# Build
npm run build

# Publish
npm publish --access public
```

---

## 🔍 Workflow Status Badges

Add these badges to your README.md:

```markdown
[![CI](https://github.com/your-org/kra-connect/workflows/CI/badge.svg)](https://github.com/your-org/kra-connect/actions/workflows/ci.yml)
[![Code Quality](https://github.com/your-org/kra-connect/workflows/Code%20Quality/badge.svg)](https://github.com/your-org/kra-connect/actions/workflows/code-quality.yml)
[![codecov](https://codecov.io/gh/your-org/kra-connect/branch/main/graph/badge.svg)](https://codecov.io/gh/your-org/kra-connect)
```

---

## 🐛 Troubleshooting

### CI Tests Failing

**Problem**: Tests fail on CI but pass locally

**Solutions**:
1. Check environment differences:
   ```bash
   # Run tests with same Node/Python version as CI
   nvm use 18  # For Node.js
   pyenv local 3.11  # For Python
   ```

2. Clear cache and reinstall:
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

3. Check for missing environment variables in CI

### Publishing Fails

**Problem**: Package fails to publish

**Solutions**:

1. **Invalid credentials**:
   - Verify secrets are correctly set in GitHub
   - Regenerate tokens if expired

2. **Version conflict**:
   - Check if version already exists on registry
   - Increment version number

3. **Build errors**:
   - Run build locally first
   - Check build logs in GitHub Actions

### Code Quality Checks Fail

**Problem**: Linting or formatting issues

**Solutions**:

1. Run locally and fix:
   ```bash
   # Format code
   npm run format

   # Fix linting issues
   npm run lint:fix

   # Python formatting
   cd packages/python-sdk
   poetry run black src/ tests/
   poetry run isort src/ tests/
   ```

2. Update configuration if false positives

### Codecov Upload Issues

**Problem**: Coverage not uploading

**Solutions**:

1. Check `CODECOV_TOKEN` secret
2. Verify coverage file paths in workflow
3. Check Codecov dashboard for errors

---

## 📊 Monitoring CI/CD

### Key Metrics to Monitor

1. **Build Success Rate**: Should be >95%
2. **Average Build Time**: Track trends
3. **Test Coverage**: Maintain >80%
4. **Dependency Updates**: Review weekly

### GitHub Actions Dashboard

1. Go to Actions tab
2. View recent workflow runs
3. Check for patterns in failures
4. Review execution times

---

## 🔒 Security Best Practices

1. **Never commit secrets**: Use GitHub Secrets
2. **Use minimal permissions**: Scope tokens appropriately
3. **Enable branch protection**: Require PR reviews and CI passing
4. **Keep actions updated**: Dependabot will help
5. **Review security alerts**: Check regularly

---

## 📝 Maintenance

### Weekly Tasks

- [ ] Review and merge Dependabot PRs
- [ ] Check for failed builds
- [ ] Review code coverage trends
- [ ] Update outdated actions

### Monthly Tasks

- [ ] Review and update CI configuration
- [ ] Check for new linting rules
- [ ] Review security scan results
- [ ] Update documentation

---

## 🆘 Getting Help

If you encounter issues:

1. Check workflow logs in GitHub Actions
2. Review this documentation
3. Search existing issues
4. Create a new issue with:
   - Workflow name
   - Error messages
   - Steps to reproduce

---

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [PyPI Publishing Guide](https://packaging.python.org/tutorials/packaging-projects/)
- [npm Publishing Guide](https://docs.npmjs.com/cli/publish)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**Last Updated**: 2025-01-15
