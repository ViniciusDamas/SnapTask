using System.Net;
using System.Net.Http.Json;
using FluentAssertions;
using SnapTaskApi.IntegrationTests.Infrastructure;
using Xunit;

namespace SnapTaskApi.IntegrationTests.Cards;

public class CardsCrudTests : IClassFixture<ApiFactory>
{
    private readonly HttpClient _client;

    public CardsCrudTests(ApiFactory factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task POST_creates_card_and_returns_payload()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board for Cards");
        var column = await CreateColumnAsync(board.Id, "To Do");

        var response = await _client.PostAsJsonAsync("/api/cards", new { title = "Card 1", description = "Desc", columnId = column.Id });
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        var body = await response.Content.ReadFromJsonAsync<CardSummary>();
        body.Should().NotBeNull();
        body!.Title.Should().Be("Card 1");
        body.Description.Should().Be("Desc");
        body.ColumnId.Should().Be(column.Id);
    }

    [Fact]
    public async Task GET_by_id_returns_card_details()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board for Get Card");
        var column = await CreateColumnAsync(board.Id, "Doing");
        var card = await CreateCardAsync(column.Id, "Card A", "Desc A");

        var response = await _client.GetAsync($"/api/cards/{card.Id}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var body = await response.Content.ReadFromJsonAsync<CardSummary>();
        body.Should().NotBeNull();
        body!.Id.Should().Be(card.Id);
        body.Title.Should().Be("Card A");
    }

    [Fact]
    public async Task PUT_updates_card()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board for Update Card");
        var column = await CreateColumnAsync(board.Id, "Doing");
        var card = await CreateCardAsync(column.Id, "Old Title", "Old Desc");

        var response = await _client.PutAsJsonAsync($"/api/cards/{card.Id}", new { title = "New Title", description = "New Desc" });
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);

        var get = await _client.GetAsync($"/api/cards/{card.Id}");
        get.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await get.Content.ReadFromJsonAsync<CardSummary>();
        body!.Title.Should().Be("New Title");
        body.Description.Should().Be("New Desc");
    }

    [Fact]
    public async Task DELETE_removes_card()
    {
        TokenFactory.SetBearerToken(_client);
        var board = await CreateBoardAsync("Board for Delete Card");
        var column = await CreateColumnAsync(board.Id, "Done");
        var card = await CreateCardAsync(column.Id, "Card Delete", null);

        var response = await _client.DeleteAsync($"/api/cards/{card.Id}");
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);

        var get = await _client.GetAsync($"/api/cards/{card.Id}");
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

    private async Task<CardSummary> CreateCardAsync(Guid columnId, string title, string? description)
    {
        var response = await _client.PostAsJsonAsync("/api/cards", new { title, description, columnId });
        response.StatusCode.Should().Be(HttpStatusCode.Created);
        var card = await response.Content.ReadFromJsonAsync<CardSummary>();
        card.Should().NotBeNull();
        return card!;
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

    private sealed class CardSummary
    {
        public Guid Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public int Order { get; set; }
        public Guid ColumnId { get; set; }
    }
}
