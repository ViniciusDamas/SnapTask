namespace SnapTaskApi.Infrastructure.Repositories;

using SnapTaskApi.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Infrastructure.Persistence;
using SnapTaskApi.Application.Abstractions.Repositories;

public class ColumnRepository : IColumnRepository
{
    private readonly AppDbContext context;

    public ColumnRepository(AppDbContext context) => this.context = context;

    public async Task AddAsync(Column column)
    {
        await context.Columns.AddAsync(column);
    }

    public async Task<int> GetLastOrderAsync(Guid boardId)
    {
        var lastOrder = await context.Columns
        .Where(c => c.BoardId == boardId)
        .MaxAsync(c => (int?)c.Order);

        return lastOrder ?? 0;
    }

    public async Task<Column?> GetByIdWithDetailsAsync(Guid id)
    {
        return await context.Columns
            .Include(c => c.Cards)
            .FirstOrDefaultAsync(c => c.Id == id);
    }

    public async Task<Column?> GetByIdAsync(Guid id)
    {
        return await context.Columns.FirstOrDefaultAsync(c => c.Id == id);
    }

    //Move Column

    public Task DeleteAsync(Column column)
    {
        context.Columns.Remove(column); 
        return Task.CompletedTask;
    }

    public Task<int> SaveChangesAsync()
    {
        return context.SaveChangesAsync();
    }
}


