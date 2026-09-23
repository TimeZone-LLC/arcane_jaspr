import 'dart:async';

import 'package:arcane_jaspr/flutter.dart';

import '../service/auth_service_stub.dart';
import '../service/auth_state.dart';

class _AuthInheritedProvider extends InheritedWidget {
  final AuthState state;

  const _AuthInheritedProvider({required this.state, required super.child});

  static _AuthInheritedProvider? of(BuildContext context) {
    return context
        .dependOnInheritedComponentOfExactType<_AuthInheritedProvider>();
  }

  @override
  bool updateShouldNotify(_AuthInheritedProvider oldComponent) {
    return state.status != oldComponent.state.status ||
        state.user?.uid != oldComponent.state.user?.uid ||
        state.error != oldComponent.state.error;
  }
}

/// Stub auth provider for non-web platforms.
class ArcaneAuthProvider extends StatefulWidget {
  final Widget child;
  final void Function(AuthState)? onAuthStateChanged;
  final String? redirectOnLogin;
  final String? redirectOnLogout;
  final String? serverApiUrl;

  const ArcaneAuthProvider({
    required this.child,
    this.onAuthStateChanged,
    this.redirectOnLogin,
    this.redirectOnLogout,
    this.serverApiUrl,
    super.key,
  });

  @override
  State<ArcaneAuthProvider> createState() => _ArcaneAuthProviderState();
}

class _ArcaneAuthProviderState extends State<ArcaneAuthProvider> {
  final AuthState _state = const AuthState.unauthenticated();

  @override
  Widget build(BuildContext context) {
    return _AuthInheritedProvider(state: _state, child: widget.child);
  }
}

/// Extension for accessing auth state from any component.
extension AuthContextExtension on BuildContext {
  AuthState get authState {
    final _AuthInheritedProvider? provider = _AuthInheritedProvider.of(this);
    return provider?.state ?? const AuthState();
  }

  AuthUser? get currentUser => authState.user;

  bool get isAuthenticated => authState.isAuthenticated;

  bool get isAuthLoading => authState.isLoading;

  String? get uid => currentUser?.uid;

  String? get idToken => currentUser?.idToken;

  Future<void> signInWithGitHub() =>
      JasprAuthService.instance.signInWithGitHub();

  Future<void> signInWithGoogle() =>
      JasprAuthService.instance.signInWithGoogle();

  Future<void> signInWithApple() => JasprAuthService.instance.signInWithApple();

  Future<void> signInWithEmail(String email, String password) =>
      JasprAuthService.instance.signInWithEmail(email, password);

  Future<void> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) =>
      JasprAuthService.instance.registerWithEmail(email, password, displayName);

  Future<void> sendPasswordResetEmail(String email) =>
      JasprAuthService.instance.sendPasswordResetEmail(email);

  Future<void> signOut() => JasprAuthService.instance.signOut();

  Future<String?> refreshAuthToken() =>
      JasprAuthService.instance.refreshToken();

  Future<bool> deleteAccount() => JasprAuthService.instance.deleteAccount();
}
