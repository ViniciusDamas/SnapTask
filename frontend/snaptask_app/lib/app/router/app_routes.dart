class AppRoutes {
  // Rotas simples
  static const login = '/login';
  static const register = '/register';
  static const boards = '/boards';

  // Prefixo para rotas dinâmicas
  static const boardDetailsPrefix = '/boards/';

  // Helper para gerar rota de detalhes
  static String boardDetails(String id) => '$boardDetailsPrefix$id';
}
