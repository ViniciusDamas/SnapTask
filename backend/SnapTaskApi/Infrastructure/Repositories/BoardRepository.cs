namespace SnapTaskApi.Infrastructure.Repositories;

using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Infrastructure.Persistence;

public sealed class BoardRepository : IBoardRepository
{
    private readonly AppDbContext context;

    public BoardRepository(AppDbContext context)
    {
        this.context = context;
    }

    public async Task AddAsync(Board board, CancellationToken ct = default)
    {
        await context.Boards.AddAsync(board, ct);
    }

    public async Task<Board?> GetByIdWithDetailsAsync(Guid id, CancellationToken ct = default)
    {
        return await context.Boards
            .Include(b => b.Columns)
                .ThenInclude(c => c.Cards)
            .FirstOrDefaultAsync(b => b.Id == id, ct);
    }

    public async Task<Board?> GetByIdAsync(Guid id, CancellationToken ct = default)
    {
        return await context.Boards.FirstOrDefaultAsync(b => b.Id == id, ct);
    }

    public async Task<List<Board>> GetAllAsync(CancellationToken ct = default)
    {
        return await context.Boards
            .AsNoTracking()
            .ToListAsync(ct);
    }

    public async Task<bool> ExistsAsync(Guid id, CancellationToken ct = default)
    {
        return await context.Boards.AnyAsync(b => b.Id == id, ct);
    }

    public Task DeleteAsync(Board board, CancellationToken ct = default)
    {
        context.Boards.Remove(board);
        return Task.CompletedTask;
    }

    public Task<int> SaveChangesAsync(CancellationToken ct = default)
    {
        return context.SaveChangesAsync(ct);
    }
}
