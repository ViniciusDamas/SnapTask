namespace SnapTaskApi.Application.Abstractions.Repositories;

using SnapTaskApi.Domain.Entities;
public interface ICardRepository
{
    Task AddAsync(Card card);
    Task<int> GetLastOrderAsync(Guid columnId);
    Task<int> SaveChangesAsync();
}
