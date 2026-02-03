using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using FluentAssertions;
using SnapTaskApi.IntegrationTests.Infrastructure;
using Xunit;

namespace SnapTaskApi.IntegrationTests.Auth;

public class AuthTests : IClassFixture<ApiFactory>
{
    private readonly HttpClient _client;

    public AuthTests(ApiFactory factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task POST_register_returns_token()
    {
        var email = UniqueEmail();
        var response = await _client.PostAsJsonAsync("/auth/register", new
        {
            userName = "testuser",
            email,
            password = "Pass1234!",
            confirmPassword = "Pass1234!"
        });

        response.StatusCode.Should().Be(HttpStatusCode.Created);

        var body = await response.Content.ReadFromJsonAsync<TokenResponse>();
        body.Should().NotBeNull();
        body!.Token.Should().NotBeNullOrWhiteSpace();
    }

    [Fact]
    public async Task POST_login_returns_token()
    {
        var email = UniqueEmail();
        await _client.PostAsJsonAsync("/auth/register", new
        {
            userName = "loginuser",
            email,
            password = "Pass1234!",
            confirmPassword = "Pass1234!"
        });

        var response = await _client.PostAsJsonAsync("/auth/login", new
        {
            email,
            password = "Pass1234!",
            rememberMe = false
        });

        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var body = await response.Content.ReadFromJsonAsync<TokenResponse>();
        body.Should().NotBeNull();
        body!.Token.Should().NotBeNullOrWhiteSpace();
    }

    [Fact]
    public async Task GET_me_returns_user_info()
    {
        var email = UniqueEmail();
        var register = await _client.PostAsJsonAsync("/auth/register", new
        {
            userName = "meuser",
            email,
            password = "Pass1234!",
            confirmPassword = "Pass1234!"
        });

        var token = (await register.Content.ReadFromJsonAsync<TokenResponse>())!.Token;
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var response = await _client.GetAsync("/auth/me");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var body = await response.Content.ReadFromJsonAsync<MeResponse>();
        body.Should().NotBeNull();
        body!.Id.Should().NotBeNullOrWhiteSpace();
        body.Email.Should().NotBeNullOrWhiteSpace();
    }

    private static string UniqueEmail() => $"user_{Guid.NewGuid():N}@test.local";

    private sealed class TokenResponse
    {
        public string Token { get; set; } = string.Empty;
    }

    private sealed class MeResponse
    {
        public string Id { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
    }
}


