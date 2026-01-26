#!/bin/bash
# Download official USP proto files and generate Python code using betterproto
#
# Prerequisites:
#   pip install "betterproto[compiler]"
#
# Usage:
#   ./proto/generate.sh [version]
#
# Arguments:
#   version - USP protocol version (default: 1-4)
#             Available: 1-0, 1-1, 1-2, 1-3, 1-4

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/../custom_components/ee_smarthub/proto"
VERSION="${1:-1-4}"

# Official Broadband Forum USP repository
REPO_URL="https://raw.githubusercontent.com/BroadbandForum/usp/master/specification"

# Check dependencies
if ! python -c "import grpc_tools.protoc" 2>/dev/null; then
    echo "Error: betterproto[compiler] not installed"
    echo "   Run: pip install 'betterproto[compiler]'"
    exit 1
fi

echo "=================================================="
echo "USP Protocol Buffer Generator"
echo "=================================================="
echo "Version: $VERSION"
echo "Source: Broadband Forum USP Repository"
echo ""

# Download official proto files
echo "Downloading official proto files..."
if ! curl -fsSL "$REPO_URL/usp-msg-$VERSION.proto" -o "$SCRIPT_DIR/usp-msg.proto"; then
    echo "Error: Failed to download usp-msg-$VERSION.proto"
    echo "   Check version exists at: $REPO_URL"
    exit 1
fi
if ! curl -fsSL "$REPO_URL/usp-record-$VERSION.proto" -o "$SCRIPT_DIR/usp-record.proto"; then
    echo "Error: Failed to download usp-record-$VERSION.proto"
    exit 1
fi
echo "Downloaded usp-msg-$VERSION.proto"
echo "Downloaded usp-record-$VERSION.proto"
echo ""

# Create output directory if needed
mkdir -p "$OUTPUT_DIR"

# Generate Python code
echo "Generating Python code with betterproto..."
python -m grpc_tools.protoc \
    --proto_path="$SCRIPT_DIR" \
    --python_betterproto_out="$OUTPUT_DIR" \
    "$SCRIPT_DIR/usp-msg.proto" \
    "$SCRIPT_DIR/usp-record.proto"

echo "Generated usp.py"
echo "Generated usp_record.py"

# Create __init__.py with re-exports for cleaner imports
cat > "$OUTPUT_DIR/__init__.py" << 'EOF'
"""USP protocol definitions generated from official Broadband Forum proto files."""
from .usp import Body, Get, Header, HeaderMsgType, Msg, Request, Response
from .usp_record import NoSessionContextRecord, Record

__all__ = [
    "Msg",
    "Header",
    "Body",
    "Request",
    "Response",
    "Get",
    "HeaderMsgType",
    "Record",
    "NoSessionContextRecord",
]
EOF

echo "Created __init__.py with re-exports"
echo ""

echo "Output directory: $OUTPUT_DIR"
echo ""
echo "=================================================="
echo "Done! Proto files and generated code are ready."
echo "=================================================="
