#!/usr/bin/env bash
# =============================================================
#  TukangDekat – GitHub Project Setup Script
#  Dibuat oleh: R.Elsa Balqis (Project Manager)
#  Timeline: 11 Mei – 18 Juni 2026
#
#  CARA PAKAI:
#  1. Install GitHub CLI  : https://cli.github.com/
#  2. Login               : gh auth login
#  3. Isi variabel REPO di bawah (format: owner/repo-name)
#  4. Jalankan            : bash setup_tukangdekat_github.sh
# =============================================================

# ─── KONFIGURASI — SESUAIKAN INI ─────────────────────────────
REPO="radenelsa7-bot/PM_UAS_rekayasa_Sistem_Informasi"          # Ganti dengan username/repo kamu
PROJECT_NAME="TukangDekat – Sprint Board"
# ─────────────────────────────────────────────────────────────

set -e
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║      TukangDekat – GitHub Project Setup              ║"
echo "║      Timeline: 11 Mei – 18 Juni 2026                 ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Cek gh CLI tersedia
if ! command -v gh &> /dev/null; then
  echo -e "${RED}✗ GitHub CLI (gh) tidak ditemukan.${NC}"
  echo "  Install di: https://cli.github.com/"
  exit 1
fi

# Cek auth
if ! gh auth status &> /dev/null; then
  echo -e "${RED}✗ Belum login. Jalankan: gh auth login${NC}"
  exit 1
fi

echo -e "${GREEN}✓ GitHub CLI terdeteksi & sudah login${NC}"
echo -e "${YELLOW}→ Target repo: ${REPO}${NC}\n"

# =============================================================
# STEP 1 – LABELS
# =============================================================
echo -e "${CYAN}[1/4] Membuat labels...${NC}"

create_label() {
  local name="$1" color="$2" desc="$3"
  gh label create "$name" --color "$color" --description "$desc" --repo "$REPO" --force 2>/dev/null \
    /* Lines 53-55 omitted */
}

# Role labels
create_label "role: PM"         "0075ca" "Project Manager"
create_label "role: Backend"    "e4e669" "Backend Developer"
create_label "role: Frontend"   "d93f0b" "Frontend Developer"
create_label "role: Testing"    "0e8a16" "QA / Testing"

# Week labels
create_label "week-1 (11-17 Mei)"   "bfd4f2" "Minggu 1"
create_label "week-2 (18-24 Mei)"   "bfd4f2" "Minggu 2"
create_label "week-3 (25-31 Mei)"   "bfd4f2" "Minggu 3"
create_label "week-4 (1-7 Jun)"     "bfd4f2" "Minggu 4"
create_label "week-5 (8-14 Jun)"    "bfd4f2" "Minggu 5"
create_label "week-6 (15-18 Jun)"   "bfd4f2" "Minggu 6 (Final)"

# Status labels
create_label "priority: high"   "b60205" "High priority"
create_label "priority: medium" "fbca04" "Medium priority"
create_label "priority: low"    "c2e0c6" "Low priority"
create_label "status: blocked"  "e11d48" "Tertahan / ada hambatan"
create_label "status: review"   "8b5cf6" "Perlu review"

# Module labels
create_label "module: auth"         "c5def5" ""
create_label "module: order"        "c5def5" ""
create_label "module: payment"      "c5def5" ""
create_label "module: provider"     "c5def5" ""
create_label "module: notification" "c5def5" ""
create_label "module: review"       "c5def5" ""
create_label "module: admin"        "c5def5" ""
create_label "module: UI/UX"        "c5def5" ""
create_label "documentation"        "0052cc" ""
create_label "testing"              "0e8a16" ""

# =============================================================
# STEP 2 – MILESTONES
# =============================================================
echo -e "\n${CYAN}[2/4] Membuat milestones (per minggu)...${NC}"

create_milestone() {
  local title="$1" due="$2" desc="$3"
  gh api repos/${REPO}/milestones \
    /* Lines 98-105 omitted */
}

create_milestone "Week 1 – Setup & Perencanaan (11–17 Mei)"   "2026-05-17" "Environment setup, pembagian tugas, wireframe awal"
create_milestone "Week 2 – Auth & Fondasi API (18–24 Mei)"    "2026-05-24" "Auth register/login, DB migration, Flutter project init"
create_milestone "Week 3 – Core Feature Backend (25–31 Mei)"  "2026-05-31" "Order, Provider, Service Catalog API"
create_milestone "Week 4 – Payment & Notifikasi (1–7 Jun)"    "2026-06-07" "QRIS DP & Final, webhook, n8n integration"
create_milestone "Week 5 – Frontend & Integrasi (8–14 Jun)"   "2026-06-14" "Flutter screens, integrasi API, review & rating"
create_milestone "Week 6 – Testing & Finalisasi (15–18 Jun)"  "2026-06-18" "QA testing, bug fix, demo, dokumentasi final"

# Helper: get milestone number by title keyword
get_milestone() {
  gh api repos/${REPO}/milestones --jq ".[] | select(.title | contains(\"$1\")) | .number" 2>/dev/null | head -1
}

# =============================================================
# STEP 3 – ISSUES
# =============================================================
echo -e "\n${CYAN}[3/4] Membuat issues...${NC}"

create_issue() {
  local title="$1"
  local body="$2"
  local labels="$3"
  local assignees="$4"
  local milestone_keyword="$5"

  local ms_num=$(get_milestone "$milestone_keyword")
  local ms_flag=""
  [[ -n "$ms_num" ]] && ms_flag="--milestone $ms_num"

  gh issue create \
    /* Lines 136-145 omitted */
}

# NOTE: Ganti username GitHub di bawah sesuai akun masing-masing anggota
PM="elsa-balqis"          # R.Elsa Balqis (PM)
BE1="fajar-nurjaman"      # Muhammad Fajar Nurjaman
BE2="nabilah-asana"       # Nabilah Asana Alecia
BE3="fatin-asyifa"        # Fatin Asyifa Nurrizky
FE1="tetep-safarudin"     # Tetep Safarudin
FE2="fazna-alaisal"       # Fazna Alaisal
FE3="nabil-ramadhan"      # Nabil Ramadhan
QA="aldy-ramadani"        # Aldy Ramadani

echo -e "\n  ${YELLOW}── WEEK 1: Setup & Perencanaan (11–17 Mei) ──${NC}"

create_issue \
  "[PM] Finalisasi SRS & distribusi dokumen ke tim" \
  "## Deskripsi\nReview SRS v1.1, pastikan semua anggota tim memahami scope sistem.\n\n## Tasks\n- [ ] Review dan finalisasi SRS_TukangDekat_v1.1.md\n- [ ] Distribusikan dokumen ke semua anggota\n- [ ] Buat GitHub repo & project board\n- [ ] Setup branch strategy (main, develop, feature/*)\n- [ ] Buat dokumen CONTRIBUTING.md\n\n## Referensi\n- docs/srs/SRS_TukangDekat_v1.1.md" \
  "role: PM,week-1 (11-17 Mei),priority: high,documentation" \
  "$PM" "Week 1"

create_issue \
  "[PM] Setup GitHub Project Board & milestone tracking" \
  "## Deskripsi\nSetup GitHub Project (Kanban board) dengan kolom: Backlog, In Progress, Review, Done.\n\n## Tasks\n- [ ] Buat GitHub Project board\n- [ ] Konfigurasi kolom Kanban\n- [ ] Assign semua issues ke milestone yang sesuai\n- [ ] Sosialisasi cara penggunaan board ke tim\n- [ ] Buat template issue dan PR" \
  "role: PM,week-1 (11-17 Mei),priority: high" \
  "$PM" "Week 1"

create_issue \
  "[PM] Buat WBS & jadwal detail per anggota" \
  "## Deskripsi\nSusun Work Breakdown Structure dan jadwal mingguan yang jelas untuk setiap anggota.\n\n## Tasks\n- [ ] Susun WBS berdasarkan SRS feature list\n- [ ] Bagi task per role (Backend/Frontend/Testing)\n- [ ] Set deadline per task di GitHub Issues\n- [ ] Buat tabel RACI (Responsible, Accountable, Consulted, Informed)\n\n## Output\nFile docs/management/WBS_TukangDekat.md" \
  "role: PM,week-1 (11-17 Mei),priority: high,documentation" \
  "$PM" "Week 1"

create_issue \
  "[Backend] Setup Laravel project & Docker environment" \
  "## Deskripsi\nInisialisasi project Laravel dengan Docker Compose sesuai Deployment Diagram.\n\n## Tasks\n- [ ] Init Laravel 11 project\n- [ ] Buat docker-compose.yml (nginx, laravel-api, db, n8n)\n- [ ] Setup .env template\n- [ ] Konfigurasi database connection\n- [ ] Test docker-compose up berjalan\n- [ ] Push ke branch develop\n\n## Referensi\n- docs/srs/DEPLOYMENT_DIAGRAM_TukangDekat_v1.0.md" \
  "role: Backend,week-1 (11-17 Mei),priority: high" \
  "$BE1" "Week 1"

create_issue \
  "[Backend] Database migration sesuai schema MySQL" \
  "## Deskripsi\nBuat semua Laravel migration berdasarkan schema_mysql_tukangdekat.sql.\n\n## Tasks\n- [ ] Migration: users\n- [ ] Migration: provider_profiles\n- [ ] Migration: service_categories\n- [ ] Migration: provider_services\n- [ ] Migration: orders\n- [ ] Migration: payments\n- [ ] Migration: order_attachments\n- [ ] Migration: reviews\n- [ ] Migration: notification_logs\n- [ ] Buat seeders untuk data dummy kategori\n\n## Referensi\n- docs/database/schema_mysql_tukangdekad.sql" \
  "role: Backend,week-1 (11-17 Mei),priority: high" \
  "$BE2" "Week 1"

create_issue \
  "[Frontend] Setup Flutter project & struktur folder" \
  "## Deskripsi\nInisialisasi project Flutter dan setup arsitektur folder.\n\n## Tasks\n- [ ] Init Flutter project\n- [ ] Setup dependency: dio, provider/riverpod, go_router\n- [ ] Buat struktur folder (features, core, shared)\n- [ ] Setup base API service (base URL, auth interceptor)\n- [ ] Setup theme & color scheme\n- [ ] Push ke branch develop\n\n## Referensi\n- docs/srs/COMPONENT_DIAGRAM_TukangDekat_v1.0.md" \
  "role: Frontend,week-1 (11-17 Mei),priority: high" \
  "$FE1" "Week 1"

create_issue \
  "[Frontend] Desain wireframe & UI kit (Figma)" \
  "## Deskripsi\nBuat wireframe untuk semua layar utama aplikasi.\n\n## Tasks\n- [ ] Wireframe: Login & Register\n- [ ] Wireframe: Home + Kategori\n- [ ] Wireframe: Daftar Provider & Detail\n- [ ] Wireframe: Form Buat Order\n- [ ] Wireframe: Detail Order & Status\n- [ ] Wireframe: Halaman Pembayaran (QR)\n- [ ] Wireframe: Rating & Review\n- [ ] Wireframe: Dashboard Admin/Treasurer\n\n## Referensi\n- SRS 3.1 User Interfaces" \
  "role: Frontend,week-1 (11-17 Mei),priority: high,module: UI/UX" \
  "$FE2,$FE3" "Week 1"

create_issue \
  "[Testing] Buat Test Plan dokumen" \
  "## Deskripsi\nSusun rencana pengujian mencakup semua fitur dari SRS.\n\n## Tasks\n- [ ] Identifikasi semua FR yang perlu diuji (FR-01 s/d FR-26)\n- [ ] Buat test case untuk happy path & edge case tiap fitur\n- [ ] Tentukan tools pengujian (Postman, Flutter test, dll)\n- [ ] Buat template bug report\n- [ ] Setup Postman Collection untuk API testing\n\n## Output\ndocs/testing/TEST_PLAN_TukangDekat.md" \
  "role: Testing,week-1 (11-17 Mei),priority: high,documentation,testing" \
  "$QA" "Week 1"

echo -e "\n  ${YELLOW}── WEEK 2: Auth & Fondasi API (18–24 Mei) ──${NC}"

create_issue \
  "[Backend] API Auth: Register, Login, Logout (FR-01, FR-02, FR-03)" \
  "## Deskripsi\nImplementasi endpoint autentikasi sesuai API Documentation section 5.1.\n\n## Tasks\n- [ ] POST /api/auth/register (customer & provider)\n- [ ] POST /api/auth/login (return token)\n- [ ] POST /api/auth/logout\n- [ ] Middleware role-based access (FR-04)\n- [ ] Password hashing (NFR-05)\n- [ ] Unit test auth endpoints\n\n## Acceptance Criteria\n- Register mengembalikan user_id & role\n- Login mengembalikan token valid\n- Endpoint protected menolak request tanpa token (401)\n\n## Referensi\n- API Doc 5.1\n- SRS FR-01 s/d FR-04" \
  "role: Backend,week-2 (18-24 Mei),priority: high,module: auth" \
  "$BE1" "Week 2"

# (file truncated - original script contains many more create_issue calls and the final project board creation)
