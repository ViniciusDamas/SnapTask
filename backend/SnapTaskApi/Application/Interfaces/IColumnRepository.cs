using SnapTaskApi.Domain.Entities;

namespace SnapTaskApi.Application.Interfaces;

public interface IColumnRepository
{
    Task AddAsync(Column column);
    Task<int> SaveChangesAsync();
    Task<Column?> GetByIdWithDetailsAsync(Guid id);
    Task<Column?> GetByIdAsync(Guid id);
    Task DeleteAsync(Column column);
}