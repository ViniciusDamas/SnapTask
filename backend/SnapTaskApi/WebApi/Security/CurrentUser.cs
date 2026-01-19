namespace SnapTaskApi.WebApi.Security;
using SnapTaskApi.Application.Abstractions.CurrentUser;
using System.Security.Claims;

public class CurrentUser : ICurrentUser
{
    private readonly IHttpContextAccessor _http;

    public CurrentUser(IHttpContextAccessor http)
        => _http = http;

    public bool IsAuthenticated =>
        _http.HttpContext?.User?.Identity?.IsAuthenticated ?? false;

    public Guid UserId
    {
        get
        {
            var value = _http.HttpContext?
                .User
                .FindFirst(ClaimTypes.NameIdentifier)
                ?.Value;

            return value is null ? Guid.Empty : Guid.Parse(value);
        }
    }
}

