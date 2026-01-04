namespace SnapTaskApi.Application.UseCases.Boards.Results;

public record BoardSummaryResult
(
    Guid Id,
    string Name,
    DateTime CreatedAt
);
