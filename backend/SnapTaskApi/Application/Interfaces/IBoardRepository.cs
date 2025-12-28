namespace SnapTaskApi.Application.Interfaces;

using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Domain.Entities;

public interface IBoardRepository
{
    Task AddAsync(Board board);
    Task<Board?> GetByIdWithDetailsAsync(Guid id);
    Task<Board?> GetByIdAsync(Guid id);
    Task<List<Board>> GetAllAsync();
    Task<bool> ExistsAsync(Guid id);
    Task DeleteAsync(Board board);
    Task<int> SaveChangesAsync();
}
