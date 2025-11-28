# AGENTS.md - AI Assistant Development Guidelines

## Purpose
This document provides guidelines for AI assistants (Claude, Gemini, Codex, etc.) when helping develop the KRA-Connect project. Following these guidelines ensures consistent, maintainable, and high-quality code across all components.

---

## 🎯 Core Principles

### 1. Code Quality Over Speed
- Prioritize maintainable, readable code over quick hacks
- Write code that other developers will understand in 6 months
- Favor explicit over implicit
- Choose clarity over cleverness

### 2. Documentation is Non-Negotiable
- **Document. Document. Document.**
- Every function, class, and module needs documentation
- README files for every package/directory
- Inline comments for complex logic
- API documentation for all endpoints
- Usage examples for all public APIs

### 3. Consistency Across the Codebase
- Follow established patterns within each language/framework
- Use consistent naming conventions
- Maintain consistent file structures
- Apply consistent error handling patterns

---

## 📝 Naming Conventions

### Variables & Functions

**✅ DO: Use Descriptive Names**
```python
# Good
tax_compliance_checker = TaxComplianceChecker()
user_pin_number = request.data.get('pin')
is_valid_tcc = validate_tcc(tcc_number)

# Bad
checker = TaxComplianceChecker()
u = request.data.get('pin')
valid = validate_tcc(num)
```

**❌ DON'T: Use Abbreviations or Single Letters (Except Loops)**
```python
# Bad
def proc_usr_data(usr, pin):
    if u.is_auth():
        return True

# Good
def process_user_data(user, pin_number):
    if user.is_authenticated():
        return True

# Acceptable for loops
for index in range(10):  # 'i' also acceptable here
    for item in items:   # Not 'itm'
        process(item)
```

### Classes & Types

**Use PascalCase for Classes**
```typescript
// Good
class TaxPayerVerificationService {}
interface KraApiResponse {}
type ComplianceStatus = 'compliant' | 'non-compliant';

// Bad
class tax_payer_verification_service {}
interface kraApiResponse {}
```

### Files & Directories

**Use kebab-case for Files (unless language convention differs)**
```
✅ tax-compliance-checker.ts
✅ user-authentication.service.ts
✅ kra-api-client.py

❌ TaxComplianceChecker.ts (unless React component)
❌ user_auth.ts (inconsistent with kebab-case)
```

### Constants

**Use SCREAMING_SNAKE_CASE**
```python
MAX_RETRY_ATTEMPTS = 3
DEFAULT_TIMEOUT_SECONDS = 30
KRA_API_BASE_URL = "https://api.kra.go.ke"
```

---

## 🏗️ Project Structure

### Language Separation

**CRITICAL: Keep languages strictly separated**

```
✅ CORRECT STRUCTURE:
packages/
├── python-sdk/
│   ├── src/
│   ├── tests/
│   ├── README.md
│   └── pyproject.toml
├── node-sdk/
│   ├── src/
│   ├── tests/
│   ├── README.md
│   └── package.json
├── php-sdk/
│   ├── src/
│   ├── tests/
│   ├── README.md
│   └── composer.json
└── go-sdk/
    ├── pkg/
    ├── tests/
    ├── README.md
    └── go.mod

❌ WRONG: Mixing languages
packages/
├── sdk/
│   ├── python/
│   ├── node/
│   └── php/  # Don't mix!
```

### Component Organization

```
✅ GOOD: Feature-based structure
src/
├── authentication/
│   ├── auth.service.ts
│   ├── auth.service.spec.ts
│   ├── token.manager.ts
│   └── README.md
├── verification/
│   ├── pin-verifier.service.ts
│   ├── tcc-verifier.service.ts
│   └── README.md
└── api-client/
    ├── http-client.ts
    ├── retry-handler.ts
    └── README.md

❌ BAD: Type-based structure (harder to navigate)
src/
├── services/
│   ├── auth.service.ts
│   ├── pin.service.ts
│   └── tcc.service.ts
├── managers/
│   └── token.manager.ts
└── clients/
    └── http-client.ts
```

---

## 🎨 Framework-Specific Guidelines

### Angular (Primary UI Framework)

**✅ DO: Use Angular for all UI components**
```typescript
// Good - Angular component
@Component({
  selector: 'app-pin-verifier',
  templateUrl: './pin-verifier.component.html',
  styleUrls: ['./pin-verifier.component.scss']
})
export class PinVerifierComponent implements OnInit {
  pinNumber: string = '';
  verificationResult: VerificationResult | null = null;

  constructor(
    private verificationService: VerificationService,
    private notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    // Initialization logic
  }

  async verifyPin(): Promise<void> {
    try {
      this.verificationResult = await this.verificationService.verifyPin(this.pinNumber);
      this.notificationService.success('PIN verified successfully');
    } catch (error) {
      this.notificationService.error('Verification failed');
    }
  }
}
```

**❌ DON'T: Put HTML in TypeScript files**
```typescript
// Bad - inline HTML in TypeScript
@Component({
  selector: 'app-pin-verifier',
  template: `
    <div class="container">
      <h1>PIN Verifier</h1>
      <input [(ngModel)]="pinNumber" placeholder="Enter PIN" />
      <button (click)="verifyPin()">Verify</button>
      <!-- 100+ lines of HTML here --> 
    </div>
  `
})
export class PinVerifierComponent {} // Don't do this!

// Good - separate template file
@Component({
  selector: 'app-pin-verifier',
  templateUrl: './pin-verifier.component.html',
  styleUrls: ['./pin-verifier.component.scss']
})
export class PinVerifierComponent {}
```

**Angular Project Structure**
```
apps/dashboard/
├── src/
│   ├── app/
│   │   ├── core/              # Singleton services, guards
│   │   │   ├── services/
│   │   │   ├── guards/
│   │   │   └── interceptors/
│   │   ├── shared/            # Shared components, pipes, directives
│   │   │   ├── components/
│   │   │   ├── pipes/
│   │   │   └── directives/
│   │   ├── features/          # Feature modules
│   │   │   ├── verification/
│   │   │   ├── compliance/
│   │   │   └── suppliers/
│   │   └── app.component.ts
│   ├── assets/
│   ├── environments/
│   └── styles/
├── README.md
└── angular.json
```

### React (For Standalone Libraries/Packages Only)

**Use React ONLY when creating:**
- Standalone component libraries (e.g., `@kra-connect/react-components`)
- NPM packages for React developers
- Demo/example applications for React users
- Documentation playground components

```typescript
// Good - React component library package
// packages/react-components/src/PinVerifier.tsx

import React, { useState } from 'react';
import { verifyPin } from '@kra-connect/node';

export interface PinVerifierProps {
  onSuccess?: (result: VerificationResult) => void;
  onError?: (error: Error) => void;
  apiKey: string;
}

/**
 * PinVerifier component for KRA PIN verification
 * 
 * @example
 * ```tsx
 * <PinVerifier 
 *   apiKey="your-api-key"
 *   onSuccess={(result) => console.log(result)}
 * />
 * ```
 */
export const PinVerifier: React.FC<PinVerifierProps> = ({
  onSuccess,
  onError,
  apiKey
}) => {
  const [pinNumber, setPinNumber] = useState('');
  const [loading, setLoading] = useState(false);

  const handleVerify = async () => {
    setLoading(true);
    try {
      const result = await verifyPin(pinNumber, apiKey);
      onSuccess?.(result);
    } catch (error) {
      onError?.(error as Error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="kra-pin-verifier">
      <input
        type="text"
        value={pinNumber}
        onChange={(e) => setPinNumber(e.target.value)}
        placeholder="Enter KRA PIN"
        disabled={loading}
      />
      <button onClick={handleVerify} disabled={loading}>
        {loading ? 'Verifying...' : 'Verify PIN'}
      </button>
    </div>
  );
};
```

**React Package Structure**
```
packages/react-components/
├── src/
│   ├── components/
│   │   ├── PinVerifier/
│   │   │   ├── PinVerifier.tsx
│   │   │   ├── PinVerifier.test.tsx
│   │   │   ├── PinVerifier.stories.tsx
│   │   │   └── README.md
│   │   └── index.ts
│   └── index.ts
├── README.md
├── package.json
└── tsconfig.json
```

### Vue (For Vue-Specific Packages Only)

Similar to React - only use for standalone Vue packages:
- `@kra-connect/vue-components`
- Vue-specific examples and demos

---

## 📚 Documentation Standards

### Every File Needs a Header Comment

```typescript
/**
 * @file pin-verifier.service.ts
 * @description Service for verifying KRA PIN numbers using the GavaConnect API
 * @module verification
 * @author KRA-Connect Team
 * @created 2025-01-15
 */

/**
 * Service responsible for PIN verification operations
 * 
 * This service handles communication with the KRA GavaConnect API
 * for PIN verification, including retry logic, caching, and error handling.
 * 
 * @example
 * ```typescript
 * const verifier = new PinVerifierService(apiKey);
 * const result = await verifier.verify('P051234567A');
 * if (result.isValid) {
 *   console.log('PIN is valid');
 * }
 * ```
 */
export class PinVerifierService {
  // Implementation
}
```

### Function Documentation

```python
def verify_tax_compliance_certificate(
    tcc_number: str,
    api_key: str,
    timeout: int = 30
) -> ComplianceResult:
    """
    Verify a Tax Compliance Certificate with KRA.
    
    This function checks if a TCC number is valid and currently active
    in the KRA system. It includes automatic retry logic and caching.
    
    Args:
        tcc_number: The TCC number to verify (format: TCC followed by digits)
        api_key: Your GavaConnect API key
        timeout: Request timeout in seconds (default: 30)
        
    Returns:
        ComplianceResult: Object containing verification status and details
        
    Raises:
        InvalidTccFormatError: If TCC format is invalid
        ApiAuthenticationError: If API key is invalid
        ApiTimeoutError: If request times out
        
    Example:
        >>> result = verify_tax_compliance_certificate('TCC123456', 'api-key-here')
        >>> if result.is_valid:
        ...     print(f"TCC valid until {result.expiry_date}")
        
    Note:
        Results are cached for 1 hour to reduce API calls.
        
    See Also:
        verify_pin(): For PIN verification
    """
    # Implementation
```

### README.md for Every Package/Module

```markdown
# KRA Python SDK - PIN Verification Module

## Overview
This module provides PIN verification functionality for the KRA-Connect Python SDK.

## Installation
```bash
pip install kra-connect
```

## Quick Start
```python
from kra_connect import PinVerifier

verifier = PinVerifier(api_key='your-api-key')
result = verifier.verify('P051234567A')

if result.is_valid:
    print(f"Valid PIN: {result.taxpayer_name}")
```

## API Reference

### `PinVerifier`
Main class for PIN verification operations.

#### Methods

##### `verify(pin_number: str) -> VerificationResult`
Verifies a KRA PIN number.

**Parameters:**
- `pin_number` (str): The PIN to verify

**Returns:**
- `VerificationResult`: Verification result object

**Raises:**
- `InvalidPinError`: If PIN format is invalid
- `ApiError`: If API request fails

## Examples

### Basic Verification
[Code example here]

### Batch Verification
[Code example here]

### Error Handling
[Code example here]

## Testing
```bash
pytest tests/
```

## Contributing
See [CONTRIBUTING.md](../../CONTRIBUTING.md)

## License
MIT
```

---

## 🧪 Testing Standards

### Test Coverage Requirements
- **Minimum 80% coverage** for all production code
- **90%+ coverage** for critical paths (auth, API calls)
- Test files must live alongside source files or in `tests/` directory

### Test Naming

```typescript
// Good test names - descriptive and clear
describe('PinVerifierService', () => {
  describe('verify()', () => {
    it('should return valid result for correct PIN format', async () => {
      // Test implementation
    });

    it('should throw InvalidPinError for incorrect PIN format', async () => {
      // Test implementation
    });

    it('should retry up to 3 times on network failure', async () => {
      // Test implementation
    });

    it('should return cached result within cache TTL', async () => {
      // Test implementation
    });
  });
});

// Bad test names
it('test1', () => {});
it('works', () => {});
it('pin verification', () => {});
```

### Test Structure (Arrange-Act-Assert)

```python
def test_verify_pin_with_valid_format():
    """Test PIN verification with valid format returns success."""
    # Arrange
    verifier = PinVerifier(api_key='test-key')
    valid_pin = 'P051234567A'
    expected_result = VerificationResult(is_valid=True)
    
    # Act
    result = verifier.verify(valid_pin)
    
    # Assert
    assert result.is_valid is True
    assert result.pin_number == valid_pin
    assert result.taxpayer_name is not None
```

---

## 🔒 Security Best Practices

### Never Hardcode Secrets

```typescript
// ❌ Bad - hardcoded API key
const API_KEY = 'kra-api-key-12345';

// ✅ Good - environment variable
const API_KEY = process.env.KRA_API_KEY;
if (!API_KEY) {
  throw new Error('KRA_API_KEY environment variable is required');
}
```

### Input Validation

```python
def verify_pin(pin_number: str) -> VerificationResult:
    """Verify a KRA PIN number."""
    # Always validate input
    if not pin_number:
        raise ValueError("PIN number is required")
    
    if not isinstance(pin_number, str):
        raise TypeError("PIN number must be a string")
    
    # Validate format
    if not PIN_REGEX.match(pin_number):
        raise InvalidPinFormatError(
            f"Invalid PIN format: {pin_number}. "
            "Expected format: P followed by 9 digits and a letter"
        )
    
    # Sanitize input
    pin_number = pin_number.strip().upper()
    
    # Proceed with verification
    return self._verify_with_api(pin_number)
```

### Secure Error Messages

```typescript
// ❌ Bad - exposes internal details
throw new Error(`Database connection failed: ${dbConnectionString}`);

// ✅ Good - generic message for user, detailed log for developers
logger.error('Database connection failed', { 
  connectionString: dbConnectionString,
  error: error.message 
});
throw new Error('An internal error occurred. Please try again later.');
```

---

## 🎯 Error Handling

### Create Custom Error Classes

```python
# errors.py
class KraConnectError(Exception):
    """Base exception for KRA-Connect library."""
    pass

class InvalidPinFormatError(KraConnectError):
    """Raised when PIN format is invalid."""
    pass

class ApiAuthenticationError(KraConnectError):
    """Raised when API authentication fails."""
    pass

class ApiTimeoutError(KraConnectError):
    """Raised when API request times out."""
    pass

class RateLimitExceededError(KraConnectError):
    """Raised when API rate limit is exceeded."""
    def __init__(self, retry_after: int):
        self.retry_after = retry_after
        super().__init__(f"Rate limit exceeded. Retry after {retry_after} seconds")
```

### Consistent Error Handling Pattern

```typescript
async function verifyPin(pinNumber: string): Promise<VerificationResult> {
  try {
    // Validate input
    validatePinFormat(pinNumber);
    
    // Make API call
    const response = await apiClient.post('/verify-pin', { pin: pinNumber });
    
    // Return result
    return mapToVerificationResult(response.data);
    
  } catch (error) {
    // Log error with context
    logger.error('PIN verification failed', {
      pin: maskPin(pinNumber),
      error: error.message,
      stack: error.stack
    });
    
    // Re-throw with appropriate error type
    if (error instanceof ValidationError) {
      throw new InvalidPinFormatError(error.message);
    }
    if (error.response?.status === 401) {
      throw new ApiAuthenticationError('Invalid API key');
    }
    if (error.code === 'ETIMEDOUT') {
      throw new ApiTimeoutError('Request timed out');
    }
    
    // Generic error for unknown cases
    throw new KraConnectError('PIN verification failed', { cause: error });
  }
}
```

---

## 📦 Code Organization

### Single Responsibility Principle

```typescript
// ❌ Bad - class doing too much
class KraApiClient {
  verifyPin() {}
  verifyTcc() {}
  fileNilReturn() {}
  authenticate() {}
  retryRequest() {}
  cacheResponse() {}
  logRequest() {}
}

// ✅ Good - separate concerns
class KraApiClient {
  constructor(
    private auth: AuthenticationManager,
    private cache: CacheManager,
    private logger: Logger,
    private retryHandler: RetryHandler
  ) {}
  
  async verifyPin(pin: string): Promise<VerificationResult> {
    const request = this.buildRequest('/verify-pin', { pin });
    return this.retryHandler.execute(() => this.sendRequest(request));
  }
}

class AuthenticationManager {
  authenticate() {}
  refreshToken() {}
}

class CacheManager {
  get() {}
  set() {}
  invalidate() {}
}
```

### Dependency Injection

```python
# Good - dependencies injected
class PinVerificationService:
    def __init__(
        self,
        api_client: ApiClient,
        cache: CacheManager,
        logger: Logger
    ):
        self.api_client = api_client
        self.cache = cache
        self.logger = logger
    
    def verify(self, pin: str) -> VerificationResult:
        # Use injected dependencies
        cached = self.cache.get(f"pin:{pin}")
        if cached:
            self.logger.info(f"Returning cached result for PIN: {mask_pin(pin)}")
            return cached
        
        result = self.api_client.verify_pin(pin)
        self.cache.set(f"pin:{pin}", result, ttl=3600)
        return result

# Bad - hard dependencies
class PinVerificationService:
    def __init__(self, api_key: str):
        self.api_client = ApiClient(api_key)  # Hard dependency
        self.cache = RedisCache()              # Hard dependency
        self.logger = ConsoleLogger()          # Hard dependency
```

---

## 🚀 Performance Guidelines

### Use Async/Await for I/O Operations

```typescript
// ✅ Good - async operations
async function verifyMultiplePins(pins: string[]): Promise<VerificationResult[]> {
  const promises = pins.map(pin => verifyPin(pin));
  return Promise.all(promises);
}

// ❌ Bad - synchronous loop
function verifyMultiplePins(pins: string[]): VerificationResult[] {
  const results = [];
  for (const pin of pins) {
    results.push(verifyPinSync(pin)); // Blocks on each call
  }
  return results;
}
```

### Implement Caching

```python
from functools import lru_cache
from datetime import datetime, timedelta

class VerificationService:
    def __init__(self):
        self.cache = {}
        self.cache_ttl = timedelta(hours=1)
    
    def verify_pin(self, pin: str) -> VerificationResult:
        """Verify PIN with caching."""
        cache_key = f"pin:{pin}"
        
        # Check cache
        if cache_key in self.cache:
            cached_result, cached_time = self.cache[cache_key]
            if datetime.now() - cached_time < self.cache_ttl:
                return cached_result
        
        # Make API call
        result = self._api_verify_pin(pin)
        
        # Store in cache
        self.cache[cache_key] = (result, datetime.now())
        
        return result
```

### Batch Operations

```typescript
// ✅ Good - batch API call
async function verifyPinsBatch(pins: string[]): Promise<VerificationResult[]> {
  const response = await apiClient.post('/verify-pins-batch', { pins });
  return response.data.results;
}

// ❌ Bad - individual API calls
async function verifyPins(pins: string[]): Promise<VerificationResult[]> {
  const results = [];
  for (const pin of pins) {
    const result = await apiClient.post('/verify-pin', { pin });
    results.push(result.data);
  }
  return results;
}
```

---

## 📊 Logging Guidelines

### Use Structured Logging

```typescript
// ✅ Good - structured logging
logger.info('PIN verification started', {
  pin: maskPin(pinNumber),
  userId: user.id,
  timestamp: new Date().toISOString(),
  requestId: context.requestId
});

logger.error('PIN verification failed', {
  pin: maskPin(pinNumber),
  error: error.message,
  errorCode: error.code,
  stack: error.stack,
  requestId: context.requestId
});

// ❌ Bad - string concatenation
console.log('PIN verification started for ' + pinNumber);
console.log('Error: ' + error.message);
```

### Log Levels

```python
# DEBUG: Detailed information for debugging
logger.debug(f"Making API request to {endpoint} with params {params}")

# INFO: General information about application flow
logger.info(f"PIN verified successfully: {mask_pin(pin)}")

# WARNING: Something unexpected but not critical
logger.warning(f"Rate limit approaching: {current_usage}/{limit}")

# ERROR: Error that prevented operation from completing
logger.error(f"PIN verification failed: {error}", exc_info=True)

# CRITICAL: Serious error that may cause application failure
logger.critical(f"Database connection lost", exc_info=True)
```

---

## 🔄 Version Control

### Commit Messages

```bash
# ✅ Good commit messages
feat(sdk): add batch PIN verification support
fix(api): handle timeout errors in TCC verification
docs(readme): update installation instructions
test(pin-verifier): add tests for edge cases
refactor(auth): simplify token refresh logic

# ❌ Bad commit messages
update code
fix bug
changes
WIP
```

### Branch Naming

```bash
# ✅ Good branch names
feature/batch-verification
fix/authentication-timeout
docs/api-reference
refactor/error-handling

# ❌ Bad branch names
updates
john-branch
temp
fix
```

---

## ✅ Code Review Checklist

Before submitting code for review, ensure:

- [ ] Code follows naming conventions
- [ ] All functions/classes are documented
- [ ] Tests are written and passing (80%+ coverage)
- [ ] No hardcoded secrets or API keys
- [ ] Error handling is implemented
- [ ] Input validation is present
- [ ] Logging is added for important operations
- [ ] README.md is updated if needed
- [ ] Breaking changes are documented
- [ ] Performance considerations addressed
- [ ] Security best practices followed
- [ ] Code is formatted (prettier/black/gofmt)
- [ ] No console.log/print statements in production code
- [ ] TypeScript types are properly defined (no `any`)

---

## 🎓 Learning Resources

### When to Ask AI for Help

**Good scenarios:**
- "Generate boilerplate code for a new service class"
- "Write unit tests for this function"
- "Document this API endpoint"
- "Review this code for security issues"
- "Suggest performance improvements"

**Bad scenarios:**
- "Write the entire authentication system" (too broad)
- "Make this work" (no context)
- "Fix all bugs" (be specific)

### Prompt Engineering for Code

```
Good prompt:
"Create a TypeScript service class for KRA PIN verification with the following:
- Method: verifyPin(pin: string): Promise<VerificationResult>
- Include retry logic (3 attempts with exponential backoff)
- Add input validation for PIN format (P + 9 digits + letter)
- Include comprehensive JSDoc comments
- Add error handling for API failures
- Follow the patterns in our existing AuthService class"

Bad prompt:
"Write a PIN verification thing"
```

---

## 📞 Getting Help

If you're unsure about any of these guidelines:

1. Check existing code for patterns
2. Review similar implementations in other SDKs
3. Ask in the team Discord/Slack
4. Consult the technical lead
5. Document your decision in comments

---

## 🔄 Updating These Guidelines

These guidelines are living documents. If you find:
- A better pattern or practice
- Ambiguity that needs clarification
- New tools or frameworks to add
- Outdated recommendations

Create a pull request to update this document with:
- Clear explanation of the change
- Examples demonstrating the improvement
- Links to relevant documentation

---

**Remember: Code is read 10x more than it's written. Write for the reader, not the compiler.**