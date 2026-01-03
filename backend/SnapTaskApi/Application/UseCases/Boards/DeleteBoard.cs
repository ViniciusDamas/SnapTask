namespace SnapTaskApi.Application.UseCases.Boards;

using SnapTaskApi.Application.Abstractions.Repositories;
public class DeleteBoard
{
    private readonly IBoardRepository repository;

    public DeleteBoard(IBoardRepository repository) => this.repository = repository;
    public async Task<bool> DeleteAsync(Guid id)
    {
        var board = await repository.GetByIdAsync(id);
        if (board is null) return false;

        await repository.DeleteAsync(board);
        await repository.SaveChangesAsync();

        return true;
    }
}
