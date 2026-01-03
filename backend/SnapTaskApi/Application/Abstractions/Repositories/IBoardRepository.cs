namespace SnapTaskApi.Application.Abstractions.Repositories;

using SnapTaskApi.Domain.Entities;
public interface IBoardRepository
{
    Task AddAsync(Board board);
    Task<Board?> GetByIdWithDetailsAsync(Guid id);
    Task<Board?> GetByIdAsync(Guid id);
    Task<List<Board>> GetAllAsync();
    Task DeleteAsync(Board board);
    Task<int> SaveChangesAsync();
}
