using SnapTaskApi.Domain.Entities.Cards;

namespace SnapTaskApi.WebApi.Contracts.Requests.Cards;

public sealed record UpdateCardStatusRequest(CardStatus Status);
