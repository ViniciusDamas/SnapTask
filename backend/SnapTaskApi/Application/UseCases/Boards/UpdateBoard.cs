namespace SnapTaskApi.Application.UseCases.Boards;

using SnapTaskApi.Application.Abstractions.Repositories;

public class UpdateBoard
{
    private readonly IBoardRepository repository;

    public UpdateBoard(IBoardRepository repository) => this.repository = repository;


    public async Task<bool> UpdateNameAsync(Guid id, string name)
    {
        var board = await repository.GetByIdAsync(id);
        if (board is null) return false;

        board.Name = name.Trim();
        await repository.SaveChangesAsync();

        return true;
    }
}
