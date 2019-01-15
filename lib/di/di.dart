import '../model/user.dart';
import '../repository/user_repository_impl.dart';
import '../repository/user_repository.dart';
import '../repository/devotion_repository_impl.dart';
import '../repository/devotion_repository.dart';
enum Flavor {
  MOCK,
  PRO
}

/// Simple DI
class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  UserRepository get userRepository {
    switch(_flavor) {
      default: // Flavor.PRO:
        return new UserRepositoryImpl();
    }
  }

  DevotionRepository get devotionRepository {
    switch(_flavor) {
      default: // Flavor.PRO:
        return new DevotionRepositoryImpl();
    }
  }
}