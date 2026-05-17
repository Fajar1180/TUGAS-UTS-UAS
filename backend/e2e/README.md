E2E Playwright tests for backend treasurer export

Setup:
1. Install Node.js (>=16) and npm.
2. From the `backend/e2e` folder run:

   npm install

3. Configure environment variables (optional):
   - `PLAYWRIGHT_BASE_URL` (default: http://localhost)
   - `TEST_TOKEN` - a Bearer token for an authenticated treasurer user (required for the CSV test)

Run tests:

   npm test

Notes:
- The test `treasurer-export.spec.js` calls the API endpoint `/api/treasurer/payments/report?export=csv` and requires an authenticated token.
- You can create a test treasurer user and generate a token via Laravel Sanctum or your app's token endpoint, then set `TEST_TOKEN` before running tests.

Quick token helper:

From the `backend` folder you can run the included Artisan command to create/find a `TREASURER` user and emit a token:

```bash
php artisan test:make-token --save
```

This will create the user `test.treasurer@example.com` (if missing), print the `TEST_TOKEN` and save it to `backend/e2e/.env` when `--save` is provided.
