# KRA-Connect SDK Publishing Guide

This guide provides step-by-step instructions for publishing all KRA-Connect SDKs to their respective package registries.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Publishing Python SDK (PyPI)](#publishing-python-sdk-pypi)
- [Publishing Node.js SDK (npm)](#publishing-nodejs-sdk-npm)
- [Publishing PHP SDK (Packagist)](#publishing-php-sdk-packagist)
- [Publishing Go SDK (pkg.go.dev)](#publishing-go-sdk-pkggodev)
- [Publishing Flutter/Dart SDK (pub.dev)](#publishing-flutterdart-sdk-pubdev)
- [Version Management](#version-management)
- [Pre-Publishing Checklist](#pre-publishing-checklist)
- [Post-Publishing Tasks](#post-publishing-tasks)

---

## Prerequisites

### General Requirements

1. **Git Repository Setup**
   - Repository should be on GitHub at `github.com/kra-connect/*`
   - Each SDK should be in its own repository or use monorepo tags
   - All changes should be committed and pushed

2. **Accounts Required**
   - PyPI account (for Python)
   - npm account (for Node.js)
   - Packagist account (for PHP)
   - GitHub account (for Go)
   - pub.dev account (for Flutter/Dart)

3. **Tools Required**
   - Git
   - Language-specific tooling (Python, Node.js, PHP, Go, Flutter)
   - GitHub CLI (optional but recommended)

---

## Publishing Python SDK (PyPI)

### Registry: https://pypi.org/

### Initial Setup

1. **Install Publishing Tools**
   ```bash
   cd packages/kra-connect-python-sdk
   python -m pip install --upgrade pip build twine
   ```

2. **Create PyPI Account**
   - Register at https://pypi.org/account/register/
   - Enable 2FA (recommended)
   - Create API token at https://pypi.org/manage/account/token/

3. **Configure Credentials**
   ```bash
   # Create/edit ~/.pypirc
   cat > ~/.pypirc << EOF
   [distutils]
   index-servers =
       pypi
       testpypi

   [pypi]
   username = __token__
   password = pypi-YOUR-API-TOKEN

   [testpypi]
   username = __token__
   password = pypi-YOUR-TEST-API-TOKEN
   EOF

   chmod 600 ~/.pypirc
   ```

### Publishing Steps

1. **Navigate to SDK Directory**
   ```bash
   cd packages/kra-connect-python-sdk
   ```

2. **Update Version Number**
   Edit `pyproject.toml`:
   ```toml
   [project]
   name = "kra-connect"
   version = "0.1.0"  # Update this version
   ```

3. **Run Tests**
   ```bash
   pytest tests/ --cov=kra_connect --cov-report=html
   ```

4. **Build & Validate Artifacts**
   ```bash
   rm -rf dist/ build/ *.egg-info/
   python -m build
   python -m twine check dist/*
   ```

5. **Test on TestPyPI (Recommended)**
   ```bash
   twine upload --repository testpypi dist/*

   # Test installation
   pip install --index-url https://test.pypi.org/simple/ kra-connect
   ```

6. **Publish to PyPI (manual fallback)**
   ```bash
   twine upload dist/*
   ```

### Automation (GitHub Actions)

- Workflow file: `packages/kra-connect-python-sdk/.github/workflows/publish-pypi.yml`
- Trigger: GitHub release (type `published`) or manual `workflow_dispatch`
- Publisher type: [Trusted Publisher](https://docs.pypi.org/trusted-publishers/) using OpenID Connect (no PyPI token stored in GitHub)
- Environment: `pypi-release` (configure in GitHub → Settings → Environments if you want reviewers/approvals)
- Secrets required: none for publishing (still keep a PyPI token locally for manual emergency uploads)
- Repository visibility: can remain **private**; PyPI only verifies the workflow + environment you register.

**Register the Trusted Publisher on PyPI**

1. Visit https://pypi.org/manage/project/kra-connect/publishing/ and click **Add a publisher**.
2. Choose **GitHub Actions** and fill in:
   - **Owner:** `BerjisTech`
   - **Repository:** `kra-connect-python-sdk`
   - **Workflow:** `.github/workflows/publish-pypi.yml`
   - **Environment:** `pypi-release`
3. Save the publisher. PyPI now issues short-lived credentials every time the workflow runs, so no `PYPI_API_TOKEN` is needed in GitHub.

Recommended release flow:
1. Cut a release branch, bump the version in `pyproject.toml`, and merge to `main`.
2. Draft a GitHub release with the same version tag (for example `v0.2.0`). When the release is published the workflow builds and uploads to PyPI automatically.
3. If you need to test first, point `twine upload --repository testpypi` at your artifacts (or configure a second workflow job targeting TestPyPI).

7. **Verify Publication**
   ```bash
   pip install kra-connect
   python -c "import kra_connect; print(kra_connect.__version__)"
   ```

### Troubleshooting

- **Error: File already exists**: Version already published, increment version number
- **Error: Invalid credentials**: Check API token in ~/.pypirc
- **Error: Package name already taken**: Contact PyPI support or choose different name

### Links
- Package: https://pypi.org/project/kra-connect/
- GitHub Workflow: `.github/workflows/publish-pypi.yml`
- Documentation: https://docs.kra-connect.dev/python (and `packages/kra-connect-python-sdk/README.md`)

---

## Publishing Node.js SDK (npm)

### Registry: https://www.npmjs.com/

### Initial Setup

1. **Install npm** (comes with Node.js)
   ```bash
   node --version
   npm --version
   ```

2. **Create npm Account**
   - Register at https://www.npmjs.com/signup
   - Enable 2FA (recommended)

3. **Login to npm**
   ```bash
   npm login
   # Or with 2FA token
   npm login --auth-type=legacy
   ```

### Publishing Steps

1. **Navigate to SDK Directory**
   ```bash
   cd packages/node-sdk
   ```

2. **Update Version Number**
   ```bash
   # Option 1: Manual edit package.json
   # "version": "0.1.0"

   # Option 2: Use npm version command
   npm version patch  # 0.1.0 -> 0.1.1
   npm version minor  # 0.1.0 -> 0.2.0
   npm version major  # 0.1.0 -> 1.0.0
   ```

3. **Run Tests**
   ```bash
   npm test
   npm run lint
   npm run build  # If TypeScript
   ```

4. **Check Package Contents**
   ```bash
   npm pack --dry-run
   ```

5. **Publish to npm**
   ```bash
   # First time publishing
   npm publish --access public

   # Subsequent publishes
   npm publish
   ```

6. **Publish with Tag (Optional)**
   ```bash
   npm publish --tag beta
   npm publish --tag next
   ```

7. **Verify Publication**
   ```bash
   npm view @kra-connect/node
   npm install @kra-connect/node
   ```

### Package Scopes

If using scoped packages (@kra-connect/node):
```bash
npm publish --access public
```

### Troubleshooting

- **Error: Must be logged in**: Run `npm login`
- **Error: Version already published**: Increment version with `npm version`
- **Error: 403 Forbidden**: Check package name availability or permissions
- **Error: Two-factor auth required**: Add `--otp=123456` with your 2FA code

### Links
- Package: https://www.npmjs.com/package/@kra-connect/node
- Documentation: Auto-displayed from README.md

---

## Publishing PHP SDK (Packagist)

### Registry: https://packagist.org/

### Initial Setup

1. **Create Packagist Account**
   - Register at https://packagist.org/register
   - Connect GitHub account

2. **No Manual Upload Required**
   - Packagist reads directly from GitHub
   - Updates automatically via GitHub webhooks

### Publishing Steps

1. **Update Version in composer.json**
   ```bash
   cd packages/php-sdk
   ```

   Edit `composer.json`:
   ```json
   {
       "name": "kra-connect/php-sdk",
       "version": "0.1.0",
       "type": "library"
   }
   ```

2. **Run Tests & Quality Checks**
   ```bash
   composer test
   composer phpstan
   composer psalm
   composer cs-check
   ```

3. **Commit and Tag Release**
   ```bash
   git add .
   git commit -m "Release v0.1.0"
   git tag v0.1.0
   git push origin main
   git push origin v0.1.0
   ```

4. **Submit to Packagist**
   - Go to https://packagist.org/packages/submit
   - Enter repository URL: `https://github.com/kra-connect/php-sdk`
   - Click "Check" and then "Submit"

5. **Enable Auto-Update (Recommended)**
   - Go to package settings on Packagist
   - Set up GitHub webhook for automatic updates
   - Or use GitHub Service Hook

6. **Verify Publication**
   ```bash
   composer require kra-connect/php-sdk
   composer show kra-connect/php-sdk
   ```

### GitHub Webhook Setup

Add to your GitHub repository (Settings > Webhooks):
- Payload URL: `https://packagist.org/api/github?username=YOUR_USERNAME`
- Content type: `application/json`
- Events: "Just the push event"

### Troubleshooting

- **Package not found**: Wait a few minutes for indexing
- **Version not updating**: Check GitHub webhook or manually update on Packagist
- **Validation errors**: Ensure composer.json is valid with `composer validate`

### Links
- Package: https://packagist.org/packages/kra-connect/php-sdk
- Documentation: From README.md

---

## Publishing Go SDK (pkg.go.dev)

### Registry: https://pkg.go.dev/

### Initial Setup

**No Account or Manual Submission Required!**

Go modules are automatically indexed from public GitHub repositories.

### Publishing Steps

1. **Update Version in go.mod**
   ```bash
   cd packages/go-sdk
   ```

   Ensure `go.mod` has correct module path:
   ```go
   module github.com/kra-connect/go-sdk

   go 1.21
   ```

2. **Run Tests**
   ```bash
   go test ./...
   go vet ./...
   golint ./...
   ```

3. **Ensure Proper Documentation**
   - All exported functions/types must have GoDoc comments
   - Package-level documentation in main file

4. **Commit and Tag Release**
   ```bash
   git add .
   git commit -m "Release v0.1.0"
   git tag v0.1.0
   git push origin main
   git push origin v0.1.0
   ```

5. **Trigger pkg.go.dev Indexing**
   ```bash
   # Visit this URL in browser to request indexing
   # Replace with your module path and version
   curl https://proxy.golang.org/github.com/kra-connect/go-sdk/@v/v0.1.0.info
   ```

   Or visit:
   ```
   https://pkg.go.dev/github.com/kra-connect/go-sdk@v0.1.0
   ```

6. **Verify Publication**
   ```bash
   go get github.com/kra-connect/go-sdk@v0.1.0
   go list -m github.com/kra-connect/go-sdk@latest
   ```

### Version Tags

Go uses semantic versioning with 'v' prefix:
- `v0.1.0` - Initial development
- `v1.0.0` - First stable release
- `v1.0.1` - Patch release
- `v1.1.0` - Minor release
- `v2.0.0` - Major release (breaking changes)

### Major Version Changes (v2+)

For major versions >= 2:
```go
// Update module path in go.mod
module github.com/kra-connect/go-sdk/v2
```

### Troubleshooting

- **Module not found**: Repository must be public on GitHub
- **Version not showing**: Wait up to 15 minutes for indexing
- **Documentation not showing**: Check that all exports have GoDoc comments
- **License not detected**: Add LICENSE file to repository root

### Links
- Package: https://pkg.go.dev/github.com/kra-connect/go-sdk
- Documentation: Auto-generated from GoDoc comments

---

## Publishing Flutter/Dart SDK (pub.dev)

### Registry: https://pub.dev/

### Initial Setup

1. **Install Flutter & Dart SDK**
   ```bash
   flutter --version
   dart --version
   ```

2. **Create pub.dev Account**
   - Account is created automatically when you first publish
   - Uses Google account authentication

3. **Configure Credentials**
   ```bash
   # Run once to authenticate
   dart pub token add https://pub.dev
   # Opens browser for Google authentication
   ```

### Publishing Steps

1. **Navigate to SDK Directory**
   ```bash
   cd packages/flutter-sdk
   ```

2. **Update Version in pubspec.yaml**
   ```yaml
   name: kra_connect
   version: 0.1.0  # Update this version
   ```

3. **Run Tests & Analysis**
   ```bash
   flutter test
   flutter analyze
   dart format --set-exit-if-changed .
   ```

4. **Dry Run**
   ```bash
   dart pub publish --dry-run
   ```

   This checks:
   - Package structure
   - pubspec.yaml validity
   - LICENSE file presence
   - README.md presence
   - CHANGELOG.md presence
   - Package size (< 100 MB)

5. **Publish to pub.dev**
   ```bash
   dart pub publish
   ```

   - Confirms package details
   - Asks for confirmation
   - Publishes to pub.dev

6. **Verify Publication**
   ```bash
   flutter pub add kra_connect
   dart pub get
   ```

### Required Files

- `pubspec.yaml` - Package manifest
- `README.md` - Package documentation
- `CHANGELOG.md` - Version history
- `LICENSE` - License file
- `lib/` - Source code directory

### Troubleshooting

- **Error: Missing LICENSE**: Add LICENSE file
- **Error: Missing CHANGELOG**: Add CHANGELOG.md
- **Error: Version already published**: Increment version
- **Error: Package name taken**: Choose different name
- **Error: Invalid dependency**: Check dependency versions in pubspec.yaml

### Links
- Package: https://pub.dev/packages/kra_connect
- Documentation: From README.md and API docs

---

## Version Management

### Semantic Versioning (SemVer)

All SDKs follow semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR** (1.0.0): Breaking changes
- **MINOR** (0.1.0): New features, backward compatible
- **PATCH** (0.0.1): Bug fixes, backward compatible

### Pre-release Versions

- `0.1.0-alpha.1` - Alpha release
- `0.1.0-beta.1` - Beta release
- `0.1.0-rc.1` - Release candidate

### Version Synchronization

**Recommendation**: Keep all SDK versions in sync for clarity.

Example:
- Python SDK: v0.1.0
- Node.js SDK: v0.1.0
- PHP SDK: v0.1.0
- Go SDK: v0.1.0
- Flutter SDK: v0.1.0

Update `CHANGELOG.md` in each SDK when publishing.

---

## Pre-Publishing Checklist

Use this checklist before publishing each SDK:

### Documentation
- [ ] README.md is complete and accurate
- [ ] CHANGELOG.md is updated with changes
- [ ] LICENSE file is present (MIT)
- [ ] CONTRIBUTING.md is present
- [ ] API documentation is complete
- [ ] Code examples are tested and work

### Code Quality
- [ ] All tests pass locally
- [ ] Code linting passes
- [ ] No console.log/print statements in production code
- [ ] No hardcoded API keys or secrets
- [ ] Type hints/annotations are complete
- [ ] Error handling is comprehensive

### Testing
- [ ] Unit tests >= 80% coverage
- [ ] Integration tests pass
- [ ] Examples run without errors
- [ ] Tested on multiple platforms (if applicable)

### Version Control
- [ ] All changes committed
- [ ] Version number updated in package manifest
- [ ] Git tag created for version
- [ ] Changes pushed to GitHub

### Package-Specific
- [ ] Package name is available
- [ ] Package description is clear
- [ ] Keywords/topics are added
- [ ] Author/maintainer info is correct
- [ ] Repository URL is correct
- [ ] Issue tracker URL is correct

---

## Post-Publishing Tasks

After successfully publishing:

### 1. Verify Installation

Test installation on clean environment:

**Python:**
```bash
python -m venv test_env
source test_env/bin/activate
pip install kra-connect
python -c "import kra_connect; print(kra_connect.__version__)"
```

**Node.js:**
```bash
mkdir test_project && cd test_project
npm init -y
npm install @kra-connect/node
node -e "const kra = require('@kra-connect/node'); console.log('OK')"
```

**PHP:**
```bash
mkdir test_project && cd test_project
composer init -n
composer require kra-connect/php-sdk
php -r "require 'vendor/autoload.php'; echo 'OK';"
```

**Go:**
```bash
mkdir test_project && cd test_project
go mod init test
go get github.com/kra-connect/go-sdk@latest
```

**Flutter:**
```bash
flutter create test_app
cd test_app
flutter pub add kra_connect
flutter pub get
```

### 2. Update Documentation

- [ ] Update main README.md with installation links
- [ ] Update project website (if any)
- [ ] Announce on social media
- [ ] Update comparison tables

### 3. Create GitHub Release

```bash
# Using GitHub CLI
gh release create v0.1.0 \
  --title "Release v0.1.0" \
  --notes "Initial release of KRA-Connect SDK"

# Or manually via GitHub web interface
```

### 4. Monitor

- [ ] Check package download statistics
- [ ] Watch for issues/bug reports
- [ ] Monitor CI/CD pipelines
- [ ] Review security advisories

---

## Automation with CI/CD

### GitHub Actions Example

Create `.github/workflows/publish.yml`:

```yaml
name: Publish SDK

on:
  push:
    tags:
      - 'v*'

jobs:
  publish-python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Build and publish
        run: |
          cd packages/python-sdk
          pip install build twine
          python -m build
          twine upload dist/*
        env:
          TWINE_USERNAME: __token__
          TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}

  publish-node:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
          registry-url: 'https://registry.npmjs.org'
      - name: Publish
        run: |
          cd packages/node-sdk
          npm ci
          npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}

  # Add similar jobs for other SDKs
```

---

## Emergency: Unpublishing or Yanking

### Python (PyPI)
```bash
# Cannot unpublish, but can yank (hides from pip install)
pip install pkginfo
# Contact PyPI support for removal
```

### Node.js (npm)
```bash
# Unpublish within 72 hours
npm unpublish @kra-connect/node@0.1.0

# Deprecate version
npm deprecate @kra-connect/node@0.1.0 "This version has critical bugs"
```

### PHP (Packagist)
- Delete git tag
- Packagist will remove version on next sync
- Or manually delete on Packagist website

### Go
- Delete git tag
- Version will eventually expire from cache
- Cannot force immediate removal

### Flutter (pub.dev)
- Cannot unpublish after 7 days
- Use version retraction in pubspec.yaml

---

## Support & Resources

### Python
- PyPI Help: https://pypi.org/help/
- Packaging Guide: https://packaging.python.org/

### Node.js
- npm Docs: https://docs.npmjs.com/
- Publishing Guide: https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry

### PHP
- Packagist About: https://packagist.org/about
- Composer Docs: https://getcomposer.org/doc/

### Go
- Module Guide: https://go.dev/doc/modules/
- pkg.go.dev About: https://pkg.go.dev/about

### Flutter/Dart
- Publishing Guide: https://dart.dev/tools/pub/publishing
- pub.dev Policy: https://pub.dev/policy

---

## Troubleshooting Common Issues

### Issue: "Package name already taken"
**Solution**: Choose a different name or contact registry support to claim name.

### Issue: "Authentication failed"
**Solution**: Regenerate API tokens and update credentials.

### Issue: "Build failed"
**Solution**: Run tests locally, check for missing dependencies.

### Issue: "Documentation not rendering"
**Solution**: Ensure README.md is valid Markdown, check for syntax errors.

### Issue: "Version conflict"
**Solution**: Check if version already published, increment version number.

---

## Best Practices

1. **Always test before publishing** - Use dry-run options where available
2. **Keep versions in sync** - Makes it easier for users
3. **Write good CHANGELOG** - Users appreciate knowing what changed
4. **Respond to issues quickly** - Monitor package health
5. **Security first** - Enable 2FA, use API tokens, never commit secrets
6. **Automate where possible** - Use CI/CD for publishing
7. **Monitor downloads** - Understand usage patterns
8. **Deprecate properly** - Give users time to migrate

---

## Questions?

- Create an issue at: https://github.com/kra-connect/monorepo/issues
- Email: support@kra-connect.dev
- Documentation: https://kra-connect.dev/docs/publishing

---

**Happy Publishing! 🚀**
