namespace SnapTaskApi.Infrastructure.Repositories;

using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Boards.Results;
using SnapTaskApi.Application.UseCases.Cards.Results;
using SnapTaskApi.Application.UseCases.Columns.Results;
using SnapTaskApi.Domain.Entities.Boards;
using SnapTaskApi.Infrastructure.Persistence;

public sealed class BoardRepository : IBoardRepository
{
    private readonly AppDbContext context;

    public BoardRepository(AppDbContext context) => this.context = context;

    public async Task AddAsync(Board board) => await context.AddAsync(board);

    public async Task<BoardDetailsResult?> GetByIdWithDetailsAsync(Guid id)
    {
        return await context.Boards
            .AsNoTracking()
            .Where(b => b.Id == id)
            .Select(b => new BoardDetailsResult(
                b.Id,
                b.Name,
                b.CreatedAt,
                b.Columns
                    .OrderBy(c => c.Order)
                    .Select(c => new ColumnDetailsResult(
                        c.Id,
                        c.Name,
                        c.Order,
                        c.Cards
                            .OrderBy(x => x.Order)
                            .Select(x => new CardSummaryResult(
                                x.Id,
                                x.Title,
                                x.Description,
                                x.Order,
                                x.ColumnId,
                                x.Status
                            ))
                            .ToList()
                    ))
                    .ToList()
            ))
            .FirstOrDefaultAsync();
    }

    public async Task<Board?> GetByIdAsync(Guid id)
    {
        return await context.Boards.FirstOrDefaultAsync(b => b.Id == id);
    }

    public async Task<List<BoardSummaryResult>> GetAllByUserIdAsync(Guid userId)
    {
        return await context.Boards
            .AsNoTracking()
            .Where(b => b.OwnerUserId == userId)          
            .OrderByDescending(b => b.CreatedAt)         
            .Select(b => new BoardSummaryResult(          
                b.Id,
                b.Name,
                b.CreatedAt,
                b.OwnerUserId
            ))
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
