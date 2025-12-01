# KRA-Connect Python CLI

The Python SDK ships with a lightweight CLI (`kra`) so teams can run quick checks without writing a script. This document captures the basic flows and outlines the upcoming batch helpers.

## Prerequisites

- Install the SDK: `pip install kra-connect`
- Set the API key once: `export KRA_API_KEY=your-key` (or pass `--api-key` per command)

## Common Commands

```bash
# Verify a single PIN
kra verify-pin P051234567A

# Verify a TCC
kra verify-tcc TCC123456

# Validate an e-slip
kra validate-eslip 1234567890

# File a NIL return
kra file-nil-return P051234567A OBL123456 202401

# Fetch taxpayer details
kra taxpayer-details P051234567A
```

All commands return JSON so they can be piped into `jq`, saved to files, or consumed by other scripts.

Sample output (truncated):

```
$ kra verify-pin P051234567A
{
  "pin_number": "P051234567A",
  "is_valid": true,
  "taxpayer_name": "Example Traders Ltd",
  "status": "active"
}
```

## Upcoming Enhancements

- **Batch CSV helpers** – planned flags such as `--batch pins.csv` and `--output results.csv` will let compliance teams verify hundreds of records at once.
- **Watch mode** – the roadmap includes a `--watch path.csv` option that tails a shared file and re-submits changes without leaving the CLI.

These additions will land once the corresponding bulk API endpoints are stabilized; follow the SDK changelog for updates.
