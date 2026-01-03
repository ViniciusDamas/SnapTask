using SnapTaskApi.Application.Abstractions.Repositories;

namespace SnapTaskApi.Application.UseCases.Cards;

public class UpdateCard
{
    private readonly ICardRepository repository;

    public UpdateCard(ICardRepository repository) => this.repository = repository;

    public async Task<bool> UpdateCardAsync(Guid id, string title, string description)
    {
        var card = await repository.GetByIdAsync(id);
        if (card is null) return false;

        card.Title = title.Trim();
        card.Description = description;

        await repository.SaveChangesAsync();

        return true;
    }
}
