using System.Net;
using System.Net.Http.Json;
using FluentAssertions;
using SnapTaskApi.IntegrationTests.Infrastructure;
using Xunit;

namespace SnapTaskApi.IntegrationTests.Columns;

public class ColumnsCrudTests : IClassFixture<ApiFactory>
{
    private readonly HttpClient _client;

    public ColumnsCrudTests(ApiFactory factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task POST_creates_column_and_returns_payload()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board for Columns");

        var response = await _client.PostAsJsonAsync("/api/columns", new { boardId = board.Id, name = "To Do" });
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        var body = await response.Content.ReadFromJsonAsync<ColumnSummary>();
        body.Should().NotBeNull();
        body!.Name.Should().Be("To Do");
        body.BoardId.Should().Be(board.Id);
    }

    [Fact]
    public async Task GET_by_id_returns_column_details()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board for Get Column");
        var column = await CreateColumnAsync(board.Id, "Doing");

        var response = await _client.GetAsync($"/api/columns/{column.Id}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var body = await response.Content.ReadFromJsonAsync<ColumnDetails>();
        body.Should().NotBeNull();
        body!.Id.Should().Be(column.Id);
        body.Name.Should().Be("Doing");
    }

    [Fact]
    public async Task PUT_updates_column_name()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board for Update Column");
        var column = await CreateColumnAsync(board.Id, "Old Column");

        var response = await _client.PutAsJsonAsync($"/api/columns/{column.Id}", new { name = "New Column" });
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);

        var get = await _client.GetAsync($"/api/columns/{column.Id}");
        get.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await get.Content.ReadFromJsonAsync<ColumnDetails>();
        body!.Name.Should().Be("New Column");
    }

    [Fact]
    public async Task DELETE_removes_column()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board for Delete Column");
        var column = await CreateColumnAsync(board.Id, "Remove Column");

        var response = await _client.DeleteAsync($"/api/columns/{column.Id}");
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);

        var get = await _client.GetAsync($"/api/columns/{column.Id}");
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

    private async Task<ColumnSummary> CreateColumnAsync(Guid boardId, string name)
    {
        var response = await _client.PostAsJsonAsync("/api/columns", new { boardId, name });
        response.StatusCode.Should().Be(HttpStatusCode.Created);
        var column = await response.Content.ReadFromJsonAsync<ColumnSummary>();
        column.Should().NotBeNull();
        return column!;
    }

    private sealed class BoardSummary
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }

    private sealed class ColumnSummary
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Order { get; set; }
        public Guid BoardId { get; set; }
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
