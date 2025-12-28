using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Infrastructure.Persistence;

namespace SnapTaskApi.Infrastructure.Repositories;

public class ColumnRepository : IColumnRepository
{
    private readonly AppDbContext context;

    public ColumnRepository(AppDbContext context)
    {
        this.context = context;
    }

    //Create column
    public async Task AddAsync(Column column)
    {
        await context.Columns.AddAsync(column);
    }
    //Update Column

    //Move Column

    //Delete Column


    public Task<int> SaveChangesAsync(Column colum)
    {
        return context.SaveChangesAsync();
    }
}


