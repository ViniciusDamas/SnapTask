namespace SnapTaskApi.Application.Abstractions.Repositories;

using SnapTaskApi.Application.UseCases.Boards.Results;
using SnapTaskApi.Domain.Entities;
public interface IBoardRepository
{
    Task AddAsync(Board board);
    Task<BoardDetailsResult?> GetByIdWithDetailsAsync(Guid id);
    Task<Board?> GetByIdAsync(Guid id);
    Task<List<BoardSummaryResult>> GetAllByUserIdAsync(Guid userId);
    Task DeleteAsync(Board board);
    Task<int> SaveChangesAsync();
}
