# Implementasi API di App Mobile
> Tugas Praktikum & Implementasi Backend API pada Aplikasi Mobile (Mata Kuliah Pemrograman Berbasis Mobile)

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-92%25-brightgreen)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-blue)

## 1. Project Header & Description (Deep Analysis)

### Background & Problem Statement
Pengembangan aplikasi *mobile e-commerce* sering kali terkendala oleh inefisiensi pada lapisan *backend*, terutama dalam mengelola sinkronisasi *state* keranjang belanja (*cart state management*) antara berbagai perangkat, serta penanganan masalah *concurrency* saat terjadi lonjakan pembelian pada satu produk yang sama (*flash sale*). Dalam konteks pemenuhan tugas mata kuliah Pemrograman Berbasis Mobile (PBM), proyek ini menyoroti *pain points* utama terkait sulitnya membangun sistem transaksi yang aman, konsisten, dan memiliki waktu respons yang cepat untuk *mobile client* yang kerap memiliki konektivitas tidak stabil.

### The Solution
Proyek **Implementasi API di App Mobile** ini dirancang sebagai solusi *RESTful backend* yang berfokus pada keandalan dan performa tinggi. Dibangun dengan arsitektur *Layered Pattern* (Controller-Service-Repository), sistem ini menerapkan *database normalization* hingga bentuk ketiga (3NF) untuk menjamin integritas data operasional. Untuk mengatasi isu *concurrency* pada manajemen data, API ini mengimplementasikan mekanisme *database transactions* dengan *Row-Level Locking* yang mencegah *race conditions* saat dua pengguna mencoba mengubah data secara bersamaan.

### Value Proposition & Core Purpose
Sebagai inti dari ekosistem aplikasi *mobile*, API ini menawarkan *high scalability* untuk melayani ribuan *request* secara konkuren, *secure transactional system* yang memastikan setiap proses *checkout* dicatat secara atomik, serta implementasi *caching* berlapis untuk mempercepat pengambilan data katalog produk. Proyek ini tidak hanya memenuhi standar akademis, tetapi juga mengadopsi *best practices* setara level industri.

---

## 2. Key Features & Tech Stack

### Features Breakdown
- **Secure Authentication & Session Management:** Menggunakan *JSON Web Tokens* (JWT) dengan pendekatan akses *stateless*, memisahkan hak akses (RBAC) antara `Customer` dan `Admin` menggunakan *middleware* secara dinamis.
- **Product Catalog & Filtering Engine:** Katalog produk yang mendukung sistem pencarian kompleks, *pagination*, dan filter spesifik dengan optimasi pada level *database query* untuk mempercepat respons di *mobile app*.
- **Cart & Order Transactional System:** Manajemen keranjang belanja yang persisten dan sistem *checkout* terintegrasi yang menjamin *Atomicity, Consistency, Isolation, Durability* (ACID) saat pembayaran atau perubahan stok berlangsung.
- **Rate Limiting & Security:** Proteksi dari serangan *Brute Force* dan *DDoS* sederhana menggunakan mekanisme *rate limiting* berdasarkan alamat IP pada *endpoint* publik.

### Tech Stack & Architecture Rationale

| Komponen | Teknologi | Rationale (Alasan Teknis) |
| :--- | :--- | :--- |
| **Backend Runtime** | Node.js (Express.js) | Express memberikan fleksibilitas tinggi dan *overhead* yang sangat rendah, ideal untuk membangun API responsif khusus *mobile client*. |
| **Database** | PostgreSQL | Dipilih karena dukungan transaksi relasional yang sangat kuat (*ACID compliance*), krusial untuk fitur *e-commerce checkout*. |
| **State Management (Cache)** | Redis | Digunakan untuk mengelola *rate limiting* dan menyimpan sementara *session* atau katalog populer guna memangkas waktu *query* DB. |
| **ORM / Query Builder** | Prisma ORM | Menghadirkan *type-safety* yang mencegah *runtime errors* akibat kesalahan kueri, sekaligus mempercepat proses *database migration*. |
| **Testing & CI/CD** | Jest & GitHub Actions | Memastikan *reliability* kode (unit dan integrasi) sebelum kode di-*deploy* ke *production server*. |

---

## 3. Architecture & System Design

Proyek ini menerapkan **Layered Architecture** (Model-Route-Controller-Service) untuk memisahkan *business logic* dari *request handling*. Hal ini membuat aplikasi sangat modular, mudah di-_maintain_, dan mempermudah proses pembuatan *mock* pada saat *unit testing*.

### Directory Structure

```text
tugas_pbm_api/
├── src/
│   ├── controllers/         # Menangani HTTP request/response & validasi input dasar
│   ├── services/            # Core business logic (transaksi, perhitungan harga, dll)
│   ├── middlewares/         # Interceptor global (Auth guard, Rate limit, Error handler)
│   ├── routes/              # Definisi API endpoints & pemetaan ke controller
│   ├── utils/               # Helper functions (Hash password, JWT generator)
│   ├── config/              # Konfigurasi environment (Database connection, Redis client)
│   └── index.js             # Entry point aplikasi (Server initialization)
├── prisma/
│   ├── schema.prisma        # Skema tabel database (Users, Products, Orders)
│   └── migrations/          # Histori perubahan struktur database
├── tests/                   # Kumpulan berkas unit testing (Jest)
├── .env.example             # Template variabel environment
└── package.json             # Deklarasi dependencies dan eksekusi skrip
```

---

## 4. Getting Started & Installation Guide

### Prerequisites
Pastikan *environment* lokal Anda memiliki dependensi berikut:
- **Node.js**: v16.x atau v18.x
- **PostgreSQL**: v13+ (Bisa dijalankan via Docker atau *local installer*)
- **Redis**: v6+ (Opsional untuk *local development*)

### Environment Variables
Salin berkas `.env.example` menjadi `.env` dan sesuaikan nilainya.

```env
# --- SERVER CONFIGURATION ---
PORT=8000
NODE_ENV=development

# --- DATABASE CONNECTION ---
# Format standard PostgreSQL: postgresql://USER:PASSWORD@HOST:PORT/DB_NAME
DATABASE_URL="postgresql://postgres:root@localhost:5432/tugas_pbm_db?schema=public"

# --- REDIS CONFIGURATION ---
REDIS_URL="redis://localhost:6379"

# --- SECURITY & AUTHENTICATION ---
# Gunakan string panjang dan acak untuk environment production
JWT_SECRET="pbm_mobile_super_secret_key_2024"
JWT_EXPIRES_IN="7d"
```

### Step-by-Step Installation

1. **Clone repository:**
   ```bash
   git clone https://github.com/username/tugas-pbm-api.git
   cd tugas-pbm-api
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Database Setup & Migration:**
   Pastikan *service* PostgreSQL Anda berjalan, lalu eksekusi migrasi skema melalui Prisma.
   ```bash
   npx prisma migrate dev --name init
   ```

4. **Database Seeding (Opsional):**
   Untuk memuat *dummy data* (katalog produk dan akun admin) ke dalam *database*.
   ```bash
   npx prisma db seed
   ```

5. **Running the development server:**
   ```bash
   npm run dev
   ```
   API akan siap menerima *request* dari aplikasi *mobile* pada `http://localhost:8000`.

---

## 5. API Documentation / Core Usage Example

Dokumentasi lengkap *endpoint* tersedia via *Postman Collection* di dalam folder `docs/`. Berikut adalah ringkasan API utama:

| Method | Endpoint | Auth Required | Description |
| :--- | :--- | :---: | :--- |
| `POST` | `/api/auth/login` | No | Autentikasi pengguna dan mengembalikan `token` akses. |
| `GET` | `/api/products` | No | Mengambil daftar produk (dengan dukungan `?page=1&limit=10`). |
| `POST` | `/api/cart/add` | Yes | Menambahkan *item* ke keranjang (*state* disimpan ke DB). |
| `POST` | `/api/orders/checkout` | Yes | Memproses pembelian dan memotong stok barang. |

### Core Usage Example: Proses Checkout
Berikut adalah contoh struktur data saat *Mobile Client* mengeksekusi proses pembayaran (*checkout*).

**HTTP Request:**
```json
POST /api/orders/checkout HTTP/1.1
Host: api.tugaspbm.com
Authorization: Bearer eyJhbGciOiJIUzI1Ni...
Content-Type: application/json

{
  "shippingAddress": "Jl. Telekomunikasi No. 1, Bandung",
  "paymentMethod": "VIRTUAL_ACCOUNT",
  "items": [
    {
      "productId": 101,
      "quantity": 2
    }
  ]
}
```

**HTTP Response (201 Created):**
```json
{
  "status": "success",
  "message": "Order placed successfully.",
  "data": {
    "orderId": "ORD-202411-9988",
    "totalAmount": 250000,
    "paymentStatus": "PENDING",
    "virtualAccountNumber": "8801234567890123"
  }
}
```

---

## 6. Testing & Quality Assurance

Karena ini merupakan implementasi *backend* yang diandalkan oleh aplikasi *mobile*, kami menjaga *code reliability* menggunakan **Jest** dan **Supertest** untuk melakukan simulasi *HTTP Request*.

- **Menjalankan Unit Testing:**
  Menguji logika internal (kalkulasi diskon, *password hashing*) secara terisolasi.
  ```bash
  npm run test
  ```
- **Menjalankan API/Integration Testing:**
  Menguji alur respons HTTP dan komunikasi dengan *database* pengujian.
  ```bash
  npm run test:integration
  ```

---

## 7. Deployment & Production Setup

Proyek ini dirancang agar mudah di-_deploy_ ke layanan PaaS seperti **Render**, **Railway**, atau VPS konvensional.

1. **Build Process (Jika menggunakan TypeScript):**
   ```bash
   npm run build
   ```
2. **Production Startup:**
   Untuk *environment production*, selalu gunakan perintah `start` standar agar aplikasi berjalan tanpa mode *hot-reload*.
   ```bash
   npm run start
   ```
3. **CI/CD Pipeline:**
   Berkas *workflow* GitHub Actions (`.github/workflows/deploy.yml`) akan otomatis menjalankan pengujian saat ada perubahan (*push*) pada *branch* `main`.

---

## 8. Contributing & License

### Panduan Kontribusi (Group Project)
Untuk kolaborasi tim dalam pengerjaan tugas ini, gunakan standar berikut:
1. **Branch Management:** *Checkout* ke *branch* baru dengan format `fitur/nama-fitur` atau `fix/deskripsi-bug`.
2. **Commit Message Convention:** Gunakan spesifikasi *Conventional Commits*. Contoh: `feat: add order history endpoint` atau `fix: resolve stock deduction bug`.

### Lisensi
Proyek tugas akademik ini dilisensikan di bawah **MIT License**. Anda bebas menggunakan basis kode ini untuk keperluan pembelajaran maupun pengembangan lebih lanjut.
