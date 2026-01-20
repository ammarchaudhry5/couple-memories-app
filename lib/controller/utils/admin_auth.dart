import 'package:shared_preferences/shared_preferences.dart';

class AdminAuth {
  // Default admin credentials (should be changed in production)
  static const String defaultUsername = 'admin';
  static const String defaultPassword = 'admin123';
  static const String _usernameKey = 'admin_username';
  static const String _passwordKey = 'admin_password';

  /// Check if credentials are set
  static Future<bool> hasCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_usernameKey) && prefs.containsKey(_passwordKey);
  }

  /// Set admin credentials
  static Future<bool> setCredentials(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, username);
      await prefs.setString(_passwordKey, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get stored username
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? defaultUsername;
  }

  /// Validate credentials
  static Future<bool> validateCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString(_usernameKey) ?? defaultUsername;
    final storedPassword = prefs.getString(_passwordKey) ?? defaultPassword;
    
    return username == storedUsername && password == storedPassword;
  }

  /// Reset to default credentials
  static Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
  }
}
