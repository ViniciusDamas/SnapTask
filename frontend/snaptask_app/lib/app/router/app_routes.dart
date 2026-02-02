class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const boardDetailsPrefix = '/boards/';

  // Helper para gerar rota de detalhes
  static String boardDetails(String id) => '$boardDetailsPrefix$id';
}
