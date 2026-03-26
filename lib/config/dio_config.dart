class DioConfig {
  final int connectTimeoutSeconds;
  final int receiveTimeoutSeconds;
  final Map<String, String> headers;

  const DioConfig({
    this.connectTimeoutSeconds = 30,
    this.receiveTimeoutSeconds = 30,
    this.headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });

  static const defaultConfig = DioConfig();
}
