/** @type {import('@playwright/test').PlaywrightTestConfig} */
module.exports = {
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL || 'http://localhost',
    headless: true,
    ignoreHTTPSErrors: true,
  },
  testDir: './tests',
};
