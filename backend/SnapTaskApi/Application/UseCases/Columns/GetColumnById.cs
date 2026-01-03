namespace SnapTaskApi.Application.UseCases.Columns;

using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Columns.Results;

public class GetColumnById
{
    private readonly IColumnRepository repository;

    public GetColumnById(IColumnRepository repository) => this.repository = repository;
    public Task<ColumnDetailsResult?> GetByIdWithDetailsAsync(Guid id) => repository.GetByIdWithDetailsAsync(id);
}
