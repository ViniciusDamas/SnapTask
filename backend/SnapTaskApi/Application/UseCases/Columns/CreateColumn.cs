namespace SnapTaskApi.Application.UseCases.Columns;

using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Application.Abstractions.Repositories;

public class CreateColumn
{
    private readonly IColumnRepository repository;

    public CreateColumn(IColumnRepository repository) => this.repository = repository;

    public async Task<Column> AddAsync(Guid boardId, string name)
    {
        var lastOrder = await repository.GetLastOrderAsync(boardId);
        var column = new Column
        {
            Id = Guid.NewGuid(),
            Name = name.Trim(),
            Order = lastOrder + 1000,
            BoardId = boardId
        };

        await repository.AddAsync(column);
        await repository.SaveChangesAsync();

        return column;
    }
}
