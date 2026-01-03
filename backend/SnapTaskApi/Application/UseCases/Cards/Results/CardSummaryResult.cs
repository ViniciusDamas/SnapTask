namespace SnapTaskApi.Application.UseCases.Cards.Results;
public record CardSummaryResult(
    Guid Id,
    string Title,
    string? Description,
    int Order,
    Guid ColumnId
);