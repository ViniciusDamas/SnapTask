namespace SnapTaskApi.Application.UseCases.Boards;

using SnapTaskApi.Domain.Entities;
using SnapTaskApi.Application.Abstractions.Repositories;

public class GetBoardById
{
    private readonly IBoardRepository repository;

    public GetBoardById(IBoardRepository repository) => this.repository = repository;

    public Task<Board?> GetByIdAsync(Guid id)
       => repository.GetByIdWithDetailsAsync(id);
}
