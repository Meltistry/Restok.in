import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // --- WIDGET LOGOUT DIALOG (Menggantikan Bootstrap Modal) ---
// Di file profilepage.dart Anda, ganti seluruh body fungsi _showLogoutDialog:

// Di file profilepage.dart Anda, ganti seluruh body fungsi _showLogoutDialog:

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Menggantikan .custom-modal-content (background: #53867D)
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF53867D), // #53867D
        
        // Header dan Konten (Sudah Benar)
        title: const Text(
          'Logout', 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32, 
            fontWeight: FontWeight.w700, 
            color: Colors.black 
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?', 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16, 
            color: Color(0xFF292D32)
          ),
        ),

        // --- ACTIONS / TOMBOL (DIUBAH KE STACKED/VERTIKAL) ---
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Biarkan Column mengambil ruang seminimal mungkin
              crossAxisAlignment: CrossAxisAlignment.stretch, // KUNCI: Membuat tombol mengambil lebar penuh
              children: [
                // Tombol Cancel (Menggantikan .modal-cancel-btn)
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFD6F6FB), // #D6F6FB
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                  onPressed: () => Navigator.of(context).pop(), 
                ),
                
                const SizedBox(height: 10), // Jarak antara tombol

                // Tombol Logout (Menggantikan .modal-logout-btn)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAF4545), // #AF4545
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                  },
                  child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
        
        // actionsAlignment dihapus atau diabaikan karena kita menggunakan Column.
        actionsAlignment: MainAxisAlignment.center, // Tetap gunakan ini jika Anda ingin memastikan alignment Row yang lama, tapi ini tidak relevan dengan Column
      );
    },
  );
}

  // --- WIDGET MENU ITEM CUSTOM (Menggantikan .menu-item) ---
  Widget _buildMenuItem(
    BuildContext context, 
    String title, 
    String route, 
    {bool isLogout = false, bool isTopRounded = false, bool isBottomRounded = false}
  ) {
    final defaultColor = const Color(0xFF00687A);
    final logoutColor = const Color(0xFFAF4545);
    final itemColor = isLogout ? logoutColor : defaultColor;
    
    final borderRadius = BorderRadius.vertical(
      top: isTopRounded ? const Radius.circular(12) : Radius.zero,
      bottom: isBottomRounded ? const Radius.circular(12) : Radius.zero,
    );

    return Padding(
      // Padding di kiri kanan untuk daftar menu (Menggantikan .profile-menu-list padding)
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: Material( // Menggunakan Material untuk efek hover/splash bawaan ListTile
              color: const Color(0xFFD6F6FB), // #D6F6FB
              child: InkWell(
                onTap: () {
                  if (route == 'logout') {
                    _showLogoutDialog(context);
                  } else {
                    Navigator.of(context).pushNamed(route);
                  }
                },
                // Container untuk Padding & Styling Tambahan
                child: Container(
                  // Menggantikan padding: 15px 20px
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        // Menggantikan font-size: 18px, font-weight: 500, color: #00687A
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: itemColor, 
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: itemColor, 
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Garis pemisah antar item (Menggantikan border-bottom: 2px solid #4a6396)
          if (!isBottomRounded)
            Container(
              height: 2,
              color: const Color(0xFF4a6396), // #4a6396
              margin: const EdgeInsets.symmetric(horizontal: 1), 
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menghapus AppBar default karena desain web menggunakan back button di body
      // Mengatur warna status bar agar cocok dengan background
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // Sembunyikan toolbar
      ),
      
      body: Container(
        // Linear Gradient (Menggantikan body background)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a2847), // #1a2847
              Color(0xFF0d1829), // #0d1829
            ],
          ),
        ),
        child: SafeArea( 
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- BACK BUTTON ---
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 30.0), // Padding sesuai web: pt-4, pb-3
                  child: InkWell( // Menggantikan .back-btn
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF5dd9e8), width: 2), // #5dd9e8
                      ),
                      child: const Icon(
                        Icons.chevron_left, 
                        color: Color(0xFF5dd9e8), 
                        size: 20
                      ),
                    ),
                  ),
                ),

                // --- PROFILE HEADER ---
                Padding(
                  // Padding sesuai web: px-3, mb-5
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 40.0), 
                  child: Row( // Menggantikan .profile-header
                    children: <Widget>[
                      // Profile Image (Menggantikan .profile-img)
                      const CircleAvatar(
                        radius: 45, // 90px / 2
                        backgroundImage: AssetImage('images/avatardefault.png'), // Path sesuai blade view
                      ),
                      const SizedBox(width: 15),
                      Column( // Menggantikan .profile-info
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          // User Name (Menggantikan .user-name)
                          Text(
                            'Carlos',
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5FC0EF), // #5FC0EF
                              height: 1.1, 
                            ),
                          ),
                          // User Role (Menggantikan .user-role)
                          Text(
                            'Owner of IS Store',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF97E3D6), // #97E3D6
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // --- PROFILE MENU LIST ---
                Column(
                  children: <Widget>[
                    _buildMenuItem(context, 'Edit Profile', '/profile/edit', isTopRounded: true),
                    _buildMenuItem(context, 'Change Password', '/profile/changepassword'),
                    _buildMenuItem(context, 'Payment Methods', '/profile/paymentmethods'),
                    _buildMenuItem(context, 'Logout', 'logout', isLogout: true, isBottomRounded: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}