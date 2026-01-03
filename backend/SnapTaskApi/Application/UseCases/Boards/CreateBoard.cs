namespace SnapTaskApi.Application.UseCases.Boards;

using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Application.Abstractions.Repositories;

public class CreateBoard
{
    private readonly IBoardRepository repository;

    public CreateBoard(IBoardRepository repository) => this.repository = repository;

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
}
