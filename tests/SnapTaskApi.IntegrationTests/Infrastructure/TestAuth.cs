using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace SnapTaskApi.IntegrationTests.Infrastructure;

internal static class TestAuth
{
    private const string Key = "TEST_JWT_KEY_12345678901234567890";
    private const string Issuer = "SnapTask.Test";
    private const string Audience = "SnapTask.Test";

    public static Guid SetBearerToken(HttpClient client, Guid? userId = null)
    {
        var id = userId ?? Guid.NewGuid();
        var token = CreateToken(id);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        return id;
    }

    private static string CreateToken(Guid userId)
    {
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, userId.ToString())
        };

        var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Key));
        var creds = new SigningCredentials(signingKey, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: Issuer,
            audience: Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(60),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
