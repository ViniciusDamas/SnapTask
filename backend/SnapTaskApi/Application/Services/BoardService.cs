using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Infrastructure.Persistence;

namespace SnapTaskApi.Application.Services;

public sealed class BoardService : IBoardService
{
    private readonly IBoardRepository repository;

    public BoardService(IBoardRepository repository)
    {
        this.repository = repository;
    }

    public async Task<Board> CreateAsync(string name, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(name))
            throw new ArgumentException("Board name is required.", nameof(name));

        var board = new Board
        {
            Id = Guid.NewGuid(),
            Name = name.Trim()
        };

        await repository.AddAsync(board, ct);
        await repository.SaveChangesAsync(ct);

        return board;
    }

    public Task<Board?> GetByIdAsync(Guid id, CancellationToken ct = default)
        => repository.GetByIdWithDetailsAsync(id, ct);

    public Task<List<Board>> GetAllAsync(CancellationToken ct = default)
        => repository.GetAllAsync(ct);

    public async Task<bool> UpdateNameAsync(Guid id, string name, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(name))
            throw new ArgumentException("Board name is required.", nameof(name));

        var board = await repository.GetByIdAsync(id, ct);
        if (board is null) return false;

        board.Name = name.Trim();
        await repository.SaveChangesAsync(ct);

        return true;
    }

    public async Task<bool> DeleteAsync(Guid id, CancellationToken ct = default)
    {
        var board = await repository.GetByIdAsync(id, ct);
        if (board is null) return false;

        await repository.DeleteAsync(board, ct);
        await repository.SaveChangesAsync(ct);

        return true;
    }
}
