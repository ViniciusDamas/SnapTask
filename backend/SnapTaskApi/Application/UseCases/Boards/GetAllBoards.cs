namespace SnapTaskApi.Application.UseCases.Boards;

using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Application.Abstractions.Repositories;

public class GetAllBoards
{
    private readonly IBoardRepository repository;

    public GetAllBoards(IBoardRepository repository) => this.repository = repository;
    public Task<List<Board>> GetAllAsync()
        => repository.GetAllAsync();
}
