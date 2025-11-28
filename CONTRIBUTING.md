# Contributing to KRA-Connect

First off, thank you for considering contributing to KRA-Connect! It's people like you that make KRA-Connect such a great tool for the Kenyan developer community.

## 🎯 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** - Include code samples or links
- **Describe the behavior you observed** and **what you expected to see**
- **Include screenshots** if relevant
- **Specify your environment** - OS, Node/Python/PHP version, etc.

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the proposed feature
- **Explain why this enhancement would be useful** to most users
- **List some examples** of how it would be used
- **Specify which SDK/tool** the enhancement applies to

### Pull Requests

1. **Fork the repo** and create your branch from `main`
2. **Follow the coding standards** (see below)
3. **Write comprehensive tests** - aim for 90%+ coverage
4. **Update documentation** - README, API docs, examples
5. **Ensure all tests pass** - `npm test` or language-specific commands
6. **Write a good commit message** - follow conventional commits

## 📝 Development Process

### Getting Started

1. Clone your fork:
```bash
git clone https://github.com/your-username/kra-connect.git
cd kra-connect
```

2. Install dependencies:
```bash
npm install
```

3. Create a branch:
```bash
git checkout -b feature/your-feature-name
```

4. Make your changes and commit:
```bash
git add .
git commit -m "feat: add amazing feature"
```

5. Push to your fork and submit a pull request:
```bash
git push origin feature/your-feature-name
```

### Project Structure

```
kra-connect/
├── packages/          # SDKs for different languages
│   ├── node-sdk/     # TypeScript/Node.js
│   ├── python-sdk/   # Python
│   ├── php-sdk/      # PHP
│   ├── go-sdk/       # Go
│   └── flutter-sdk/  # Flutter/Dart
├── apps/             # Business applications
│   ├── dashboard/    # Angular dashboard
│   ├── api-service/  # Backend API
│   └── mobile/       # Flutter mobile app
├── tools/            # Developer tools
│   ├── cli/          # Command-line tool
│   ├── mock-server/  # Mock API server
│   └── test-utils/   # Testing utilities
└── docs/             # Documentation
```

## 🎨 Coding Standards

### General Principles

1. **Follow the [AI Assistant Guidelines](CLAUDE.md)** - This is our primary style guide
2. **Code Quality Over Speed** - Write maintainable code
3. **Documentation is Non-Negotiable** - Document everything
4. **Test Everything** - Minimum 80% coverage, 90%+ for critical paths

### Naming Conventions

#### Variables & Functions
```typescript
// ✅ Good - descriptive names
const taxComplianceChecker = new TaxComplianceChecker();
const userPinNumber = request.data.get('pin');
const isValidTcc = validateTcc(tccNumber);

// ❌ Bad - abbreviations
const checker = new TaxComplianceChecker();
const pin = request.data.get('pin');
const valid = validateTcc(num);
```

#### Classes & Types
```typescript
// ✅ Good - PascalCase
class TaxPayerVerificationService {}
interface KraApiResponse {}

// ❌ Bad
class tax_payer_verification_service {}
```

#### Files & Directories
```
✅ tax-compliance-checker.ts
✅ user-authentication.service.ts
❌ TaxComplianceChecker.ts (unless React component)
```

### Documentation Standards

Every function/method must have comprehensive documentation:

```typescript
/**
 * Verifies a KRA PIN number with the GavaConnect API.
 *
 * This function checks if a PIN is valid and currently active in the KRA system.
 * Results are cached for 1 hour to reduce API calls.
 *
 * @param pinNumber - The KRA PIN to verify (format: P followed by 9 digits and a letter)
 * @param options - Optional configuration for the verification request
 * @returns Promise resolving to verification result with taxpayer details
 * @throws {InvalidPinFormatError} If PIN format is invalid
 * @throws {ApiAuthenticationError} If API key is invalid
 * @throws {ApiTimeoutError} If request times out
 *
 * @example
 * ```typescript
 * const result = await verifyPin('P051234567A');
 * if (result.isValid) {
 *   console.log(`Valid PIN: ${result.taxpayerName}`);
 * }
 * ```
 */
async function verifyPin(
  pinNumber: string,
  options?: VerificationOptions
): Promise<VerificationResult> {
  // Implementation
}
```

### Testing Standards

```typescript
// ✅ Good test names - descriptive and clear
describe('PinVerifierService', () => {
  describe('verifyPin()', () => {
    it('should return valid result for correct PIN format', async () => {
      // Arrange
      const verifier = new PinVerifierService({ apiKey: 'test-key' });
      const validPin = 'P051234567A';

      // Act
      const result = await verifier.verifyPin(validPin);

      // Assert
      expect(result.isValid).toBe(true);
      expect(result.pinNumber).toBe(validPin);
    });

    it('should throw InvalidPinError for incorrect format', async () => {
      const verifier = new PinVerifierService({ apiKey: 'test-key' });

      await expect(verifier.verifyPin('INVALID')).rejects.toThrow(InvalidPinError);
    });
  });
});
```

## 🔒 Security Guidelines

1. **Never commit secrets** - Use environment variables
2. **Validate all inputs** - Don't trust user input
3. **Use secure error messages** - Don't expose internal details
4. **Follow OWASP guidelines** - Check for common vulnerabilities
5. **Report security issues privately** - Email security@kra-connect.dev

## 📦 Language-Specific Guidelines

### TypeScript/Node.js
- Use TypeScript strict mode
- Define interfaces for all data structures
- Use async/await over callbacks
- Follow Airbnb style guide

### Python
- Follow PEP 8
- Use type hints
- Write docstrings (Google style)
- Use Black for formatting

### PHP
- Follow PSR-12
- Use type declarations
- Write PHPDoc comments
- Use Composer for dependencies

### Go
- Follow Go conventions
- Use gofmt for formatting
- Write GoDoc comments
- Handle errors explicitly

## 🧪 Testing

### Running Tests

```bash
# All tests
npm test

# Specific package
cd packages/node-sdk && npm test

# With coverage
npm test -- --coverage

# Watch mode
npm test -- --watch
```

### Test Coverage Requirements
- **Minimum 80%** for all code
- **90%+** for critical paths (auth, API calls)
- Test files must be alongside source or in `tests/` directory

## 📋 Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(sdk): add batch PIN verification support
fix(api): handle timeout errors in TCC verification
docs(readme): update installation instructions
test(pin-verifier): add tests for edge cases
refactor(auth): simplify token refresh logic
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

## 🔄 Pull Request Process

1. **Update documentation** - README, API docs, changelog
2. **Add tests** - Ensure good coverage
3. **Run linting** - `npm run lint`
4. **Run tests** - `npm test`
5. **Update CHANGELOG.md** - Document your changes
6. **Request review** - Tag relevant maintainers
7. **Address feedback** - Make requested changes
8. **Squash commits** - Keep history clean (if needed)

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] No new warnings
- [ ] Breaking changes documented

## 🎓 Learning Resources

### For Beginners
- [First Contributions](https://github.com/firstcontributions/first-contributions)
- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Git and GitHub Tutorial](https://www.freecodecamp.org/news/git-and-github-for-beginners/)

### For the Project
- [GavaConnect API Documentation](https://developer.go.ke)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [Python Best Practices](https://docs.python-guide.org/)

## 💬 Community

- **Discord**: [Join our server](https://discord.gg/kra-connect)
- **GitHub Discussions**: For questions and ideas
- **Twitter**: [@kraconnect](https://twitter.com/kraconnect)

## 📜 Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## ❓ Questions?

Don't hesitate to ask! You can:
- Open an issue with the `question` label
- Ask in our Discord server
- Email developers@kra-connect.dev

---

**Thank you for contributing to KRA-Connect!** 🎉
