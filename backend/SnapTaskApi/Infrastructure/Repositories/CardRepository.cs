namespace SnapTaskApi.Infrastructure.Repositories;

using SnapTaskApi.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Infrastructure.Persistence;
using SnapTaskApi.Application.Abstractions.Repositories;

public class CardRepository : ICardRepository
{
    private readonly AppDbContext context;

    public CardRepository(AppDbContext context) => this.context = context;

    public async Task AddAsync(Card card) => await context.Cards.AddAsync(card);

    public async Task<int> GetLastOrderAsync(Guid columnId)
    {
        int? lastOrder = await context.Cards
        .Where(c => c.ColumnId == columnId)
        .MaxAsync(c => (int?)c.Order);

        return lastOrder ?? 0;
    }

    public Task<int> SaveChangesAsync()
    {
        return context.SaveChangesAsync();
    }
}
