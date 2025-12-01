https://developer.go.ke/apis/VAT_Withholding

VAT Withholding PRN Generation
By KRA

https://sbx.kra.go.ke/generate/v1/prn/whtvat

Documentation

Overview
This API endpoint submits Value Added Tax (VAT) withholding tax transaction data to the Kenya Revenue Authority and generates a Payment Reference Number (PRN) to facilitate payment of the withheld tax. The payload contains header information summarizing the entire transaction and detailed breakdowns of individual withholding transactions.

For an VAT Withholding Certificate to be issued to the withholdee, the generated PRN needs to be paid for. The withholding certificate generation is automated from the iTax system.

Content

Authentication is required to access this API as documented in Auth
Income Tax Withholding endpoint doc click Here
🔐 Step 1: Generate Access Token (Authorization API)
Request Details
Use your Consumer Key and Consumer Secret as Basic Auth credentials (username and password) to generate an access token.

Endpoint:

GET https://sbx.kra.go.ke/v1/token/generate?grant_type=client_credentials - Sandbox Endpoint
GET https://api.kra.go.ke/v1/token/generate?grant_type=client_credentials - Production Endpoint
Headers:

Authorization: Basic <Base64Encoded(Consumer_Key:Consumer_Secret)>
Success Response
{
  "access_token": "qblts2rRqMKBG7mvP7AkLZfnWjER",
  "expires_in": "3599"
}
Field	Description
access_token	Token to be used as Bearer token in API requests
expires_in	Time in seconds before the token expires (e.g. 3600)
Error Response
{
    "requestId": "83f2-4b48-bdf5-4c7e1a67dbcb39076",
    "errorCode": "401",
    "errorMessage": "Client credentials are invalid"
}
errorCode	errorMessage
401	Client credentials are invalid
⚠️ Note: No need to create a separate app for Authorization. Use the same app created for this API.

✅ Step 2: Invoke VAT Withholding PRN Generation API Endpoint
Endpoint:

POST https://sbx.kra.go.ke/generate/v1/prn/whtvat - Sandbox Endpoint
POST https://api.kra.go.ke/generate/v1/prn/whtvat - Production Endpoint
Root Object
Content-Type: application/json
Method: POST
JSON Schema
{
  "transactionHeader": {
    "withholderPin": "string",
    "transactionUniqueNo": "string",
    "noOfTransactions": "integer",
    "taxObligation": "string",
    "taxPeriodFrom": "string",
    "taxPeriodTo": "string",
    "totalGrossAmount": "number",
    "totalTaxAmount": "number"
  },
  "transactionDetails": [
    {
      "withholdeePin": "string",
      "invoiceNo": "string",
      "invoiceDate": "string",
      "paymentDate":"string",
      "grossAmount": "string",
      "taxRate": "number",
      "taxAmount": "number"
    }
  ]
}
Field Specifications
Transaction Header Object
Field	Type	Required	Description	Format/Example
withholderPin	string	Yes	PIN of the entity withholding tax	Format: A000000000M
transactionUniqueNo	string	Yes	Unique identifier for the transaction batch	Alphanumeric, e.g., 20220129786799
noOfTransactions	integer	Yes	Number of transactions in the details array	Must match actual count of transactionDetails
taxObligation	string	Yes	Type of tax obligation code - Must be WHTVAT	Example: WHTVAT (Withholding Tax - Income Tax)
taxPeriodFrom	string	Yes	Start date of tax period	ISO 8601: YYYY-MM-DDTHH:MM:SS
taxPeriodTo	string	Yes	End date of tax period	ISO 8601: YYYY-MM-DDTHH:MM:SS
totalGrossAmount	number	Yes	Total gross amount for all transactions	Numeric: 30000
totalTaxAmount	number	Yes	Total tax withheld for all transactions	Numeric: 150
Transaction Details Array
Field	Type	Required	Description	Format/Example
withholdeePin	string	Yes	PIN of the recipient being withheld from	Format: P000000000L
invoiceNo	string	Yes	Invoice number reference	Alphanumeric: 2639202
invoiceDate	string	Yes	Date of invoice	ISO 8601: YYYY-MM-DDTHH:MM:SS
paymentDate	string	Yes	Date payment was made	ISO 8601: YYYY-MM-DDTHH:MM:SS
grossAmount	string	Yes	Gross amount for this transaction	Numeric: 30000
taxRate	number	Yes	Tax rate applied (percentage)	Decimal: 2 (for 2%)
taxAmount	number	Yes	Tax amount calculated	Numeric: 150
Request Example
POST https://sbx.kra.go.ke/generate/v1/prn/whtvat
Headers:

{
  "Content-Type": "application/json",
  "Authorization": "Bearer qblts2rRqMKBG7mvP7AkLZfnWjER"
}
Body:

{
  "transactionHeader": {
    "withholderPin": "P000000000M",
    "transactionUniqueNo": "20220129786799",
    "noOfTransactions": 1,
    "taxObligation": "WHTVAT",
    "taxPeriodFrom": "2025-09-01T00:00:00",
    "taxPeriodTo": "2025-09-30T00:00:00",
    "totalGrossAmount": "100000.00",
    "totalTaxAmount": "2000.00"
  },
  "transactionDetails": [
    {
      "withholdeePin": "P100000001L",
      "invoiceNo": "2639202",
      "invoiceDate": "2025-09-18T00:00:00",
      "paymentDate": "2025-09-22T00:00:00",
      "grossAmount": "100000.00",
      "taxRate": 2,
      "taxAmount": 2000
    }
  ]
}
##Success Response

{
    "responseCode": "70000",
    "responseDesc": "Successful",
    "status": "OK",
    "responseData": {
        "prnNumber": "2020250002597584",
        "prnDate": "2025-09-23T12:51:25",
        "prnAmount": 2000.0
    }
}
##Error Responses

{
    "ErrorCode": "70001",
    "ErrorMessage": "Data Validation Error",
    "RequestId": "af5f11cf-b864-4368-a936-02b645f806f913140"
}
Validation Rules
Consistency Checks:

noOfTransactions must equal the length of transactionDetails array
Sum of all grossAmount in details must equal totalGrossAmount in header
Sum of all taxAmount in details must equal totalTaxAmount in header
taxPeriodFrom must be before or equal to taxPeriodTo
Date Validations:

paymentDate must fall within taxPeriodFrom and taxPeriodTo
invoiceDate should be on or before paymentDate
Calculations:

taxAmount should equal grossAmount × taxRate / 100
Notes
The API may support multiple transactions in the details array for batch processing
Ensure PIN formats comply with the KRA's PIN format