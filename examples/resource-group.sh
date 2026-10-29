#!/usr/bin/env bash
set -euo pipefail
# Read-only example. No resource creation or deletion.
az account show --output table
az group list --output table
