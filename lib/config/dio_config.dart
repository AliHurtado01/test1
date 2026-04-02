class DioConfig {
  final int connectTimeoutSeconds;
  final int receiveTimeoutSeconds;
  final Map<String, String> headers;
  final bool useMock; // Variable del interceptor

  const DioConfig({
    this.connectTimeoutSeconds = 30,
    this.receiveTimeoutSeconds = 30,
    this.headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.useMock = true, //Valor del interceptor por defecto
  });

  static const defaultConfig = DioConfig();
}