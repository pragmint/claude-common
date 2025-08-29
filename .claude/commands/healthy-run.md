---
allowed-tools: [Bash, WebFetch]
description: Starts the application and verifies it's running correctly
---

# Healthy Run

Start the application and perform health checks to ensure the system is running properly.

## Steps

* Scan the codebase for how to start the application
  * Look for start scripts in package.json, Makefile, or other config files
  * Check for common start commands or server files
  * If a start method is found
    * Start the application in background if possible
    * Wait for the application to be ready
    * Perform health checks:
      * Try to access health check endpoints
      * Load the homepage or main endpoint
      * Check for expected responses
    * Report the application status
  * If no start method is found
    * Tell the user no start method has been found
