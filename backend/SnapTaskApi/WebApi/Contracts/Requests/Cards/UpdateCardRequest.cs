namespace SnapTaskApi.Api.Contracts.Requests.Cards;

public sealed record UpdateCardRequest
{
    public required string Title { get; set; }
    public string Description {get; set;} = string.Empty;
}
