namespace SnapTaskApi.Application.UseCases.Boards.Results;

using SnapTaskApi.Application.UseCases.Columns.Results;

public record BoardDetailsResult(
    Guid Id,
    string Name,
    DateTime CreatedAt,
    List<ColumnDetailsResult> Columns
);