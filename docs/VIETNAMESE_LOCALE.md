# Vietnamese Language Support for ThingsBoard

## Overview

Vietnamese language (vi_VN) has been added to the ThingsBoard UI frontend located in the `ui-ngx` directory.

## Changes Made

### 1. Locale File

A new Vietnamese locale file has been created:
- **File**: `ui-ngx/src/assets/locale/locale.constant-vi_VN.json`
- **Format**: JSON with UTF-8 encoding
- **Content**: Vietnamese translations for all UI strings (10,000+ translations)

### 2. Language Selection

Vietnamese has been added to the language selection dropdown:
- Updated `locale.constant-en_US.json` with Vietnamese in the `language.locales` section
- Display name: **"Tiếng Việt (Việt Nam)"**

### 3. Automatic Detection

The build system automatically detects all locale files in `ui-ngx/src/assets/locale/`:
- The esbuild plugin scans for files matching pattern: `locale.constant-*.json`
- Extracts language codes from filenames (e.g., `vi_VN` from `locale.constant-vi_VN.json`)
- Populates the `SUPPORTED_LANGS` environment variable

## How to Use

### For Users

1. Log in to ThingsBoard
2. Go to your profile settings
3. Select **"Tiếng Việt (Việt Nam)"** from the language dropdown
4. The UI will refresh with Vietnamese translations

### For Developers

#### Building the UI

```bash
cd ui-ngx
yarn install
yarn build:prod
```

#### Running in Development

```bash
cd ui-ngx
yarn start
```

The application will be available at `http://localhost:4200`

## Translation Coverage

The Vietnamese locale file includes translations for:
- Access control and authentication messages
- Account settings
- All action buttons (Save, Cancel, Delete, etc.)
- Admin settings
- Aggregation functions
- Device management
- Dashboard widgets
- Rule chains
- Alarms and events
- And many more...

## License

All translation files are licensed under the same license as ThingsBoard (Apache License 2.0).
