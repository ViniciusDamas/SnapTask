namespace SnapTaskApi.Application.UseCases.Columns;

using SnapTaskApi.Application.Abstractions.Repositories;

public class UpdateColumn
{
    private readonly IColumnRepository repository;

    public UpdateColumn(IColumnRepository repository) => this.repository = repository;
    public async Task<bool> UpdateAsync(Guid id, string name)
    {
        var column = await repository.GetByIdAsync(id);
        if (column is null) return false;

        column.Name = name.Trim();
        await repository.SaveChangesAsync();

        return true;
    }
}
