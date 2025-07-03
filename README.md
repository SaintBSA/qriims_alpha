# QRIIMS - QR-Based Inventory Inspection & Maintenance System

**QRIIMS** adalah sebuah sistem manajemen riwayat pencatatan dan inspeksi pemeliharaan industri berbasis Android yang dirancang untuk mentransformasi proses pemeliharaan dari reaktif menjadi proaktif. Dengan integrasi QR Code dan algoritma prioritas cerdas, QRIIMS bertujuan meningkatkan efisiensi, akurasi, dan efektivitas pengambilan keputusan di lingkungan manufaktur seperti PT Multi Aneka Pangan Nusantara.

Proyek ini merupakan usulan Tugas Besar untuk Program Studi Sarjana Teknologi Informasi, Fakultas Informatika, Universitas Telkom Surabaya.

---

## ✨ Fitur Utama

-   **📱 Manajemen Aset Digital:** Tambah, lihat, edit, dan hapus data peralatan produksi secara terpusat dan digital.
-   **🔗 Integrasi QR Code Cepat:** Lakukan identifikasi alat secara instan hanya dengan memindai QR Code unik yang terpasang pada setiap aset fisik.
-   **📋 Riwayat Kondisi Lengkap:** Lacak seluruh riwayat pencatatan dan pemeliharaan untuk setiap alat secara kronologis dan terstruktur.
-   **🔐 Autentikasi Pengguna:** Sistem login yang aman untuk memastikan hanya admin dan teknisi yang berwenang yang dapat mengakses dan mengelola data.

---

## 💡 Inovasi Utama: Algoritma TUP

Masalah utama dalam pemeliharaan bukanlah sekadar "apa" yang rusak, melainkan "mana" yang harus diperbaiki terlebih dahulu. QRIIMS menjawab ini dengan **Algoritma Tingkat Urgensi Perbaikan (TUP)**.

Algoritma ini memberikan skor objektif pada setiap laporan kerusakan dengan menganalisis tiga faktor utama:

1.  **Status Kondisi Terkini:** Bobot tertinggi diberikan pada kerusakan berat.
2.  **Frekuensi Kerusakan:** Mengidentifikasi masalah kronis yang sering berulang.
3.  **Kekritisan Alat:** Membedakan dampak kerusakan antara mesin produksi utama dengan alat pendukung.

Rumus yang digunakan:
$$ \text{Skor TUP} = (P_{\text{kondisi}} \times W_{\text{kondisi}}) + (P_{\text{frekuensi}} \times W_{\text{frekuensi}}) + (P_{\text{kritis}} \times W_{\text{kritis}}) $$

Dengan algoritma ini, QRIIMS beralih dari sekadar aplikasi pencatatan menjadi **sistem pendukung keputusan** yang cerdas.

---

## 🛠️ Teknologi yang Digunakan

-   [cite_start]**Platform:** Android (Java/Kotlin) [cite: 130]
-   [cite_start]**Database:** SQLite (untuk penyimpanan data lokal yang ringan dan cepat) [cite: 133, 134]
-   [cite_start]**QR Code Scanner:** ZXing (Zebra Crossing) Library [cite: 136]
-   [cite_start]**Arsitektur Data:** CRUD (Create, Read, Update, Delete) [cite: 138]

---

## 📸 Tampilan Aplikasi

[cite_start]Berikut adalah beberapa contoh desain antarmuka aplikasi yang diusulkan[cite: 249, 250]:

| Dashboard Prioritas | Halaman Detail Alat | Form Laporan |
| :-----------------: | :-----------------: | :------------: |
| ![Dashboard](httpse://user-images.githubusercontent.com/username/repo/dashboard.png) | ![Detail](httpse://user-images.githubusercontent.com/username/repo/detail.png) | ![Form](httpse://user-images.githubusercontent.com/username/repo/form.png) |
| *(Contoh Visualisasi)* | *(Contoh Visualisasi)* | *(Contoh Visualisasi)* |

---

## 🚀 Cara Menjalankan Proyek

1.  **Prasyarat:**
    -   Android Studio (versi terbaru direkomendasikan).
    -   JDK (Java Development Kit).

2.  **Clone Repositori:**
    ```bash
    git clone [https://github.com/username/qriims.git](https://github.com/username/qriims.git)
    ```

3.  **Buka di Android Studio:**
    -   Buka Android Studio.
    -   Pilih `Open an existing Android Studio project`.
    -   Arahkan ke direktori tempat Anda meng-clone repositori.

4.  **Build Proyek:**
    -   Biarkan Gradle melakukan sinkronisasi.
    -   Jalankan proyek pada emulator atau perangkat Android fisik.

---

## 📈 Status Proyek

[cite_start]Proyek ini saat ini berada dalam tahap **proposal** yang diajukan untuk memenuhi syarat Tugas Besar di Universitas Telkom Surabaya[cite: 2]. [cite_start]Pengembangan dan implementasi penuh direncanakan akan selesai pada tahun **2025**[cite: 12, 20].

-   [cite_start]**Author:** Bhismo Surya Atmaja [cite: 5, 17]
-   [cite_start]**NIM:** 1202220048 [cite: 4, 17]

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah [Lisensi MIT](LICENSE).
