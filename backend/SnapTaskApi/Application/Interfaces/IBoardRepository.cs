namespace SnapTaskApi.Application.Interfaces;

using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Domain.Entities;

public interface IBoardRepository
{
    Task AddAsync(Board board, CancellationToken ct = default);
    Task<Board?> GetByIdWithDetailsAsync(Guid id, CancellationToken ct = default);
    Task<Board?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task<List<Board>> GetAllAsync(CancellationToken ct = default);
    Task<bool> ExistsAsync(Guid id, CancellationToken ct = default);
    Task DeleteAsync(Board board, CancellationToken ct = default);
    Task<int> SaveChangesAsync(CancellationToken ct = default);
}
