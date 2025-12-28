using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Domain.Entities;

namespace SnapTaskApi.Application.Services;

public sealed class BoardService : IBoardService
{
    private readonly IBoardRepository repository;

    public BoardService(IBoardRepository repository) => this.repository = repository;
    
    public async Task<Board> CreateAsync(string name)
    {
        var board = new Board
        {
            Id = Guid.NewGuid(),
            Name = name.Trim()
        };

        await repository.AddAsync(board);
        await repository.SaveChangesAsync();

        return board;
    }

    public Task<Board?> GetByIdAsync(Guid id)
        => repository.GetByIdWithDetailsAsync(id);

    public Task<List<Board>> GetAllAsync()
        => repository.GetAllAsync();

    public async Task<bool> UpdateNameAsync(Guid id, string name)
    {
        var board = await repository.GetByIdAsync(id);
        if (board is null) return false;

        board.Name = name.Trim();
        await repository.SaveChangesAsync();

        return true;
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var board = await repository.GetByIdAsync(id);
        if (board is null) return false;

        await repository.DeleteAsync(board);
        await repository.SaveChangesAsync();

        return true;
    }
}
