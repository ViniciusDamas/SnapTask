namespace SnapTaskApi.Application.UseCases.Boards;

using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Boards.Results;

public class GetBoardById
{
    private readonly IBoardRepository repository;

    public GetBoardById(IBoardRepository repository) => this.repository = repository;

    public Task<BoardDetailsResult?> GetByIdWithDetailsAsync(Guid id)
       => repository.GetByIdWithDetailsAsync(id);
}
