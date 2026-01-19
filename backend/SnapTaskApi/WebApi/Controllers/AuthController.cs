using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Infrastructure.Identity;
using SnapTaskApi.WebApi.Contracts.Requests.Login;
using SnapTaskApi.WebApi.Security;

namespace SnapTaskApi.WebApi.Controllers;

[ApiController]
[Route("auth")]
public class AuthController : ControllerBase
{
    private readonly UserManager<ApplicationUser> users;
    private readonly JwtTokenService jwt;

    public AuthController(UserManager<ApplicationUser> users, JwtTokenService jwt)
    {
        this.users = users;
        this.jwt = jwt;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest req)
    {
        var user = await users.FindByEmailAsync(req.Email);
        if (user is null) return Unauthorized();

        var ok = await users.CheckPasswordAsync(user, req.Password);
        if (!ok) return Unauthorized();

        var token = jwt.CreateAccessToken(user);

        return Ok(new { token });
    }

    [Authorize]
    [HttpGet("me")]
    public IActionResult Me()
        => Ok(new
        {
            Id = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value,
            Email = User.Identity?.Name
        });
}
