import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/app_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Pre-fill from AppState so the form always shows current values
  late final TextEditingController _nameCtrl  =
      TextEditingController(text: AppState.instance.profileName);
  late final TextEditingController _emailCtrl =
      TextEditingController(text: AppState.instance.profileEmail);
  late final TextEditingController _phoneCtrl =
      TextEditingController(text: AppState.instance.profilePhone);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name  = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Name and email cannot be empty.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    // Update AppState — Account Screen reads from AppState and
    // will rebuild automatically because main.dart wraps everything
    // in a ListenableBuilder on AppState.
    AppState.instance.updateProfile(
      name: name,
      email: email,
      phone: phone,
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Profile updated!'),
      backgroundColor: AppColors.primaryDark,
      behavior: SnackBarBehavior.floating,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit Profile',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Avatar
          Center(
            child: Stack(alignment: Alignment.bottomRight, children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryMed,
                // Show initials from current name in AppState
                child: Text(
                  AppState.instance.profileName.isNotEmpty
                      ? AppState.instance.profileName
                          .split(' ')
                          .map((w) => w.isNotEmpty ? w[0] : '')
                          .take(2)
                          .join()
                          .toUpperCase()
                      : 'YO',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Material(
                color: AppColors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Photo upload coming soon'),
                      backgroundColor: AppColors.primaryDark,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.camera_alt_outlined,
                        size: 18, color: AppColors.primaryDark),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 28),

          _label('Full Name'),
          _field(_nameCtrl, Icons.person_outline),
          const SizedBox(height: 16),

          _label('Email Address'),
          _field(_emailCtrl, Icons.email_outlined,
              type: TextInputType.emailAddress),
          const SizedBox(height: 16),

          _label('Phone Number'),
          _field(_phoneCtrl, Icons.phone_outlined,
              type: TextInputType.phone),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Changes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _label(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(t,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark)));

  Widget _field(TextEditingController ctrl, IconData icon,
      {TextInputType? type}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider)),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: AppColors.textGrey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
