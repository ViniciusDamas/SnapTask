using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Infrastructure.Persistence;

namespace SnapTaskApi.Infrastructure.Repositories;

public class ColumnRepository : IColumnRepository
{
    private readonly AppDbContext context;

    public ColumnRepository(AppDbContext context) => this.context = context;

    public async Task AddAsync(Column column)
    {
        await context.Columns.AddAsync(column);
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


