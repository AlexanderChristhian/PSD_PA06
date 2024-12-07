# Proyek Akhir PSD_PA06: Image Downscaler Using Box Sampling Algorithm

## Background
Image Downscaler merupakan hardware yang dibuat untuk menurunkan ukuran sebuah gambar dengan menurunkan jumlah pikselnya. Downscaler ini menggunakan algoritma box sampling yang bekerja dengan mengelompokkan beberapa piksel dalam area tertentu dan menghitung nilai rata-rata atau representasi lain untuk menghasilkan piksel yang lebih sedikit tetapi tetap representatif. Teknologi ini sangat berguna dalam aplikasi yang memerlukan pemrosesan gambar efisien, seperti perangkat IoT atau sistem pemantauan dengan kapasitas penyimpanan terbatas.

Proyek kami bertujuan untuk mengimplementasikan fungsi downscaling sebuah gambar menggunakan VHDL. Dengan pendekatan ini, kami dapat menciptakan sistem digital yang mampu melakukan downscaling gambar secara cepat dan akurat menggunakan box sampling algorithm, tanpa bergantung pada daya komputasi CPU. Scaling factor juga akan menjadi input yang menentukan seberapa besar gambar akan di-downscale.

## How it Works
Image Downscaler bekerja dengan algoritma box sampling untuk mengurangi jumlah piksel dalam sebuah gambar sambil mempertahankan informasi visual yang penting. Berikut adalah langkah-langkah utama dari sistem ini:

### 1. Input Data:
Gambar awal, dimensi (width, height), dan parameter scaling factor diterima sebagai input.

### 2. Preprocessing:

Dimensi gambar dihitung ulang berdasarkan scaling factor menggunakan fungsi calculate_downscaled_size.
Sistem mempersiapkan sinyal internal seperti width, height, dan r_array untuk proses downscaling.

### 3. Box Sampling Algorithm:

Gambar dibagi menjadi area-area kecil sesuai scaling factor.
Untuk setiap area, nilai rata-rata atau representasi tertentu dihitung dari piksel dalam area tersebut.
Nilai ini digunakan sebagai hasil downscaled pixel.

### 4. State Machine Operation:
Sistem menggunakan state machine dengan tiga state utama:

a. IDLE: Menunggu input data siap untuk diproses. \
b. PROCESS_INPUT: Menerima input gambar dan menghitung dimensi baru. \
c. DOWNSCALE: Melakukan iterasi menggunakan loop untuk mengaplikasikan box sampling dan menyimpan hasil pada sinyal output.

### 5. Output Data:
Gambar hasil downscaling disimpan pada sinyal output (downscaled_width, downscaled_height, dan output_image), siap untuk digunakan dalam aplikasi lain.

### 6. Implementation in Hardware:
Sistem ini diimplementasikan menggunakan VHDL pada FPGA, memungkinkan parallel processing yang cepat tanpa membebani CPU. Scaling factor dapat disesuaikan sebagai parameter input untuk fleksibilitas dalam penggunaan.

## Testing and Result
### Wave:
![Wave](https://i.imgur.com/tFrNl5h.jpeg)  
Proses testing dilakukan dengan menggunakan gambar berdimensi 256x256 pixel dengan data RGB untuk setiap pixel. Downscaling diterapkan dengan faktor 8, menghasilkan gambar output berdimensi 32x32 pixel. Sistem menggunakan algoritma Box Sampling untuk menghitung rata-rata warna dari blok 8x8 pixel input, yang kemudian disalin ke gambar output. Proses diatur oleh finite state machine pada komponen ImageDownscaler, yang meliputi state IDLE, PROCESS_INPUT, dan DOWNSCALE. Status done dan downscaled_done diset setelah proses selesai, menandakan bahwa output sudah siap digunakan.

Gambar output memiliki resolusi 32x32 pixel dengan pola warna dominan yang dipertahankan dari gambar input, meskipun beberapa detail dan ketajaman gambar hilang karena metode Box Sampling yang mengutamakan efisiensi pemrosesan. Meskipun ukurannya jauh lebih kecil, gambar output tetap merepresentasikan kualitas warna input secara baik, menjadikannya cocok untuk aplikasi yang memerlukan penghematan bandwidth dan penyimpanan.

### Gambar:
| Input | Output |
|---|---|
|![picture 1](https://i.imgur.com/7ReiCT4.jpeg)|![picture 2](https://i.imgur.com/Vxe43eG.jpeg)  

  
