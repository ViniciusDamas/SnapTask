using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Domain.Entities;

namespace SnapTaskApi.Application.Interfaces;

public interface IBoardService
{
    Task<Board> CreateAsync(string name);
    Task<Board?> GetByIdAsync(Guid id);
    Task<List<Board>> GetAllAsync();
    Task<bool> UpdateNameAsync(Guid id, string name);
    Task<bool> DeleteAsync(Guid id);
}
