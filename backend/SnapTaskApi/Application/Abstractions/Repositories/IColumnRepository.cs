namespace SnapTaskApi.Application.Abstractions.Repositories;

using SnapTaskApi.Domain.Entities;
public interface IColumnRepository
{
    Task AddAsync(Column column);
    Task<int> GetLastOrderAsync(Guid boardId);
    Task<int> SaveChangesAsync();
    Task<Column?> GetByIdWithDetailsAsync(Guid id);
    Task<Column?> GetByIdAsync(Guid id);
    Task DeleteAsync(Column column);
}