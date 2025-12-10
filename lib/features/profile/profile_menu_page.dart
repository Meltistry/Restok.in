import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Import service dan model
import 'package:restokin/data/services/auth_service.dart';
import 'package:restokin/data/services/user_service.dart';
import 'package:restokin/data/models/user_model.dart';

// Ubah menjadi StatefulWidget
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Instance service
  final AuthService _authService = AuthService();
  final ProfileService _userService = ProfileService();

  // State untuk data dan loading
  UserProfile? _profile;
  bool _isLoading = true;
  String? _errorMessage;
  
  // URL avatar default jika tidak ada foto
  final String _defaultAvatarPath = 'images/avatardefault.png';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  // --- LOGIKA BUSINESS / DB: FETCH DATA ---
  Future<void> _fetchProfile() async {
    final currentUser = _authService.currentUser;
    
    if (currentUser == null) {
      if (mounted) {
        // Jika tidak ada user, redirect ke login
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
      return;
    }
    
    try {
      final profileModel = await _userService.fetchProfile(currentUser.id);
      
      if (mounted) {
        setState(() {
          _profile = profileModel;
          _isLoading = false;
        });
        if (profileModel == null) {
          // Jika user login tapi tidak ada data profil di DB
          _errorMessage = 'Profile data not found. Please complete profile setup.';
        }
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat profil: ${e.message}';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error umum: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  // --- LOGIKA LOGOUT SEBENARNYA ---
  void _handleLogout(BuildContext context) async {
    // Tunjukkan dialog loading saat logout
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF5FC0EF))),
    );
    
    await _authService.signOut();
    
    if (!mounted) return;
    
    // Hapus semua route dan navigasi ke halaman login
    Navigator.of(context).pop(); // Tutup loading dialog
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // --- WIDGET LOGOUT DIALOG ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFF53867D), 
          
          title: const Text('Logout', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black)),
          content: const Text('Are you sure you want to logout?', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF292D32))),

          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: const Color(0xFFD6F6FB), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                    onPressed: () => Navigator.of(context).pop(), 
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAF4545), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: () => _handleLogout(context), // Panggil fungsi logout sesungguhnya
                    child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: Material(
              color: const Color(0xFFD6F6FB),
              child: InkWell(
                onTap: () {
                  if (route == 'logout') {
                    _showLogoutDialog(context);
                  } else {
                    Navigator.of(context).pushNamed(route);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
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
          if (!isBottomRounded)
            Container(
              height: 2,
              color: const Color(0xFF4a6396),
              margin: const EdgeInsets.symmetric(horizontal: 1), 
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- TAMPILAN LOADING / ERROR ---
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1a2847),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF5FC0EF))),
      );
    }
    
    // Fallback data jika profil belum dibuat (tapi user login)
    final displayProfile = _profile ?? UserProfile(
      userId: _authService.currentUser?.id ?? '', 
      email: _authService.currentUser?.email ?? 'Unknown',
      username: 'Guest', 
      nickname: 'Guest', 
      description: _errorMessage ?? 'Please complete your profile',
    );
    
    // Tentukan avatar: Menggunakan CachedNetworkImage untuk URL dari DB
    final ImageProvider avatarImage = displayProfile.profilePic != null && displayProfile.profilePic!.isNotEmpty
      ? CachedNetworkImageProvider(displayProfile.profilePic!)
      : AssetImage(_defaultAvatarPath);

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a2847), 
              Color(0xFF0d1829), 
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
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 30.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF5dd9e8), width: 2)),
                      child: const Icon(Icons.chevron_left, color: Color(0xFF5dd9e8), size: 20),
                    ),
                  ),
                ),

                // --- PROFILE HEADER (MENAMPILKAN DATA DB) ---
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 40.0), 
                  child: Row(
                    children: <Widget>[
                      // Profile Image
                      CircleAvatar(
                        radius: 45, 
                        backgroundImage: avatarImage, 
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // User Name (Nickname)
                          Text(
                            displayProfile.nickname, // Menampilkan nickname dari DB
                            style: const TextStyle(
                              fontSize: 45, fontWeight: FontWeight.w700,
                              color: Color(0xFF5FC0EF), height: 1.1, 
                            ),
                          ),
                          // User Role (Description)
                          Text(
                            displayProfile.description, // Menampilkan description dari DB
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF97E3D6),
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