const { test, expect } = require('@playwright/test');

test.describe('Treasurer export endpoint', () => {
  test('CSV export returns CSV when TEST_TOKEN provided', async ({ request }) => {
    const token = process.env.TEST_TOKEN;
    test.skip(!token, 'TEST_TOKEN not set in environment');

    const res = await request.get('/api/treasurer/payments/report?export=csv', {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'text/csv'
      }
    });

    expect(res.status()).toBe(200);
    const ct = res.headers()['content-type'] || '';
    expect(ct).toContain('text/csv');

    const body = await res.text();
    expect(body.length).toBeGreaterThan(10);
    expect(body).toContain('payment_id');
  });
});
