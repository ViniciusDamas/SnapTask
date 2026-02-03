using System.Net;
using System.Net.Http.Json;
using FluentAssertions;
using SnapTaskApi.IntegrationTests.Infrastructure;
using Xunit;

namespace SnapTaskApi.IntegrationTests.Boards;

public class BoardsCrudTests : IClassFixture<ApiFactory>
{
    private readonly HttpClient _client;

    public BoardsCrudTests(ApiFactory factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GET_all_returns_boards_for_current_user()
    {
        var userId = TokenFactory.SetBearerToken(_client);

        var board1 = await CreateBoardAsync("Board 1");
        var board2 = await CreateBoardAsync("Board 2");

        var response = await _client.GetAsync("/api/boards");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var boards = await response.Content.ReadFromJsonAsync<List<BoardSummary>>();
        boards.Should().NotBeNull();
        boards!.Should().Contain(b => b.Id == board1.Id && b.OwnerUserId == userId);
        boards.Should().Contain(b => b.Id == board2.Id && b.OwnerUserId == userId);
    }

    [Fact]
    public async Task GET_by_id_returns_board_details()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board Details");

        var response = await _client.GetAsync($"/api/boards/{board.Id}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var body = await response.Content.ReadFromJsonAsync<BoardDetails>();
        body.Should().NotBeNull();
        body!.Id.Should().Be(board.Id);
        body.Name.Should().Be("Board Details");
    }

    [Fact]
    public async Task PUT_updates_board_name()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Old Name");

        var response = await _client.PutAsJsonAsync($"/api/boards/{board.Id}", new { name = "New Name" });
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);

        var get = await _client.GetAsync($"/api/boards/{board.Id}");
        get.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await get.Content.ReadFromJsonAsync<BoardDetails>();
        body!.Name.Should().Be("New Name");
    }

    [Fact]
    public async Task DELETE_removes_board()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Delete Me");

        var response = await _client.DeleteAsync($"/api/boards/{board.Id}");
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);

        var get = await _client.GetAsync($"/api/boards/{board.Id}");
        get.StatusCode.Should().Be(HttpStatusCode.NotFound);
    }

    private async Task<BoardSummary> CreateBoardAsync(string name)
    {
        var response = await _client.PostAsJsonAsync("/api/boards", new { name });
        response.StatusCode.Should().Be(HttpStatusCode.Created);
        var board = await response.Content.ReadFromJsonAsync<BoardSummary>();
        board.Should().NotBeNull();
        return board!;
    }

    private sealed class BoardSummary
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public Guid OwnerUserId { get; set; }
    }

    private sealed class BoardDetails
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public List<ColumnDetails> Columns { get; set; } = new();
    }

    private sealed class ColumnDetails
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Order { get; set; }
        public List<CardSummary> Cards { get; set; } = new();
    }

    private sealed class CardSummary
    {
        public Guid Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public int Order { get; set; }
        public Guid ColumnId { get; set; }
    }
}
