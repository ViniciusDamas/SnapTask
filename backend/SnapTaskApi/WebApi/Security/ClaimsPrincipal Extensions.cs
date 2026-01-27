using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;

namespace SnapTaskApi.Infrastructure.Security;

public static class ClaimsPrincipalExtensions
{
    public static Guid GetRequiredUserId(this ClaimsPrincipal user)
    {
        var userId =
            user.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? user.FindFirstValue(JwtRegisteredClaimNames.Sub);

        if (string.IsNullOrWhiteSpace(userId))
            throw new UnauthorizedAccessException("UserId não encontrado no token.");

        return Guid.Parse(userId);
    }
}
