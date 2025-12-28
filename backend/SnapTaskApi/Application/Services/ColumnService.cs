using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Domain.Entities;

namespace SnapTaskApi.Application.Services;

public class ColumnService : IColumnService
{
    private readonly IColumnRepository repository;
    private const int Gap = 1000;

    public ColumnService(IColumnRepository repository) => this.repository = repository;

    public async Task<Column> AddAsync(Guid boardId, string name)
    {
        var column = new Column
        {
            Id = Guid.NewGuid(),
            Name = name.Trim(),
            BoardId = boardId
        };

        await repository.AddAsync(column);
        await repository.SaveChangesAsync();

        return column;
    }

    public Task<Column?> GetByIdAsync(Guid id) => repository.GetByIdWithDetailsAsync(id);

    public Task<bool> MoveAsync(Guid columnId, Guid boardId, int toOrder)
    {
        throw new NotImplementedException();
    }

    public async Task<bool> UpdateAsync(Guid id, string name)
    {
        var column = await GetByIdAsync(id);
        if (column is null) return false;

        column.Name = name.Trim();
        await repository.SaveChangesAsync();

        return true;
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var column = await GetByIdAsync(id);
        if (column is null) return false;

        await repository.DeleteAsync(column); 
        await repository.SaveChangesAsync();

        return true;
    }
}
