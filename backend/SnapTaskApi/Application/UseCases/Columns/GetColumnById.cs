namespace SnapTaskApi.Application.UseCases.Columns;

using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Application.Abstractions.Repositories;

public class GetColumnById
{
    private readonly IColumnRepository repository;

    public GetColumnById(IColumnRepository repository) => this.repository = repository;
    public Task<Column?> GetByIdAsync(Guid id) => repository.GetByIdWithDetailsAsync(id);
}
