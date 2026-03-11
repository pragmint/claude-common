---
allowed-tools: [Bash]
description: Discovers and runs the build process for the project
---

# Build

Automatically discover and run the project's build process, ensuring the application is ready for deployment or testing.

## Steps

* Scan the codebase for evidence of a build system
  * Look for build configuration files (package.json, Makefile, pom.xml, Cargo.toml, etc.)
  * Check for build scripts or common build directories
  * If a build system is found
    * Determine the appropriate build command
    * Run the build process
    * Report build status and any errors
  * If no build system is found
    * Tell the user no build system has been found
