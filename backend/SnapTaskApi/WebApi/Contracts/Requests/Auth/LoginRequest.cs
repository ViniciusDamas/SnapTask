namespace SnapTaskApi.WebApi.Contracts.Requests.Login;

public record LoginRequest(string Email, string Password, bool RememberMe);