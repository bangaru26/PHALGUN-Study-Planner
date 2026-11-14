#!/usr/bin/env python3
"""Audit active source/configuration on every fetched remote branch for retired hosted-provider dependencies."""

from __future__ import annotations

import subprocess
import sys

HOST = "hatchable"
HOST_PATTERNS = [
    HOST + r"\.[A-Za-z0-9.-]+",
    "hatch" + r"\.dev",
    "@" + HOST + r"/",
    HOST + r"-(sdk|client)",
]
SOURCE_PATHS = [
    "*.py", "*.js", "*.mjs", "*.cjs", "*.ts", "*.tsx", "*.jsx",
    "*.java", "*.kt", "*.gradle", "*.kts", "*.json", "*.yaml", "*.yml",
    "*.toml", "*.xml", "*.html", "*.css", "*.scss", "*.sh", "*.ps1",
    "*.cmd", "*.bat", "*.properties", "*.conf", "*.ini", "*.lock",
    ":(exclude)**/test_*", ":(exclude)**/*_test.*", ":(exclude)tests/**",
    ":(exclude)**/tests/**", ":(exclude)docs/**", ":(exclude)**/docs/**",
]

def run_git(*args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(["git", *args], text=True, capture_output=True, check=False)

refs = run_git("for-each-ref", "--format=%(refname)", "refs/remotes/origin")
if refs.returncode:
    print(refs.stderr, file=sys.stderr)
    sys.exit(refs.returncode)

branches = [line.strip() for line in refs.stdout.splitlines() if line.strip() and not line.endswith("/HEAD")]
if not branches:
    print("No remote branches were fetched; refusing to report a clean audit.", file=sys.stderr)
    sys.exit(2)

violations: list[str] = []
errors: list[str] = []
for ref in branches:
    for pattern in HOST_PATTERNS:
        result = run_git("grep", "-I", "-n", "-E", pattern, ref, "--", *SOURCE_PATHS)
        if result.returncode == 0:
            violations.extend(f"{ref}:{line}" for line in result.stdout.splitlines())
        elif result.returncode not in (1,):
            errors.append(f"{ref}: git grep exited {result.returncode}: {result.stderr.strip()}")

    manifests = [
        "package.json", "package-lock.json", "npm-shrinkwrap.json", "pnpm-lock.yaml",
        "yarn.lock", "requirements.txt", "pyproject.toml", "Pipfile", "Pipfile.lock",
        "poetry.lock", "Cargo.toml", "go.mod",
    ]
    for manifest in manifests:
        result = run_git("grep", "-I", "-n", "-i", HOST, ref, "--", manifest, "**/" + manifest)
        if result.returncode == 0:
            violations.extend(f"{ref}:{line}" for line in result.stdout.splitlines())
        elif result.returncode not in (1,):
            errors.append(f"{ref} ({manifest}): git grep exited {result.returncode}: {result.stderr.strip()}")

if errors:
    print("Branch audit could not complete:")
    print("\n".join(errors))
    sys.exit(2)
if violations:
    print("Retired-provider references found in active source/configuration:")
    print("\n".join(sorted(set(violations))))
    sys.exit(1)

print(f"Branch audit passed: {len(branches)} remote branches checked; no retired-host or SDK dependency found in executable source/configuration.")
