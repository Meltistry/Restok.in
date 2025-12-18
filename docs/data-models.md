Data Models Mapping (Dart ↔ ERD)

Dokumen ini menjelaskan keterkaitan antara model data pada sisi aplikasi Flutter (Dart) dengan struktur entitas pada database berdasarkan ERD. Setiap bagian menjelaskan entitas, atribut utama, serta relasinya dengan entitas lain.

User
Entitas ini menyimpan data pengguna sistem, baik sebagai pemilik toko maupun restocker.

Model Dart: UserModel
Tabel database: user

Atribut:

idUser → primary key pengguna

email → email pengguna

username → username untuk login

password → password pengguna

nickname → nama tampilan

description → deskripsi profil

profilePic → foto profil

Relasi:

Satu user dapat memiliki banyak store

Satu user dapat memiliki banyak cart

Satu user dapat memiliki banyak user payment type

Store
Entitas ini merepresentasikan toko yang dimiliki oleh pengguna.

Model Dart: StoreModel
Tabel database: store

Atribut:

idStore → primary key toko

idUser → foreign key ke user

storeName → nama toko

storeAddress → alamat toko

storeEpic → gambar atau banner toko

Relasi:

Satu store dimiliki oleh satu user

Satu store memiliki banyak item

Satu store dapat menerima banyak cart

Item
Entitas ini menyimpan informasi produk yang dijual oleh toko.

Model Dart: ItemModel
Tabel database: item

Atribut:

idItem → primary key item

idStore → foreign key ke store

itemName → nama produk

itemPrice → harga produk

Relasi:

Satu item dimiliki oleh satu store

Satu item dapat muncul di banyak cart melalui cart item

Cart
Entitas ini menyimpan keranjang belanja pengguna.

Model Dart: CartModel
Tabel database: cart

Atribut:

idCart → primary key cart

idUser → foreign key ke user

idStore → foreign key ke store

date → tanggal pembuatan cart

status → status cart

restockProof → bukti restock

Relasi:

Satu cart dimiliki oleh satu user

Satu cart terkait dengan satu store

Satu cart memiliki banyak cart item

Satu cart dapat menghasilkan invoice

CartItem
Entitas penghubung antara cart dan item yang menyimpan detail isi keranjang.

Model Dart: CartItemModel
Tabel database: cart_item

Atribut:

idCartItem → primary key cart item

idCart → foreign key ke cart

idItem → foreign key ke item

quantity → jumlah item

subTotal → total harga per item

Relasi:

Banyak cart item dimiliki oleh satu cart

Banyak cart item merujuk ke satu item

Invoice
Entitas ini menyimpan informasi faktur transaksi.

Model Dart: InvoiceModel
Tabel database: invoice

Atribut:

idInvoice → primary key invoice

idCart → foreign key ke cart

idStore → foreign key ke store

invoiceDate → tanggal invoice

totalAmount → total pembayaran

status → status invoice

Relasi:

Satu invoice berasal dari satu cart

Satu invoice terkait dengan satu store

Satu invoice dapat memiliki satu atau lebih payment

Payment
Entitas ini mencatat transaksi pembayaran.

Model Dart: PaymentModel
Tabel database: payment

Atribut:

idPayment → primary key payment

idInvoice → foreign key ke invoice

idUserPaymentType → foreign key ke user payment type

amount → jumlah pembayaran

paymentDate → tanggal pembayaran

status → status pembayaran

Relasi:

Satu payment terkait dengan satu invoice

Satu payment menggunakan satu metode pembayaran user

UserPaymentType
Entitas ini menyimpan metode pembayaran yang dimiliki oleh user.

Model Dart: UserPaymentTypeModel
Tabel database: user_payment_type

Atribut:

idUserPaymentType → primary key

idUser → foreign key ke user

idPaymentType → foreign key ke payment type

paymentDetails → detail akun pembayaran

Relasi:

Satu user dapat memiliki banyak user payment type

Satu user payment type merujuk ke satu payment type

PaymentType
Entitas ini menyimpan daftar jenis metode pembayaran yang tersedia.

Model Dart: PaymentTypeModel
Tabel database: payment_type

Atribut:

idPaymentType → primary key

paymentName → nama metode pembayaran
