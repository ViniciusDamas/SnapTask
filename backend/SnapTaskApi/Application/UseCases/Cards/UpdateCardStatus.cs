using Microsoft.OpenApi;
using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Domain.Entities.Cards;

namespace SnapTaskApi.Application.UseCases.Cards;

public class UpdateCardStatus
{
    private readonly ICardRepository repository;

    public UpdateCardStatus(ICardRepository repository) => this.repository = repository;

    public async Task<bool> UpdateStatusAsync(Guid cardId, CardStatus status)
    {
        var card = await repository.GetByIdAsync(cardId);
        if (card is null) return false;

        if (card.Status == status) return false;

        card.SetStatus(status);

        await repository.SaveChangesAsync();
        return true;
    }

}
