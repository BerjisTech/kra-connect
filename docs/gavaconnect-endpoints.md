# KRA GavaConnect Endpoint Snapshot

Derived from the public docs at https://developer.go.ke/apis and the Postman exports under postman-collections/.

## Auth
- Token URL (sandbox): https://sbx.kra.go.ke/v1/token/generate?grant_type=client_credentials
- Token URL (payments/duty flows): https://sbx.kra.go.ke/oauth/v1/generate?grant_type=client_credentials
- Method: GET with Authorization: Basic <base64(client_id:client_secret)>
- Response:
  `json
  { "access_token": "mock", "expires_in": "3599" }
  `

## Core endpoints
| Operation | HTTP | Sandbox URL | Body keys |
|-----------|------|-------------|-----------|
| PIN verification (by PIN) | POST | https://sbx.kra.go.ke/checker/v1/pinbypin | KRAPIN |
| PIN verification (by ID) | POST | https://sbx.kra.go.ke/checker/v1/pin | TaxpayerType, TaxpayerID |
| TCC validation | POST | https://sbx.kra.go.ke/v1/kra-tcc/validate | kraPIN, 	ccNumber |
| E-slip validation | POST | https://sbx.kra.go.ke/payment/checker/v1/eslip | EslipNumber |
| NIL return filing | POST | https://sbx.kra.go.ke/dtd/return/v1/nil | TAXPAYERDETAILS.{TaxpayerPIN,ObligationCode,Month,Year} |
| Obligation lookup | POST | https://sbx.kra.go.ke/dtd/checker/v1/obligation | 	axPayerPin |
| PRN search | POST | https://sbx.kra.go.ke/dtd/checker/v1/prn | prnNumber |
| Import certificate checker | POST | https://sbx.kra.go.ke/cbc/checker/v1/importcertificate/{pin|num} | pin or certificateNumber |

Most responses are wrapped as:
`json
{
  "responseCode": "70000",
  "responseDesc": "Successful",
  "status": "OK",
  "responseData": { /* payload */ }
}
`
Errors follow:
`json
{ "ErrorCode": "70001", "ErrorMessage": "Data Validation Error", "RequestId": "..." }
`

Use this sheet to cross-check each SDK/CLI module before wiring up requests.
