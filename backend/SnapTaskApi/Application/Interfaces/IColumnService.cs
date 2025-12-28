using SnapTaskApi.Domain.Entities;

namespace SnapTaskApi.Application.Interfaces;
public interface IColumnService
{
    Task<Column> AddAsync(Guid boardId, string name);
    Task<Column?> GetByIdAsync(Guid id);
    Task<bool> UpdateAsync(Guid id, string name);
    Task<bool> MoveAsync(Guid columnId, Guid boardId, int toOrder);
    Task<bool> DeleteAsync(Guid id);
}