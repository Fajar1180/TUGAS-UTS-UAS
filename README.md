# TUGAS-UTS-UAS – Rekayasa Sistem Informasi (Kelas A1)
## Proyek: TukangDekat (Platform Pemesanan Jasa Lokal – Bojongloa Kaler)

Repository ini berisi dokumen dan (nantinya) source code proyek tugas besar mata kuliah **Rekayasa Sistem Informasi**.
Milestone dibagi menjadi:
- **UTS:** Analisis & Desain (SRS, UML, Arsitektur, Kontrak API)
- **UAS:** Implementasi & Integrasi (Laravel API, Flutter, Docker, Hosting, Integrasi QRIS + n8n)

---

## Struktur Folder
- `docs/srs/` : Dokumen SRS + Business Process + UML + Arsitektur
- `docs/api/` : Dokumentasi kontrak REST API
- `docs/notulen/` : Notulen setiap pertemuan/diskusi
- `docs/dokumentasi-lapangan/` : Dokumentasi survey/wawancara lapangan

---

## Dokumen UTS (Analisis & Desain)

### 1) SRS (Software Requirements Specification)
- `docs/srs/SRS_TukangDekat_v1.1.md`

### 2) Business Process
- `docs/srs/BUSINESS_PROCESS_TukangDekat_v1.0.md`

### 3) UML Lanjut
- Class Diagram (spec untuk digambar di StarUML/draw.io):
  - `docs/srs/CLASS_DIAGRAM_SPEC_TukangDekat_v1.0.md`
- Sequence Diagram:
  - `docs/srs/SEQUENCE_DIAGRAMS_TukangDekat_v1.0.md`

### 4) Arsitektur Sistem
- Component Diagram:
  - `docs/srs/COMPONENT_DIAGRAM_TukangDekat_v1.0.md`
- Deployment Diagram (Docker topology):
  - `docs/srs/DEPLOYMENT_DIAGRAM_TukangDekat_v1.0.md`

### 5) Kontrak API (API Documentation)
- `docs/api/API_DOCUMENTATION_TukangDekat_v1.0.md`

### 6) Versioning / Catatan Perubahan
- `docs/srs/CHANGELOG.md`

---

## Catatan Implementasi (untuk UAS)
Target implementasi UAS:
- Backend **Laravel (API-only)**
- Mobile **Flutter** (consume API)
- Backend environment dibungkus **Docker + Docker Compose** (Laravel + Web Server + Database)
- Integrasi pembayaran **QRIS** + webhook callback
- Integrasi notifikasi via **n8n** (WhatsApp + Email)
- Hosting backend (VPS/Cloud)

---

## Kontribusi / Git Workflow
Sesuai ketentuan tugas, penggunaan Git diutamakan melalui command:
- `clone`, `pull`, `commit`, `push`, `merge`, dll.
Bukan upload manual file lewat website GitHub.

---

## Nama Anggota
1. Muhammad Fajar Nurjaman (20241320059)
2. ⁠Nabilah Asana Alecia (20241320076)
3. Nabil Ramadhan (20241320068)
4. Aldy Ramadany (20241320050)
5. ⁠R.Elsa Balqis khoerunnisa S (20241320062)
6. Tetep Safarudin (20241320065)
7. Fatin Asyifa Nurrizky JenPutri (20241320073)
8. ⁠Fazna Laisal Ramadhan (20241320081)
