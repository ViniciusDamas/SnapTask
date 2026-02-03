namespace SnapTaskApi.Api.Contracts.Requests.Boards;

public sealed record CreateBoardRequest
{
    public required string Name { get; set; }
}