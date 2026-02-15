# TF VAT Check

VAT validation extension for Microsoft Dynamics 365 Business Central.

## Overview

This extension provides VAT (Value Added Tax) number validation functionality for Business Central. It allows users to validate VAT registration numbers against standard European formats and maintain a history of validations.

## Features

- **VAT Number Validation**: Validate VAT registration numbers for 13 European countries
- **Format Checking**: Automatic format validation based on country-specific rules
- **Validation History**: Track all VAT validations with timestamps and user information
- **User-Friendly Interface**: Easy-to-use pages for VAT checking and history viewing
- **Namespace Support**: Built with modern AL namespace conventions

## Supported Countries

- Austria (AT)
- Belgium (BE)
- Denmark (DK)
- Finland (FI)
- France (FR)
- Germany (DE)
- Ireland (IE)
- Italy (IT)
- Netherlands (NL)
- Portugal (PT)
- Spain (ES)
- Sweden (SE)
- United Kingdom (GB)

## Technical Details

- **Platform**: Business Central 24.0
- **Runtime**: 13.0
- **Target**: Cloud
- **Namespace**: TrustFort.VATCheck
- **ID Range**: 50100-50149

## Objects

### Tables
- **50100 - TF VAT Validation Result**: Stores validation results and history

### Codeunits
- **50100 - TF VAT Validation Mgt.**: Core validation logic

### Pages
- **50100 - TF VAT Check**: Main interface for VAT validation
- **50101 - TF VAT Validation Results**: List view of validation history
- **50102 - TF VAT Validation Detail**: Detailed view of a single validation

## Installation

1. Clone or download this repository
2. Open the folder in Visual Studio Code with the AL Language extension installed
3. Configure your `launch.json` with your Business Central environment details
4. Press F5 to compile and deploy the extension

## Usage

### Validating a VAT Number

1. Open the **TF VAT Check** page from the search
2. Enter the VAT registration number (e.g., DE123456789)
3. Select the appropriate Country/Region Code
4. Click **Validate VAT Number**
5. View the validation result

### Viewing Validation History

1. Open the **TF VAT Validation Results** page from the search
2. Browse all previous validations
3. Click on any record to view detailed information

## Development

### Prerequisites
- Visual Studio Code
- AL Language Extension for Visual Studio Code
- Business Central Development Environment (24.0 or later)

### Building the Project
```bash
# Download symbols
Ctrl+Shift+P > AL: Download Symbols

# Compile and publish
F5 or Ctrl+F5
```

## Configuration

Update the `.vscode/launch.json` file with your environment settings:

- For **on-premises**: Update server, serverInstance, and authentication settings
- For **cloud sandbox**: Update environmentName with your sandbox name

## License

Copyright © TrustFort IT

## Support

For issues, questions, or contributions, please contact TrustFort IT.

## Version History

### 1.0.0.0
- Initial release
- VAT format validation for 13 European countries
- Validation history tracking
- User interface pages
