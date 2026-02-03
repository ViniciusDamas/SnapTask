using System.Net;
using System.Net.Http.Json;
using FluentAssertions;
using SnapTaskApi.IntegrationTests.Infrastructure;
using Xunit;

namespace SnapTaskApi.IntegrationTests.Boards;

public class CreateBoardTests : IClassFixture<ApiFactory>
{
    private readonly HttpClient _client;

    public CreateBoardTests(ApiFactory factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task POST_create_board_returns_201_and_board_payload()
    {
        const string CreateUrl = "/api/boards";

        TestAuth.SetBearerToken(_client);

        var payload = new
        {
            name = "Board Teste"
        };

        var response = await _client.PostAsJsonAsync(CreateUrl, payload);

        response.StatusCode.Should().Be(HttpStatusCode.Created);

        var body = await response.Content.ReadFromJsonAsync<BoardResponse>();
        body.Should().NotBeNull();
        body!.Id.Should().NotBeNullOrWhiteSpace();
        body.Name.Should().Be("Board Teste");
    }

    private sealed class BoardResponse
    {
        public string Id { get; set; } = default!;
        public string Name { get; set; } = default!;
        public DateTime? CreatedAt { get; set; }
    }
}


