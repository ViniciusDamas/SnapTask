namespace SnapTaskApi.Infrastructure.Repositories;

using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Cards.Results;
using SnapTaskApi.Application.UseCases.Columns.Results;
using SnapTaskApi.Domain.Entities.Columns;
using SnapTaskApi.Infrastructure.Persistence;

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

    public async Task<ColumnDetailsResult?> GetByIdWithDetailsAsync(Guid id)
    {
        return await context.Columns
            .AsNoTracking()
            .Where(c => c.Id == id)
            .Select(c => new ColumnDetailsResult(
                c.Id,
                c.Name,
                c.Order,
                c.Cards
                    .OrderBy(x => x.Order)
                    .Select(x => new CardSummaryResult(
                        x.Id,
                        x.Title,
                        x.Description,
                        x.Order,
                        x.ColumnId,
                        x.Status
                        )
            ).ToList()))
            .FirstOrDefaultAsync();
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


