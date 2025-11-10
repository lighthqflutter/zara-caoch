import 'package:flutter/foundation.dart';

/// User role enum
enum UserRole {
  child,
  parent,
}

/// Authentication and role management provider
class AuthProvider extends ChangeNotifier {
  UserRole? _currentRole;
  bool _isAuthenticated = false;

  UserRole? get currentRole => _currentRole;
  bool get isAuthenticated => _isAuthenticated;
  bool get isChild => _currentRole == UserRole.child;
  bool get isParent => _currentRole == UserRole.parent;

  /// Set user role (child or parent)
  void setRole(UserRole role) {
    _currentRole = role;
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Logout / clear role
  void logout() {
    _currentRole = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Verify parent password (simplified for MVP)
  /// TODO: Replace with actual authentication in production
  bool verifyParentPassword(String password) {
    // For MVP, use a simple password
    // In production, this should use Firebase Auth
    const String correctPassword = 'parent123';

    if (password == correctPassword) {
      setRole(UserRole.parent);
      return true;
    }
    return false;
  }
}
