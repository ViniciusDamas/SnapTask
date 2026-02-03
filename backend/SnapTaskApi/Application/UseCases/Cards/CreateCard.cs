namespace SnapTaskApi.Application.UseCases.Cards;

using SnapTaskApi.Api.Contracts.Requests.Cards;
using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Cards.Results;
using SnapTaskApi.Domain.Entities.Cards;

public class CreateCard
{
    private readonly ICardRepository repository;

    public CreateCard(ICardRepository repository) => this.repository = repository;

    public async Task<CardSummaryResult> AddCardAsync(CreateCardRequest request)
    {
        var lastOrder = await repository.GetLastOrderAsync(request.ColumnId);

        var card = new Card
        {
            Id = Guid.NewGuid(),
            Title = request.Title.Trim(),
            Description = request.Description,
            Order = lastOrder + 1000,
            ColumnId = request.ColumnId
        };

        await repository.AddAsync(card);
        await repository.SaveChangesAsync();

        return new CardSummaryResult(card.Id, card.Title, card.Description, card.Order, card.ColumnId, card.Status);
    }
}
