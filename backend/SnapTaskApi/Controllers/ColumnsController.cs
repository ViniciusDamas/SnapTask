using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Contracts.Requests.Columns;

namespace SnapTaskApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ColumnsController : ControllerBase
{
    private readonly IColumnService service;
    
    public ColumnsController(IColumnService service)
    {
        this.service = service;
    }

    [HttpPost]
    public async Task<IActionResult> AddAsync([FromBody] CreateColumnRequest request)
    { 
        var column = await service.AddAsync(request.BoardId, request.Name);

        return CreatedAtRoute("GetByColumnId", new { id = column.Id, column });     
    }

    [HttpGet("{id:guid}", Name = "GetByColumnId")]
    public async Task<IActionResult> GetByIdAsync([FromRoute] Guid id)
    {
        var column = await service.GetByIdAsync(id);
        if (column is null) return NotFound();

        return Ok(column);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, [FromBody] UpdateColumnRequest request)
    {
        var updated = await service.UpdateAsync(id, request.Name);
        if (!updated) return NotFound();

        return NoContent();
    }

    [HttpPut("{id:guid}/move")]
    public async Task<IActionResult> MoveAsync(Guid id, [FromBody] MoveColumnRequest request)
    {
        var moved = await service.MoveAsync(id, request.BoardId, request.ToOrder);
        if (!moved) return BadRequest();

        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id) { 
    
        var deleted = await service.DeleteAsync(id);
        if (!deleted) return BadRequest();

        return NoContent();
    }
}