using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Domain.Entities;

namespace SnapTaskApi.Application.Services;

public class ColumnService : IColumnService
{
    private readonly IColumnRepository repository;

    public ColumnService(IColumnRepository repository)
    {
        this.repository = repository;
    }

    public async Task<Column> AddAsync(Guid boardId, string name)
    {
        var column = new Column
        {
            Id = Guid.NewGuid(),
            Name = name.Trim(),
            BoardId = boardId
        };

        await repository.AddAsync(column);
        await repository.SaveChangesAsync(column);

        return column;
    }

    public Task<Column> GetByColumnId(Guid id)
    {
        throw new NotImplementedException();
    }

    public Task<bool> MoveAsync(Guid columnId, Guid boardId, int toOrder)
    {
        throw new NotImplementedException();
    }

    public Task<bool> UpdateAsync(Guid id, string name)
    {
        throw new NotImplementedException();
    }
}
