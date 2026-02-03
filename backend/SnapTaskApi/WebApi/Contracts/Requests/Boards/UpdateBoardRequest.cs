namespace SnapTaskApi.Api.Contracts.Requests.Boards;

public sealed record UpdateBoardRequest
{
    public required string Name { get; set; }
}