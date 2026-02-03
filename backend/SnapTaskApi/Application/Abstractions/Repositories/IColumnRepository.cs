namespace SnapTaskApi.Application.Abstractions.Repositories;

using SnapTaskApi.Application.UseCases.Columns.Results;
using SnapTaskApi.Domain.Entities.Columns;

public interface IColumnRepository
{
    Task AddAsync(Column column);
    Task<int> GetLastOrderAsync(Guid boardId);
    Task<int> SaveChangesAsync();
    Task<ColumnDetailsResult?> GetByIdWithDetailsAsync(Guid id);
    Task<Column?> GetByIdAsync(Guid id);
    Task DeleteAsync(Column column);
}