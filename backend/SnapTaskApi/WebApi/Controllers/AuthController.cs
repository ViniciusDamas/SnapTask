using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Infrastructure.Identity;
using SnapTaskApi.WebApi.Contracts.Requests.Auth;
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

    [AllowAnonymous]
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest req)
    {
        if (!string.IsNullOrWhiteSpace(req.ConfirmPassword) && req.Password != req.ConfirmPassword)
        {
            return BadRequest(new
            {
                error = "PasswordConfirmationMismatch",
                message = "Password e ConfirmPassword não conferem."
            });
        }

        var existing = await users.FindByEmailAsync(req.Email);
        if (existing is not null)
        {
            return Conflict(new
            {
                error = "EmailAlreadyInUse",
                message = "Já existe um usuário cadastrado com este e-mail."
            });
        }

        var user = new ApplicationUser
        {
            Email = req.Email,
            UserName = req.UserName,
        };

        var result = await users.CreateAsync(user, req.Password);
        if (!result.Succeeded)
        {
            return BadRequest(new
            {
                errors = result.Errors.Select(e => new { code = e.Code, description = e.Description })
            });
        }

        var token = jwt.CreateAccessToken(user);

        return Created(string.Empty, new { token });
    }

    [AllowAnonymous]
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest req)
    {
        var user = await users.FindByEmailAsync(req.Email);
        if (user is null) return Unauthorized("Email ou senha incorretos");

        var ok = await users.CheckPasswordAsync(user, req.Password);
        if (!ok) return Unauthorized("Email ou senha incorretos");

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
