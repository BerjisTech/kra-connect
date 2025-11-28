# KRA-Connect SDK - Complete User Guide

A comprehensive guide for developers using KRA-Connect SDKs to integrate with Kenya Revenue Authority's GavaConnect API.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Choosing an SDK](#choosing-an-sdk)
  - [Getting API Credentials](#getting-api-credentials)
- [Python SDK Guide](#python-sdk-guide)
- [Node.js SDK Guide](#nodejs-sdk-guide)
- [PHP SDK Guide](#php-sdk-guide)
- [Go SDK Guide](#go-sdk-guide)
- [Flutter/Dart SDK Guide](#flutterdart-sdk-guide)
- [Common Use Cases](#common-use-cases)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## Overview

KRA-Connect provides official SDKs in multiple languages for integrating with the Kenya Revenue Authority's GavaConnect API. All SDKs provide:

- ✅ PIN Verification
- ✅ TCC (Tax Compliance Certificate) Verification
- ✅ E-slip Validation
- ✅ NIL Return Filing
- ✅ Taxpayer Details Retrieval
- ✅ Batch Operations
- ✅ Automatic Retry Logic
- ✅ Response Caching
- ✅ Rate Limiting
- ✅ Comprehensive Error Handling

---

## Getting Started

### Choosing an SDK

Select the SDK that matches your application's technology stack:

| SDK | Best For | Installation |
|-----|----------|--------------|
| **Python** | Django, Flask, FastAPI apps | `pip install kra-connect` |
| **Node.js** | Express, NestJS, Next.js apps | `npm install @kra-connect/node` |
| **PHP** | Laravel, Symfony apps | `composer require kra-connect/php-sdk` |
| **Go** | High-performance servers | `go get github.com/kra-connect/go-sdk` |
| **Flutter** | Mobile & cross-platform apps | `flutter pub add kra_connect` |

### Getting API Credentials

1. **Register with KRA GavaConnect**
   - Visit: https://api.kra.go.ke/gavaconnect
   - Create a developer account
   - Submit API access request

2. **Obtain API Key**
   - Log in to GavaConnect Developer Portal
   - Navigate to "API Keys"
   - Generate new API key
   - **Important**: Store securely, never commit to version control

3. **Environment Setup**
   ```bash
   # Create .env file (never commit this file)
   KRA_API_KEY=your-api-key-here
   KRA_API_URL=https://api.kra.go.ke/gavaconnect/v1
   ```

---

## Python SDK Guide

### Installation

```bash
pip install kra-connect
```

### Quick Start

```python
import os
from kra_connect import KraClient

# Initialize client
client = KraClient(
    api_key=os.getenv('KRA_API_KEY')
)

# Verify a PIN
try:
    result = client.verify_pin('P051234567A')
    if result.is_valid:
        print(f'Valid PIN: {result.taxpayer_name}')
        print(f'Status: {result.status}')
except Exception as e:
    print(f'Error: {e}')
finally:
    client.close()
```

### Configuration

```python
from kra_connect import KraClient, KraConfig

config = KraConfig(
    base_url='https://api.kra.go.ke/gavaconnect/v1',
    timeout=30,
    max_retries=3,
    initial_retry_delay=1,
    max_retry_delay=32,
    enable_cache=True,
    pin_verification_ttl=3600,  # 1 hour
    enable_rate_limit=True,
    max_requests_per_minute=100,
    debug_mode=False,
)

client = KraClient(
    api_key=os.getenv('KRA_API_KEY'),
    config=config
)
```

### All Operations

```python
# 1. PIN Verification
result = client.verify_pin('P051234567A')
print(f'Valid: {result.is_valid}')
print(f'Name: {result.taxpayer_name}')
print(f'Active: {result.is_active()}')

# 2. TCC Verification
result = client.verify_tcc('TCC123456')
print(f'Valid: {result.is_currently_valid()}')
print(f'Days until expiry: {result.days_until_expiry()}')
print(f'Expiring soon: {result.is_expiring_soon(30)}')

# 3. E-slip Validation
result = client.validate_eslip('1234567890')
print(f'Paid: {result.is_paid()}')
print(f'Amount: {result.amount} {result.currency}')

# 4. NIL Return Filing
from kra_connect import NILReturnRequest

request = NILReturnRequest(
    pin_number='P051234567A',
    obligation_id='OBL123456',
    period='202401'
)
result = client.file_nil_return(request)
print(f'Accepted: {result.is_accepted()}')
print(f'Reference: {result.reference_number}')

# 5. Taxpayer Details
details = client.get_taxpayer_details('P051234567A')
print(f'Name: {details.get_display_name()}')
print(f'Obligations: {len(details.obligations)}')
for obligation in details.obligations:
    if obligation.is_filing_overdue():
        print(f'Overdue: {obligation.description}')

# 6. Batch Operations
pins = ['P051234567A', 'P051234567B', 'P051234567C']
results = client.verify_pins_batch(pins)
for result in results:
    print(f'{result.pin_number}: {result.is_valid}')
```

### Error Handling

```python
from kra_connect import (
    ValidationError,
    AuthenticationError,
    RateLimitError,
    TimeoutError,
    APIError,
    KraException
)

try:
    result = client.verify_pin('P051234567A')
except ValidationError as e:
    print(f'Invalid input: {e.message}')
    print(f'Field: {e.field}')
except AuthenticationError as e:
    print(f'Auth failed: {e.message}')
except RateLimitError as e:
    print(f'Rate limited. Retry after {e.retry_after} seconds')
except TimeoutError as e:
    print(f'Request timed out: {e.message}')
except APIError as e:
    print(f'API error ({e.status_code}): {e.message}')
except KraException as e:
    print(f'KRA error: {e.message}')
```

### Framework Integration

#### Django

```python
# settings.py
KRA_API_KEY = os.getenv('KRA_API_KEY')

# services.py
from kra_connect import KraClient
from django.conf import settings

class KRAService:
    _client = None

    @classmethod
    def get_client(cls):
        if cls._client is None:
            cls._client = KraClient(api_key=settings.KRA_API_KEY)
        return cls._client

# views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from .services import KRAService

class VerifyPINView(APIView):
    def post(self, request):
        pin = request.data.get('pin')
        try:
            result = KRAService.get_client().verify_pin(pin)
            return Response({
                'valid': result.is_valid,
                'taxpayer_name': result.taxpayer_name,
                'status': result.status
            })
        except Exception as e:
            return Response({'error': str(e)}, status=400)
```

#### Flask

```python
from flask import Flask, request, jsonify
from kra_connect import KraClient
import os

app = Flask(__name__)
kra_client = KraClient(api_key=os.getenv('KRA_API_KEY'))

@app.route('/verify-pin', methods=['POST'])
def verify_pin():
    pin = request.json.get('pin')
    try:
        result = kra_client.verify_pin(pin)
        return jsonify({
            'valid': result.is_valid,
            'taxpayer_name': result.taxpayer_name,
            'status': result.status
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.teardown_appcontext
def shutdown_session(exception=None):
    kra_client.close()
```

---

## Node.js SDK Guide

### Installation

```bash
npm install @kra-connect/node
# or
yarn add @kra-connect/node
```

### Quick Start

```javascript
import { KraClient } from '@kra-connect/node';
// or
const { KraClient } = require('@kra-connect/node');

// Initialize client
const client = new KraClient({
  apiKey: process.env.KRA_API_KEY
});

// Verify a PIN
async function verifyPin() {
  try {
    const result = await client.verifyPin('P051234567A');
    if (result.isValid) {
      console.log(`Valid PIN: ${result.taxpayerName}`);
      console.log(`Status: ${result.status}`);
    }
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await client.close();
  }
}

verifyPin();
```

### Configuration

```javascript
import { KraClient, KraConfig } from '@kra-connect/node';

const config = new KraConfig({
  baseUrl: 'https://api.kra.go.ke/gavaconnect/v1',
  timeout: 30000,
  maxRetries: 3,
  initialRetryDelay: 1000,
  maxRetryDelay: 32000,
  enableCache: true,
  pinVerificationTtl: 3600000,
  enableRateLimit: true,
  maxRequestsPerMinute: 100,
  debugMode: false,
});

const client = new KraClient({
  apiKey: process.env.KRA_API_KEY,
  config
});
```

### All Operations

```javascript
// 1. PIN Verification
const result = await client.verifyPin('P051234567A');
console.log(`Valid: ${result.isValid}`);
console.log(`Name: ${result.taxpayerName}`);
console.log(`Active: ${result.isActive()}`);

// 2. TCC Verification
const result = await client.verifyTcc('TCC123456');
console.log(`Valid: ${result.isCurrentlyValid()}`);
console.log(`Days until expiry: ${result.daysUntilExpiry()}`);
console.log(`Expiring soon: ${result.isExpiringSoon(30)}`);

// 3. E-slip Validation
const result = await client.validateEslip('1234567890');
console.log(`Paid: ${result.isPaid()}`);
console.log(`Amount: ${result.currency} ${result.amount}`);

// 4. NIL Return Filing
const result = await client.fileNilReturn({
  pinNumber: 'P051234567A',
  obligationId: 'OBL123456',
  period: '202401'
});
console.log(`Accepted: ${result.isAccepted()}`);
console.log(`Reference: ${result.referenceNumber}`);

// 5. Taxpayer Details
const details = await client.getTaxpayerDetails('P051234567A');
console.log(`Name: ${details.getDisplayName()}`);
console.log(`Obligations: ${details.obligations.length}`);
for (const obligation of details.obligations) {
  if (obligation.isFilingOverdue()) {
    console.log(`Overdue: ${obligation.description}`);
  }
}

// 6. Batch Operations
const pins = ['P051234567A', 'P051234567B', 'P051234567C'];
const results = await client.verifyPinsBatch(pins);
results.forEach(result => {
  console.log(`${result.pinNumber}: ${result.isValid}`);
});
```

### Error Handling

```javascript
import {
  ValidationError,
  AuthenticationError,
  RateLimitError,
  TimeoutError,
  APIError,
  KraError
} from '@kra-connect/node';

try {
  const result = await client.verifyPin('P051234567A');
} catch (error) {
  if (error instanceof ValidationError) {
    console.error(`Invalid input: ${error.message}`);
    console.error(`Field: ${error.field}`);
  } else if (error instanceof AuthenticationError) {
    console.error(`Auth failed: ${error.message}`);
  } else if (error instanceof RateLimitError) {
    console.error(`Rate limited. Retry after ${error.retryAfter}ms`);
  } else if (error instanceof TimeoutError) {
    console.error(`Request timed out: ${error.message}`);
  } else if (error instanceof APIError) {
    console.error(`API error (${error.statusCode}): ${error.message}`);
  } else if (error instanceof KraError) {
    console.error(`KRA error: ${error.message}`);
  }
}
```

### Framework Integration

#### Express

```javascript
import express from 'express';
import { KraClient } from '@kra-connect/node';

const app = express();
const kraClient = new KraClient({
  apiKey: process.env.KRA_API_KEY
});

app.use(express.json());

app.post('/verify-pin', async (req, res) => {
  const { pin } = req.body;

  try {
    const result = await kraClient.verifyPin(pin);
    res.json({
      valid: result.isValid,
      taxpayerName: result.taxpayerName,
      status: result.status
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

process.on('SIGTERM', async () => {
  await kraClient.close();
  process.exit(0);
});

app.listen(3000);
```

#### NestJS

```typescript
// kra.module.ts
import { Module } from '@nestjs/common';
import { KraService } from './kra.service';

@Module({
  providers: [KraService],
  exports: [KraService],
})
export class KraModule {}

// kra.service.ts
import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { KraClient } from '@kra-connect/node';

@Injectable()
export class KraService implements OnModuleDestroy {
  private client: KraClient;

  constructor() {
    this.client = new KraClient({
      apiKey: process.env.KRA_API_KEY,
    });
  }

  async verifyPin(pin: string) {
    return this.client.verifyPin(pin);
  }

  async onModuleDestroy() {
    await this.client.close();
  }
}

// verification.controller.ts
import { Controller, Post, Body } from '@nestjs/common';
import { KraService } from './kra.service';

@Controller('verification')
export class VerificationController {
  constructor(private readonly kraService: KraService) {}

  @Post('pin')
  async verifyPin(@Body('pin') pin: string) {
    return this.kraService.verifyPin(pin);
  }
}
```

---

## PHP SDK Guide

### Installation

```bash
composer require kra-connect/php-sdk
```

### Quick Start

```php
<?php
require 'vendor/autoload.php';

use KraConnect\KraClient;

// Initialize client
$client = new KraClient($_ENV['KRA_API_KEY']);

// Verify a PIN
try {
    $result = $client->verifyPin('P051234567A');

    if ($result->isValid) {
        echo "Valid PIN: {$result->taxpayerName}\n";
        echo "Status: {$result->status}\n";
    }
} catch (Exception $e) {
    echo "Error: {$e->getMessage()}\n";
}
```

### Configuration

```php
use KraConnect\KraClient;
use KraConnect\Config\KraConfig;
use KraConnect\Config\RetryConfig;
use KraConnect\Config\CacheConfig;
use KraConnect\Config\RateLimitConfig;

$config = new KraConfig(
    apiKey: $_ENV['KRA_API_KEY'],
    baseUrl: 'https://api.kra.go.ke/gavaconnect/v1',
    timeout: 30.0,
    retryConfig: new RetryConfig(
        maxRetries: 3,
        initialDelay: 1,
        maxDelay: 32
    ),
    cacheConfig: new CacheConfig(
        enabled: true,
        pinVerificationTtl: 3600
    ),
    rateLimitConfig: new RateLimitConfig(
        enabled: true,
        maxRequests: 100,
        windowSeconds: 60
    ),
    debugMode: false
);

$client = new KraClient($config->apiKey, $config);
```

### All Operations

```php
// 1. PIN Verification
$result = $client->verifyPin('P051234567A');
echo "Valid: " . ($result->isValid ? 'Yes' : 'No') . "\n";
echo "Name: {$result->taxpayerName}\n";
echo "Active: " . ($result->isActive() ? 'Yes' : 'No') . "\n";

// 2. TCC Verification
$result = $client->verifyTcc('TCC123456');
echo "Valid: " . ($result->isCurrentlyValid() ? 'Yes' : 'No') . "\n";
echo "Days until expiry: {$result->daysUntilExpiry()}\n";
echo "Expiring soon: " . ($result->isExpiringSoon(30) ? 'Yes' : 'No') . "\n";

// 3. E-slip Validation
$result = $client->validateEslip('1234567890');
echo "Paid: " . ($result->isPaid() ? 'Yes' : 'No') . "\n";
echo "Amount: {$result->currency} {$result->amount}\n";

// 4. NIL Return Filing
use KraConnect\Models\NilReturnRequest;

$request = new NilReturnRequest(
    pinNumber: 'P051234567A',
    obligationId: 'OBL123456',
    period: '202401'
);
$result = $client->fileNilReturn($request);
echo "Accepted: " . ($result->isAccepted() ? 'Yes' : 'No') . "\n";
echo "Reference: {$result->referenceNumber}\n";

// 5. Taxpayer Details
$details = $client->getTaxpayerDetails('P051234567A');
echo "Name: {$details->getDisplayName()}\n";
echo "Obligations: " . count($details->obligations) . "\n";
foreach ($details->obligations as $obligation) {
    if ($obligation->isFilingOverdue()) {
        echo "Overdue: {$obligation->description}\n";
    }
}

// 6. Batch Operations
$pins = ['P051234567A', 'P051234567B', 'P051234567C'];
$results = $client->verifyPinsBatch($pins);
foreach ($results as $result) {
    echo "{$result->pinNumber}: " . ($result->isValid ? 'Valid' : 'Invalid') . "\n";
}
```

### Error Handling

```php
use KraConnect\Exceptions\ValidationException;
use KraConnect\Exceptions\AuthenticationException;
use KraConnect\Exceptions\RateLimitExceededException;
use KraConnect\Exceptions\TimeoutException;
use KraConnect\Exceptions\ApiException;
use KraConnect\Exceptions\KraConnectException;

try {
    $result = $client->verifyPin('P051234567A');
} catch (ValidationException $e) {
    echo "Invalid input: {$e->getMessage()}\n";
    echo "Field: {$e->getField()}\n";
} catch (AuthenticationException $e) {
    echo "Auth failed: {$e->getMessage()}\n";
} catch (RateLimitExceededException $e) {
    echo "Rate limited. Retry after {$e->getRetryAfter()} seconds\n";
} catch (TimeoutException $e) {
    echo "Request timed out: {$e->getMessage()}\n";
} catch (ApiException $e) {
    echo "API error ({$e->getStatusCode()}): {$e->getMessage()}\n";
} catch (KraConnectException $e) {
    echo "KRA error: {$e->getMessage()}\n";
}
```

### Framework Integration

#### Laravel

```bash
php artisan vendor:publish --provider="KraConnect\Laravel\KraConnectServiceProvider"
```

```php
// config/kra-connect.php (published)
return [
    'api_key' => env('KRA_API_KEY'),
    'base_url' => env('KRA_API_URL', 'https://api.kra.go.ke/gavaconnect/v1'),
    'timeout' => 30,
    'enable_cache' => true,
    // ... more configuration
];

// Using Facade
use KraConnect;

Route::post('/verify-pin', function (Request $request) {
    $pin = $request->input('pin');

    try {
        $result = KraConnect::verifyPin($pin);
        return response()->json([
            'valid' => $result->isValid,
            'taxpayer_name' => $result->taxpayerName,
            'status' => $result->status
        ]);
    } catch (Exception $e) {
        return response()->json(['error' => $e->getMessage()], 400);
    }
});

// Using Dependency Injection
use KraConnect\KraClient;

class VerificationController extends Controller
{
    public function __construct(private KraClient $kraClient)
    {
    }

    public function verifyPin(Request $request)
    {
        $pin = $request->input('pin');
        $result = $this->kraClient->verifyPin($pin);

        return response()->json([
            'valid' => $result->isValid,
            'taxpayer_name' => $result->taxpayerName,
        ]);
    }
}
```

#### Symfony

```yaml
# config/packages/kra_connect.yaml
kra_connect:
  api_key: '%env(KRA_API_KEY)%'
  base_url: 'https://api.kra.go.ke/gavaconnect/v1'
  timeout: 30
  enable_cache: true
```

```php
// src/Controller/VerificationController.php
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use KraConnect\KraClient;

class VerificationController extends AbstractController
{
    public function __construct(private KraClient $kraClient)
    {
    }

    #[Route('/verify-pin', methods: ['POST'])]
    public function verifyPin(Request $request): JsonResponse
    {
        $pin = $request->request->get('pin');

        try {
            $result = $this->kraClient->verifyPin($pin);
            return $this->json([
                'valid' => $result->isValid,
                'taxpayer_name' => $result->taxpayerName,
            ]);
        } catch (\Exception $e) {
            return $this->json(['error' => $e->getMessage()], 400);
        }
    }
}
```

---

## Go SDK Guide

### Installation

```bash
go get github.com/kra-connect/go-sdk
```

### Quick Start

```go
package main

import (
    "context"
    "fmt"
    "log"
    "os"

    kra "github.com/kra-connect/go-sdk"
)

func main() {
    // Initialize client
    client, err := kra.NewClient(
        kra.WithAPIKey(os.Getenv("KRA_API_KEY")),
    )
    if err != nil {
        log.Fatal(err)
    }
    defer client.Close()

    // Verify a PIN
    ctx := context.Background()
    result, err := client.VerifyPIN(ctx, "P051234567A")
    if err != nil {
        log.Fatal(err)
    }

    if result.IsValid {
        fmt.Printf("Valid PIN: %s\n", result.TaxpayerName)
        fmt.Printf("Status: %s\n", result.Status)
    }
}
```

### Configuration

```go
import (
    "time"
    kra "github.com/kra-connect/go-sdk"
)

client, err := kra.NewClient(
    kra.WithAPIKey(os.Getenv("KRA_API_KEY")),
    kra.WithBaseURL("https://api.kra.go.ke/gavaconnect/v1"),
    kra.WithTimeout(30 * time.Second),
    kra.WithRetry(3, time.Second, 32*time.Second),
    kra.WithRateLimit(100, time.Minute),
    kra.WithCache(true, time.Hour),
    kra.WithDebug(true),
)
if err != nil {
    log.Fatal(err)
}
defer client.Close()
```

### All Operations

```go
ctx := context.Background()

// 1. PIN Verification
result, err := client.VerifyPIN(ctx, "P051234567A")
if err != nil {
    log.Fatal(err)
}
fmt.Printf("Valid: %v\n", result.IsValid)
fmt.Printf("Name: %s\n", result.TaxpayerName)
fmt.Printf("Active: %v\n", result.IsActive())

// 2. TCC Verification
result, err := client.VerifyTCC(ctx, "TCC123456")
if err != nil {
    log.Fatal(err)
}
fmt.Printf("Valid: %v\n", result.IsCurrentlyValid())
fmt.Printf("Days until expiry: %d\n", result.DaysUntilExpiry())
fmt.Printf("Expiring soon: %v\n", result.IsExpiringSoon(30))

// 3. E-slip Validation
result, err := client.ValidateEslip(ctx, "1234567890")
if err != nil {
    log.Fatal(err)
}
fmt.Printf("Paid: %v\n", result.IsPaid())
fmt.Printf("Amount: %s %.2f\n", result.Currency, result.Amount)

// 4. NIL Return Filing
result, err := client.FileNILReturn(ctx, &kra.NILReturnRequest{
    PINNumber:    "P051234567A",
    ObligationID: "OBL123456",
    Period:       "202401",
})
if err != nil {
    log.Fatal(err)
}
fmt.Printf("Accepted: %v\n", result.IsAccepted())
fmt.Printf("Reference: %s\n", result.ReferenceNumber)

// 5. Taxpayer Details
details, err := client.GetTaxpayerDetails(ctx, "P051234567A")
if err != nil {
    log.Fatal(err)
}
fmt.Printf("Name: %s\n", details.GetDisplayName())
fmt.Printf("Obligations: %d\n", len(details.Obligations))
for _, obligation := range details.Obligations {
    if obligation.IsFilingOverdue() {
        fmt.Printf("Overdue: %s\n", obligation.Description)
    }
}

// 6. Batch Operations
pins := []string{"P051234567A", "P051234567B", "P051234567C"}
results, err := client.VerifyPINsBatch(ctx, pins)
if err != nil {
    log.Fatal(err)
}
for _, result := range results {
    fmt.Printf("%s: %v\n", result.PINNumber, result.IsValid)
}
```

### Error Handling

```go
result, err := client.VerifyPIN(ctx, "P051234567A")
if err != nil {
    switch e := err.(type) {
    case *kra.ValidationError:
        fmt.Printf("Invalid input: %s\n", e.Message)
        fmt.Printf("Field: %s\n", e.Field)
    case *kra.AuthenticationError:
        fmt.Printf("Auth failed: %s\n", e.Message)
    case *kra.RateLimitError:
        fmt.Printf("Rate limited. Retry after: %v\n", e.RetryAfter)
    case *kra.TimeoutError:
        fmt.Printf("Request timed out: %s\n", e.Message)
    case *kra.APIError:
        fmt.Printf("API error (%d): %s\n", e.StatusCode, e.Message)
    default:
        fmt.Printf("Error: %v\n", err)
    }
    return
}
```

### Context Usage

```go
// With timeout
ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
defer cancel()

result, err := client.VerifyPIN(ctx, "P051234567A")

// With cancellation
ctx, cancel := context.WithCancel(context.Background())
go func() {
    time.Sleep(5 * time.Second)
    cancel()
}()

result, err := client.VerifyPIN(ctx, "P051234567A")
if err == context.Canceled {
    fmt.Println("Request was cancelled")
}
```

---

## Flutter/Dart SDK Guide

### Installation

```yaml
# pubspec.yaml
dependencies:
  kra_connect: ^0.1.0
```

```bash
flutter pub get
```

### Quick Start

```dart
import 'package:kra_connect/kra_connect.dart';

void main() async {
  // Initialize client
  final client = KraClient(
    apiKey: 'your-api-key-here',
  );

  try {
    // Verify a PIN
    final result = await client.verifyPin('P051234567A');

    if (result.isValid) {
      print('Valid PIN: ${result.taxpayerName}');
      print('Status: ${result.status}');
    }
  } on KraException catch (e) {
    print('Error: ${e.message}');
  } finally {
    client.dispose();
  }
}
```

### Configuration

```dart
import 'package:kra_connect/kra_connect.dart';

final client = KraClient(
  apiKey: 'your-api-key',
  config: KraConfig(
    baseUrl: 'https://api.kra.go.ke/gavaconnect/v1',
    timeout: Duration(seconds: 30),
    maxRetries: 3,
    initialRetryDelay: Duration(seconds: 1),
    maxRetryDelay: Duration(seconds: 32),
    enableCache: true,
    pinVerificationTtl: Duration(hours: 1),
    enableRateLimit: true,
    maxRequestsPerMinute: 100,
    debugMode: false,
  ),
);
```

### All Operations

```dart
// 1. PIN Verification
final result = await client.verifyPin('P051234567A');
print('Valid: ${result.isValid}');
print('Name: ${result.taxpayerName}');
print('Active: ${result.isActive}');

// 2. TCC Verification
final result = await client.verifyTcc('TCC123456');
print('Valid: ${result.isCurrentlyValid}');
print('Days until expiry: ${result.daysUntilExpiry}');
print('Expiring soon: ${result.isExpiringSoon(30)}');

// 3. E-slip Validation
final result = await client.validateEslip('1234567890');
print('Paid: ${result.isPaid}');
print('Amount: ${result.currency} ${result.amount}');

// 4. NIL Return Filing
final result = await client.fileNilReturn(
  NilReturnRequest(
    pinNumber: 'P051234567A',
    obligationId: 'OBL123456',
    period: '202401',
  ),
);
print('Accepted: ${result.isAccepted}');
print('Reference: ${result.referenceNumber}');

// 5. Taxpayer Details
final details = await client.getTaxpayerDetails('P051234567A');
print('Name: ${details.displayName}');
print('Obligations: ${details.obligations.length}');
for (final obligation in details.obligations) {
  if (obligation.isFilingOverdue) {
    print('Overdue: ${obligation.description}');
  }
}

// 6. Batch Operations
final pins = ['P051234567A', 'P051234567B', 'P051234567C'];
final results = await client.verifyPinsBatch(pins);
for (final result in results) {
  print('${result.pinNumber}: ${result.isValid}');
}
```

### Error Handling

```dart
try {
  final result = await client.verifyPin('P051234567A');
} on ValidationException catch (e) {
  print('Invalid input: ${e.message}');
  print('Field: ${e.field}');
} on AuthenticationException catch (e) {
  print('Auth failed: ${e.message}');
} on RateLimitException catch (e) {
  print('Rate limited. Retry after: ${e.retryAfter}');
} on TimeoutException catch (e) {
  print('Request timed out: ${e.message}');
} on ApiException catch (e) {
  print('API error (${e.statusCode}): ${e.message}');
} on KraException catch (e) {
  print('KRA error: ${e.message}');
}
```

### Flutter Widget Integration

```dart
class PinVerificationScreen extends StatefulWidget {
  @override
  _PinVerificationScreenState createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final _client = KraClient(apiKey: 'your-api-key');
  final _pinController = TextEditingController();
  PinVerificationResult? _result;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _client.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await _client.verifyPin(_pinController.text);
      setState(() {
        _result = result;
        _loading = false;
      });
    } on KraException catch (e) {
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PIN Verification')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: 'KRA PIN',
                hintText: 'P051234567A',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _verifyPin,
              child: _loading
                  ? CircularProgressIndicator()
                  : Text('Verify PIN'),
            ),
            if (_result != null) ...[
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: Text(_result!.taxpayerName ?? 'Unknown'),
                  subtitle: Text('Status: ${_result!.status}'),
                  leading: Icon(
                    _result!.isValid ? Icons.check_circle : Icons.error,
                    color: _result!.isValid ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
            if (_error != null) ...[
              SizedBox(height: 16),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## Common Use Cases

### Use Case 1: Supplier Verification Before Purchase Order

Verify supplier's PIN and TCC before creating a purchase order.

**Python:**
```python
def verify_supplier(pin: str, tcc: str) -> dict:
    """Verify supplier credentials."""
    client = KraClient(api_key=os.getenv('KRA_API_KEY'))

    try:
        # Verify PIN
        pin_result = client.verify_pin(pin)
        if not pin_result.is_active():
            return {'valid': False, 'reason': 'PIN not active'}

        # Verify TCC
        tcc_result = client.verify_tcc(tcc)
        if not tcc_result.is_currently_valid():
            return {'valid': False, 'reason': 'TCC invalid or expired'}

        # Check if TCC is expiring soon
        if tcc_result.is_expiring_soon(30):
            return {
                'valid': True,
                'warning': f'TCC expires in {tcc_result.days_until_expiry()} days'
            }

        return {'valid': True}
    finally:
        client.close()

# Usage
result = verify_supplier('P051234567A', 'TCC123456')
if result['valid']:
    # Create purchase order
    pass
else:
    # Reject supplier
    print(f"Supplier verification failed: {result['reason']}")
```

### Use Case 2: Batch Employee PIN Verification

Verify multiple employee PINs during onboarding.

**Node.js:**
```javascript
async function verifyEmployees(employees) {
  const client = new KraClient({
    apiKey: process.env.KRA_API_KEY
  });

  try {
    const pins = employees.map(emp => emp.pin);
    const results = await client.verifyPinsBatch(pins);

    const verifiedEmployees = employees.map((emp, index) => ({
      ...emp,
      pinVerified: results[index].isValid,
      taxpayerName: results[index].taxpayerName,
      verificationDate: results[index].verifiedAt
    }));

    const invalid = verifiedEmployees.filter(emp => !emp.pinVerified);
    if (invalid.length > 0) {
      console.log(`${invalid.length} employees have invalid PINs`);
    }

    return verifiedEmployees;
  } finally {
    await client.close();
  }
}

// Usage
const employees = [
  { name: 'John Doe', pin: 'P051234567A' },
  { name: 'Jane Smith', pin: 'P051234567B' },
];

const verified = await verifyEmployees(employees);
```

### Use Case 3: Automated NIL Return Filing

File NIL returns for all inactive obligations monthly.

**PHP:**
```php
function fileNilReturnsForInactiveObligations(string $pin, string $period): array
{
    $client = new KraClient($_ENV['KRA_API_KEY']);
    $results = [];

    try {
        // Get taxpayer details
        $details = $client->getTaxpayerDetails($pin);

        // Find obligations that need NIL returns
        foreach ($details->obligations as $obligation) {
            if (!$obligation->isActive && $obligation->requiresNilReturn) {
                $request = new NilReturnRequest(
                    pinNumber: $pin,
                    obligationId: $obligation->obligationId,
                    period: $period
                );

                try {
                    $result = $client->fileNilReturn($request);
                    $results[] = [
                        'obligation' => $obligation->description,
                        'success' => $result->isAccepted(),
                        'reference' => $result->referenceNumber
                    ];
                } catch (Exception $e) {
                    $results[] = [
                        'obligation' => $obligation->description,
                        'success' => false,
                        'error' => $e->getMessage()
                    ];
                }
            }
        }

        return $results;
    } finally {
        // Client cleanup is automatic in PHP
    }
}

// Usage
$results = fileNilReturnsForInactiveObligations('P051234567A', '202401');
foreach ($results as $result) {
    if ($result['success']) {
        echo "Filed NIL return for {$result['obligation']}: {$result['reference']}\n";
    } else {
        echo "Failed to file {$result['obligation']}: {$result['error']}\n";
    }
}
```

### Use Case 4: Real-time Compliance Dashboard

Monitor compliance status with caching and periodic updates.

**Go:**
```go
type ComplianceDashboard struct {
    client *kra.Client
    pins   []string
}

func (d *ComplianceDashboard) GetComplianceStatus(ctx context.Context) (map[string]interface{}, error) {
    // Verify PINs (cached for 1 hour)
    pinResults, err := d.client.VerifyPINsBatch(ctx, d.pins)
    if err != nil {
        return nil, err
    }

    stats := map[string]interface{}{
        "total":    len(pinResults),
        "valid":    0,
        "invalid":  0,
        "active":   0,
        "inactive": 0,
    }

    for _, result := range pinResults {
        if result.IsValid {
            stats["valid"] = stats["valid"].(int) + 1
            if result.IsActive() {
                stats["active"] = stats["active"].(int) + 1
            } else {
                stats["inactive"] = stats["inactive"].(int) + 1
            }
        } else {
            stats["invalid"] = stats["invalid"].(int) + 1
        }
    }

    return stats, nil
}

// Usage with periodic updates
func runDashboard() {
    client, _ := kra.NewClient(
        kra.WithAPIKey(os.Getenv("KRA_API_KEY")),
        kra.WithCache(true, time.Hour),
    )
    defer client.Close()

    dashboard := &ComplianceDashboard{
        client: client,
        pins:   []string{"P051234567A", "P051234567B", "P051234567C"},
    }

    ticker := time.NewTicker(15 * time.Minute)
    defer ticker.Stop()

    for {
        select {
        case <-ticker.C:
            ctx := context.Background()
            stats, err := dashboard.GetComplianceStatus(ctx)
            if err != nil {
                log.Printf("Error: %v", err)
                continue
            }
            log.Printf("Compliance Status: %+v", stats)
        }
    }
}
```

---

## Best Practices

### 1. **Security**

✅ **DO:**
- Store API keys in environment variables
- Use `.env` files (never commit them)
- Rotate API keys regularly
- Use HTTPS for all requests
- Enable 2FA on GavaConnect account

❌ **DON'T:**
- Hardcode API keys in code
- Commit `.env` files to Git
- Share API keys via email/Slack
- Expose API keys in client-side code

### 2. **Error Handling**

✅ **DO:**
- Always wrap API calls in try/catch
- Handle specific exception types
- Log errors with context
- Retry on transient failures
- Show user-friendly error messages

❌ **DON'T:**
- Swallow exceptions silently
- Expose internal error details to users
- Retry on non-retryable errors
- Use generic error messages

### 3. **Performance**

✅ **DO:**
- Use batch operations for multiple requests
- Enable caching for frequently accessed data
- Set appropriate timeout values
- Use connection pooling
- Monitor API usage

❌ **DON'T:**
- Make individual requests in loops
- Disable caching without reason
- Set very short timeout values
- Create new client instances per request
- Ignore rate limits

### 4. **Testing**

✅ **DO:**
- Test with sandbox/test environment first
- Mock API responses in unit tests
- Test error scenarios
- Validate input before API calls
- Test with edge cases

❌ **DON'T:**
- Test directly in production
- Skip error scenario testing
- Rely only on happy path tests
- Use real API keys in tests

### 5. **Monitoring**

✅ **DO:**
- Log all API requests (without sensitive data)
- Monitor error rates
- Track response times
- Set up alerts for failures
- Review usage patterns

❌ **DON'T:**
- Log API keys or PINs
- Ignore error spikes
- Skip performance monitoring
- Miss rate limit warnings

---

## Troubleshooting

### Problem: Authentication Failed

**Symptoms:**
- `AuthenticationError` / `401 Unauthorized`
- "Invalid API key" message

**Solutions:**
1. Check API key is correct
   ```bash
   echo $KRA_API_KEY
   ```
2. Verify API key is active on GavaConnect portal
3. Check for leading/trailing spaces in API key
4. Regenerate API key if necessary

### Problem: Rate Limit Exceeded

**Symptoms:**
- `RateLimitError` / `429 Too Many Requests`
- "Rate limit exceeded" message

**Solutions:**
1. Enable rate limiting in SDK config
   ```python
   config = KraConfig(enable_rate_limit=True, max_requests_per_minute=100)
   ```
2. Implement exponential backoff
3. Use batch operations instead of individual requests
4. Contact KRA for higher rate limits

### Problem: Request Timeout

**Symptoms:**
- `TimeoutError` / `408 Request Timeout`
- "Request timed out" message

**Solutions:**
1. Increase timeout value
   ```javascript
   const config = new KraConfig({ timeout: 60000 }); // 60 seconds
   ```
2. Check network connection
3. Try request during off-peak hours
4. Contact KRA if persistent

### Problem: Invalid PIN/TCC Format

**Symptoms:**
- `ValidationError`
- "Invalid PIN format" / "Invalid TCC format" message

**Solutions:**
1. Verify PIN format: `P` + 9 digits + letter (e.g., `P051234567A`)
2. Verify TCC format: `TCC` + digits (e.g., `TCC123456`)
3. Remove spaces and special characters
4. Convert to uppercase

### Problem: Cache Not Working

**Symptoms:**
- Every request hits the API
- No performance improvement

**Solutions:**
1. Verify cache is enabled
   ```php
   $config = new KraConfig(
       cacheConfig: new CacheConfig(enabled: true)
   );
   ```
2. Check cache TTL values
3. Ensure client instance is reused
4. Clear cache if stale
   ```go
   client.ClearCache()
   ```

---

## FAQ

### Q: Which SDK should I use?

**A:** Choose based on your application's tech stack:
- **Python**: Django, Flask, FastAPI
- **Node.js**: Express, NestJS, Next.js
- **PHP**: Laravel, Symfony, WordPress
- **Go**: High-performance APIs, microservices
- **Flutter**: Mobile apps (iOS/Android), cross-platform

### Q: Do I need different API keys for each SDK?

**A:** No, use the same API key across all SDKs.

### Q: Are the SDKs free to use?

**A:** Yes, all SDKs are open-source (MIT License). However, API usage may have costs from KRA.

### Q: Can I use multiple SDKs in the same project?

**A:** Yes, but typically not necessary. Choose one SDK per project.

### Q: How do I get a sandbox/test API key?

**A:** Contact KRA GavaConnect support for test environment access.

### Q: What's the rate limit?

**A:** Default is 100 requests/minute. Contact KRA for higher limits.

### Q: Are the SDKs production-ready?

**A:** Yes, all SDKs have been thoroughly tested and include:
- Comprehensive error handling
- Retry logic with exponential backoff
- Response caching
- Rate limiting
- 80%+ test coverage

### Q: How do I report bugs?

**A:** Create an issue on GitHub:
- Python: https://github.com/kra-connect/python-sdk/issues
- Node.js: https://github.com/kra-connect/node-sdk/issues
- PHP: https://github.com/kra-connect/php-sdk/issues
- Go: https://github.com/kra-connect/go-sdk/issues
- Flutter: https://github.com/kra-connect/flutter-sdk/issues

### Q: Can I contribute to the SDKs?

**A:** Yes! All SDKs are open-source. See `CONTRIBUTING.md` in each repository.

### Q: Do the SDKs work offline?

**A:** No, all SDKs require internet connection to communicate with KRA API. However, caching reduces API calls.

### Q: How do I update to the latest version?

**Python:**
```bash
pip install --upgrade kra-connect
```

**Node.js:**
```bash
npm update @kra-connect/node
```

**PHP:**
```bash
composer update kra-connect/php-sdk
```

**Go:**
```bash
go get -u github.com/kra-connect/go-sdk
```

**Flutter:**
```bash
flutter pub upgrade kra_connect
```

---

## Support

### Documentation
- Python SDK: https://github.com/kra-connect/python-sdk
- Node.js SDK: https://github.com/kra-connect/node-sdk
- PHP SDK: https://github.com/kra-connect/php-sdk
- Go SDK: https://pkg.go.dev/github.com/kra-connect/go-sdk
- Flutter SDK: https://pub.dev/packages/kra_connect

### Community
- GitHub Discussions: https://github.com/kra-connect/monorepo/discussions
- Issue Tracker: https://github.com/kra-connect/monorepo/issues

### Professional Support
- Email: support@kra-connect.dev
- Website: https://kra-connect.dev

---

**Happy Coding! 🚀**
