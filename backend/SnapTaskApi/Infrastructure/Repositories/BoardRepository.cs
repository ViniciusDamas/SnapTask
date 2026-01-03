namespace SnapTaskApi.Infrastructure.Repositories;

using SnapTaskApi.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Infrastructure.Persistence;
using SnapTaskApi.Application.Abstractions.Repositories;

public sealed class BoardRepository : IBoardRepository
{
    private readonly AppDbContext context;

    public BoardRepository(AppDbContext context) => this.context = context;

    public async Task AddAsync(Board board) => await context.AddAsync(board);

    public async Task<Board?> GetByIdWithDetailsAsync(Guid id)
    {
        return await context.Boards
            .Include(b => b.Columns)
                .ThenInclude(c => c.Cards)
            .FirstOrDefaultAsync(b => b.Id == id);
    }

    public async Task<Board?> GetByIdAsync(Guid id)
    {
        return await context.Boards.FirstOrDefaultAsync(b => b.Id == id);
    }

    public async Task<List<Board>> GetAllAsync()
    {
        return await context.Boards
            .AsNoTracking()
            .ToListAsync();
    }

    public Task DeleteAsync(Board board)
    {
        context.Boards.Remove(board);
        return Task.CompletedTask;
    }

    public Task<int> SaveChangesAsync()
    {
        return context.SaveChangesAsync();
    }
}
