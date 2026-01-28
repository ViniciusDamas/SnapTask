namespace SnapTaskApi.Api.Controllers;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Api.Contracts.Requests.Columns;
using SnapTaskApi.Application.UseCases.Columns;

//[Authorize]
[ApiController]
[Route("api/[controller]")]
public class ColumnsController : ControllerBase
{
    private readonly MoveColumn move;
    private readonly UpdateColumn update;
    private readonly CreateColumn create;
    private readonly DeleteColumn delete;
    private readonly GetColumnById getById;

    public ColumnsController(CreateColumn create, GetColumnById getById, UpdateColumn update, MoveColumn move, DeleteColumn delete)
    {
        this.move = move;
        this.create = create;
        this.update = update;
        this.delete = delete;
        this.getById = getById;
    }

    [HttpPost]
    public async Task<IActionResult> AddAsync([FromBody] CreateColumnRequest request)
    { 
        var column = await create.AddAsync(request.BoardId, request.Name);

        return Created(string.Empty, column);
    }

    [HttpGet("{id:guid}", Name = "GetByColumnId")]
    public async Task<IActionResult> GetByIdAsync([FromRoute] Guid id)
    {
        var column = await getById.GetByIdWithDetailsAsync(id);
        if (column is null) return NotFound();

        return Ok(column);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, [FromBody] UpdateColumnRequest request)
    {
        var updated = await update.UpdateAsync(id, request.Name);
        if (!updated) return NotFound();

        return NoContent();
    }

    //[HttpPut("{id:guid}/move")]
    //public async Task<IActionResult> MoveAsync(Guid id, [FromBody] MoveColumnRequest request)
    //{
    //    var moved = await move.MoveAsync(id, request.BoardId, request.ToOrder);
    //    if (!moved) return BadRequest();

    //    return NoContent();
    //}

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id) { 
    
        var deleted = await delete.DeleteAsync(id);
        if (!deleted) return BadRequest();

        return NoContent();
    }
}