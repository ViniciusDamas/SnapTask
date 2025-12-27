using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Contracts.Requests.Boards;

namespace SnapTaskApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BoardsController : ControllerBase
{
    private readonly IBoardService _service;

    public BoardsController(IBoardService service)
    {
        _service = service;
    }

    [HttpPost]
    public async Task<IActionResult> CreateAsync([FromBody] CreateBoardRequest request, CancellationToken ct)
    {
        if (request is null || string.IsNullOrWhiteSpace(request.Name))
            return BadRequest("Board name is required.");

        var board = await _service.CreateAsync(request.Name, ct);

        return CreatedAtRoute("GetBoardById", new { id = board.Id }, board);
    }

    [HttpGet("{id:guid}", Name = "GetBoardById")]
    public async Task<IActionResult> GetByIdAsync([FromRoute] Guid id, CancellationToken ct)
    {
        var board = await _service.GetByIdAsync(id, ct);
        if (board is null) return NotFound();

        return Ok(board);
    }

    [HttpGet]
    public async Task<IActionResult> GetAllAsync(CancellationToken ct)
    {
        var boards = await _service.GetAllAsync(ct);
        return Ok(boards);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, [FromBody] UpdateBoardRequest request, CancellationToken ct)
    {
        if (request is null || string.IsNullOrWhiteSpace(request.Name))
            return BadRequest("Board name is required.");

        var updated = await _service.UpdateNameAsync(id, request.Name, ct);
        if (!updated) return NotFound();

        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id, CancellationToken ct)
    {
        var deleted = await _service.DeleteAsync(id, ct);
        if (!deleted) return NotFound();

        return NoContent();
    }
}
