import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/domain/models/user.dart';
import 'package:meals/domain/services/database_service.dart';

class AuthNotifier extends StateNotifier<AppUser?> {
  AuthNotifier(super.state);

  logIn(AppUser user) {
    state = user;
    DatabaseService.instance.init(user);
  }

  logOut() {
    state = null;
  }
}

final userProvider = StateProvider<AuthNotifier>((ref) {
  return AuthNotifier(null);
});
