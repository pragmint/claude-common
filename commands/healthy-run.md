---
allowed-tools: [Bash, WebFetch]
description: Starts the application and verifies it's running correctly
---

# Healthy Run

Start the application, perform health checks, and run automated tests to ensure the system is running properly. This command should run from scratch without paying attention to previous runs. *MAKE SURE TO RUN EACH STEP IN THE SECTION BELOW*

## Steps

1. Identify how to start the application

- Look for start commands in package.json, Dockerfile, Makefile, or other config files.
- Check the README or repo for instructions.
- Ensure all project dependencies are installed.

2. Start the application

- If a start method is found, launch the application in the background.
- Wait until the application signals readiness (logs, port binding, or similar).
- If no start method is found, stop here and report that no method exists.

3. Run health checks

- Call the health check endpoint(s).
- Load the homepage or main API endpoint.
- Verify expected responses and outputs.

4. Run automated tests

- Determine how to run the project’s automated test suite.
- Execute the tests and capture results.

5. Report health status

- If the application started successfully, health checks passed, and tests passed, report healthy.
- Otherwise, report unhealthy.
