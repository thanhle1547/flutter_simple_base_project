class AppAuthenticationBinding {
  static AppAuthenticationBinding? get instance => _instance;
  static AppAuthenticationBinding? _instance;

  static void initInstance() => _instance = AppAuthenticationBinding._();

  AppAuthenticationBinding._();

  final List<AppAuthenticationBindingObserver> _observers =
      <AppAuthenticationBindingObserver>[];

  void addObserver(AppAuthenticationBindingObserver observer) =>
      _observers.add(observer);

  bool removeObserver(AppAuthenticationBindingObserver observer) =>
      _observers.remove(observer);

  void notifyTokenChanged() {
    for (final AppAuthenticationBindingObserver observer in _observers) {
      observer.didChangeAccessToken();
      observer.didAuthenticationFailed();
    }
  }
}

abstract class AppAuthenticationBindingObserver {
  void didChangeAccessToken() {}

  void didAuthenticationFailed() {}
}
