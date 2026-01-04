namespace SnapTaskApi.Application.UseCases.Columns.Results;

public record ColumnSummaryResult
(
    Guid Id,
    string Name,
    int Order,
    Guid BoardId
);
