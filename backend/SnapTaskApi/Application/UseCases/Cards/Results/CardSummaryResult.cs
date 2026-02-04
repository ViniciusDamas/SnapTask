using SnapTaskApi.Domain.Entities.Cards;

namespace SnapTaskApi.Application.UseCases.Cards.Results;
public record CardSummaryResult(
    Guid Id,
    string Title,
    string? Description,
    int Order,
    Guid ColumnId,
    CardStatus Status
);