namespace SnapTaskApi.Application.UseCases.Boards;

using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Boards.Results;

public class CreateBoard
{
    private readonly IBoardRepository repository;

    public CreateBoard(IBoardRepository repository) => this.repository = repository;

    public async Task<BoardSummaryResult> CreateAsync(string name, Guid userId)
    {
        var board = new Board(name, userId);

        await repository.AddAsync(board);
        await repository.SaveChangesAsync();

        return new BoardSummaryResult(board.Id, board.Name, board.CreatedAt, userId);
    }
}
