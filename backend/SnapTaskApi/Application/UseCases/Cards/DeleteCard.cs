using SnapTaskApi.Application.Abstractions.Repositories;

namespace SnapTaskApi.Application.UseCases.Cards;

public class DeleteCard
{
    private readonly ICardRepository repository;

    public DeleteCard(ICardRepository repository) => this.repository = repository;

    public async Task<bool> DeleteCardAsync(Guid id)
    {
        var card = await repository.GetByIdAsync(id);
        if (card is null) return false;

        await repository.DeleteAsync(card);
        await repository.SaveChangesAsync();

        return true;
    }
}
