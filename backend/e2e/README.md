<!-- markdownlint-disable -->

E2E Playwright untuk fitur export bendahara (treasurer)

Persiapan:

1. Instal Node.js (>=16) dan npm.
2. Dari folder `backend/e2e` jalankan:

```bash
npm install
```

3. Konfigurasi environment (opsional):
   - `PLAYWRIGHT_BASE_URL` (default: http://localhost)
   - `TEST_TOKEN` - Bearer token untuk user `TREASURER` (dibutuhkan untuk test CSV)

Menjalankan test:

```bash
npm test
```

Catatan:
- Test `treasurer-export.spec.js` memanggil endpoint `/api/treasurer/payments/report?export=csv` dan membutuhkan token autentikasi.
- Anda bisa membuat user treasurer test dan menghasilkan token via Laravel Sanctum atau endpoint token aplikasi, lalu set `TEST_TOKEN` sebelum menjalankan test.

Helper token cepat:

Dari folder `backend` jalankan Artisan command untuk membuat/mencari user `TREASURER` dan mencetak token:

```bash
php artisan test:make-token --save
```

Command ini akan membuat user `test.treasurer@example.com` (jika belum ada), mencetak `TEST_TOKEN`, dan menyimpannya ke `backend/e2e/.env` bila opsi `--save` digunakan.
