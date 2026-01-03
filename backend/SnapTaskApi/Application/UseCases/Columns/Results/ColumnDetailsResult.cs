namespace SnapTaskApi.Application.UseCases.Columns.Results;

using SnapTaskApi.Application.UseCases.Cards.Results;

public record ColumnDetailsResult(
    Guid Id,
    string Name,
    int Order,
    List<CardSummaryResult> Cards
);