namespace SnapTaskApi.Application.UseCases.Cards;

using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Contracts.Requests.Cards;
using SnapTaskApi.Domain.Entities;

public class CreateCard
{
    private readonly ICardRepository repository;

    public CreateCard(ICardRepository repository) => this.repository = repository;

    public async Task<Card> AddCardAsync(CreateCardRequest request)
    {
        var lastOrder = await repository.GetLastOrderAsync(request.ColumnId);

        var card = new Card
        {
            Title = request.Title,
            Description = request.Description,
            Order = lastOrder + 1000,
            ColumnId = request.ColumnId
        };

        await repository.AddAsync(card);
        await repository.SaveChangesAsync();

        return card;
    }
}
