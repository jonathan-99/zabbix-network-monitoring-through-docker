#!/usr/bin/env python3

import json

inventory = {
    "pinas": {"ansible_host": "192.168.1.134"},
    "new1gb": {"ansible_host": "192.168.1.14"},
    "new2gb": {"ansible_host": "192.168.1.16"},
    "new3": {"ansible_host": "192.168.1.17"}
}

try:
    print(json.dumps(inventory))
except Exception as e:
    print(f"Error: {e}")
    exit(1)
