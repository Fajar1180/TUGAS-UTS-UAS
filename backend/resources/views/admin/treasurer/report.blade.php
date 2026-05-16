@extends('welcome')

@section('content')
    <div class="max-w-4xl mx-auto p-6">
        <h2 class="text-xl font-semibold mb-4">Laporan Bendahara - Pembayaran</h2>

        <form id="filters" class="flex flex-wrap gap-2 mb-4">
            <input type="date" name="start_date" id="start_date" class="border p-2 rounded" />
            <input type="date" name="end_date" id="end_date" class="border p-2 rounded" />
            <select id="status" name="status" class="border p-2 rounded">
                <option value="">Semua Status</option>
                <option value="UNPAID">UNPAID</option>
                <option value="PENDING">PENDING</option>
                <option value="PAID">PAID</option>
                <option value="FAILED">FAILED</option>
                <option value="EXPIRED">EXPIRED</option>
            </select>
            <select id="payment_type" name="payment_type" class="border p-2 rounded">
                <option value="">Semua Tipe</option>
                <option value="DP">DP</option>
                <option value="FINAL">FINAL</option>
            </select>
            <input type="number" id="per_page" name="per_page" placeholder="Per page" class="border p-2 rounded w-28" />
            <button type="button" id="apply" class="px-4 py-2 bg-black text-white rounded">Terapkan</button>
            <a id="exportBtn" href="#" class="px-4 py-2 bg-green-600 text-white rounded">Unduh CSV</a>
        </form>

        <div id="summary" class="mb-4"></div>

        <table id="table" class="w-full border-collapse">
            <thead>
                <tr class="text-left">
                    <th class="border p-2">ID</th>
                    <th class="border p-2">Order</th>
                    <th class="border p-2">Tipe</th>
                    <th class="border p-2">Status</th>
                    <th class="border p-2">Jumlah</th>
                    <th class="border p-2">Platform Fee</th>
                    <th class="border p-2">Provider Payout</th>
                    <th class="border p-2">Tanggal</th>
                </tr>
            </thead>
            <tbody id="rows"></tbody>
        </table>

        <div id="pagination" class="mt-4"></div>
    </div>

    <script>
        async function fetchReport(params = {}) {
            const qs = new URLSearchParams(params);
            const res = await fetch('/api/treasurer/payments/report?' + qs.toString(), { credentials: 'same-origin', headers: { 'X-Requested-With': 'XMLHttpRequest' } });
            if (!res.ok) throw new Error('Gagal memuat data');
            return res.json();
        }

        function paramsFromForm() {
            return {
                start_date: document.getElementById('start_date').value,
                end_date: document.getElementById('end_date').value,
                status: document.getElementById('status').value,
                payment_type: document.getElementById('payment_type').value,
                per_page: document.getElementById('per_page').value || 20,
            };
        }

        async function load() {
            try {
                const params = paramsFromForm();
                const data = await fetchReport(params);

                // summary
                document.getElementById('summary').innerText = 'Total pembayaran: ' + (data.summary.total_payments ?? 0) + ' | Total nominal: ' + (data.summary.total_amount ?? 0);

                // rows
                const rows = document.getElementById('rows');
                rows.innerHTML = '';
                (data.data || []).forEach(p => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td class="border p-2">${p.id}</td>
                        <td class="border p-2">${p.order_id}</td>
                        <td class="border p-2">${p.payment_type}</td>
                        <td class="border p-2">${p.status}</td>
                        <td class="border p-2">${p.amount}</td>
                        <td class="border p-2">${p.platform_fee}</td>
                        <td class="border p-2">${p.provider_payout}</td>
                        <td class="border p-2">${p.created_at}</td>
                    `;
                    rows.appendChild(tr);
                });

                // export link
                const qs = new URLSearchParams(paramsFromForm());
                document.getElementById('exportBtn').href = '/api/treasurer/payments/report?' + qs.toString() + '&export=csv';
            } catch (e) {
                alert(e.message || 'Error');
            }
        }

        document.getElementById('apply').addEventListener('click', load);

        // initial load
        load();
    </script>
@endsection
