namespace SnapTaskApi.Application.UseCases.Columns;

using SnapTaskApi.Application.Abstractions.Repositories;

public class DeleteColumn
{
    private readonly IColumnRepository repository;

    public DeleteColumn(IColumnRepository repository) => this.repository = repository;
    public async Task<bool> DeleteAsync(Guid id)
    {
        var column = await repository.GetByIdAsync(id);
        if (column is null) return false;

        await repository.DeleteAsync(column);
        await repository.SaveChangesAsync();

        return true;
    }
}
