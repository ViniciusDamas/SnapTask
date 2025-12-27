using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Domain.Entities;

namespace SnapTaskApi.Application.Interfaces;

public interface IBoardService
{
    Task<Board> CreateAsync(string name, CancellationToken ct = default);
    Task<Board?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task<List<Board>> GetAllAsync(CancellationToken ct = default);
    Task<bool> UpdateNameAsync(Guid id, string name, CancellationToken ct = default);
    Task<bool> DeleteAsync(Guid id, CancellationToken ct = default);
}
