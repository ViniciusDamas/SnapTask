namespace SnapTaskApi.Application.UseCases.Cards;

using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Application.Abstractions.Repositories;


public class GetCardById
{
    private readonly ICardRepository repository;

    public GetCardById(ICardRepository repository) => this.repository = repository;

    public Task<Card?> GetByCardIdAsync(Guid id) => repository.GetByIdAsync(id);
}
