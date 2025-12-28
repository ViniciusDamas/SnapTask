using SnapTaskApi.Domain.Entities;

namespace SnapTaskApi.Application.Interfaces;

public interface IColumnRepository
{
    Task AddAsync(Column column);
    Task<int> SaveChangesAsync(Column colum);
}