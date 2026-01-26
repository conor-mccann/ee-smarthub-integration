# USP Protocol Code Generator

This script downloads official USP (User Services Platform, TR-369) protocol definitions from the Broadband Forum and generates Python code for use in the integration.

## Usage

```bash
# Install dependencies
pip install "betterproto[compiler]"

# Generate using latest version (1-4)
./proto/generate.sh

# Or specify a version
./proto/generate.sh 1-2
```

The script downloads `.proto` files from [github.com/BroadbandForum/usp](https://github.com/BroadbandForum/usp) and generates `usp.py` and `usp_record.py` in `custom_components/ee_smarthub/`.
