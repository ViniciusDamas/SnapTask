namespace SnapTaskApi.Application.UseCases.Boards;

using SnapTaskApi.Application.Abstractions.Repositories;
using SnapTaskApi.Application.UseCases.Boards.Results;

public class GetAllBoards
{
    private readonly IBoardRepository repository;

    public GetAllBoards(IBoardRepository repository) => this.repository = repository;
    public Task<List<BoardSummaryResult>> GetAllAsync()
        => repository.GetAllAsync();
}
