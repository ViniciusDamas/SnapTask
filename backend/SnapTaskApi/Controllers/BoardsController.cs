using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Contracts.Requests.Boards;

namespace SnapTaskApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BoardsController : ControllerBase
{
    private readonly IBoardService service;

    public BoardsController(IBoardService service)
    {
        this.service = service;
    }

    [HttpPost]
    public async Task<IActionResult> CreateAsync([FromBody] CreateBoardRequest request)
    {
        var board = await service.CreateAsync(request.Name);

        return CreatedAtRoute("GetBoardById", new { id = board.Id }, board);
    }

    [HttpGet("{id:guid}", Name = "GetBoardById")]
    public async Task<IActionResult> GetByIdAsync([FromRoute] Guid id)
    {
        var board = await service.GetByIdAsync(id);
        if (board is null) return NotFound();

        return Ok(board);
    }

    [HttpGet]
    public async Task<IActionResult> GetAllAsync()
    {
        var boards = await service.GetAllAsync();
        return Ok(boards);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, [FromBody] UpdateBoardRequest request)
    {
        var updated = await service.UpdateNameAsync(id, request.Name);
        if (!updated) return NotFound();

        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id)
    {
        var deleted = await service.DeleteAsync(id);
        if (!deleted) return NotFound();

        return NoContent();
    }
}
