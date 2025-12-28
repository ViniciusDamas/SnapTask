using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Application.Interfaces;
using SnapTaskApi.Application.Validators.Column;
using SnapTaskApi.Contracts.Requests.Columns;
using System.ComponentModel.DataAnnotations;

namespace SnapTaskApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ColumnsController : ControllerBase
{
    private readonly IColumnService service;
    private readonly ColumnValidator validator;

    public ColumnsController(IColumnService service, ColumnValidator validator)
    {
        this.service = service;
        this.validator = validator;
    }

    [HttpPost]
    public async Task<IActionResult> AddAsync([FromBody] CreateColumnRequest request)
    {
        try
        {
            validator.Validate(request);
            var column = await service.AddAsync(request.BoardId, request.Name);

            return CreatedAtRoute(
                "GetByColumnId",
                new
                {
                    id = column.Id,
                    column
                });
        } catch (ValidationException ex)
        {
            return BadRequest(ex.Message);
        }
        
    }

    [HttpGet("{id:guid}", Name = "GetByColumnId")]
    public async Task<IActionResult> GetByIdAsync([FromRoute] Guid id)
    {
        var column = await service.GetByColumnId(id);
        if (column is null) return NotFound();
        return Ok(column);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, [FromBody] UpdateColumnRequest request)
    {
        try
        {
            validator.Validate(id, request);

            var updated = await service.UpdateAsync(id, request.Name);
            if (!updated) return NotFound();

            return NoContent();

        } catch (ValidationException ex)
        {
            return BadRequest(ex.Message);
        }  
    }

    [HttpPut("{id:guid}/move")]
    public async Task<IActionResult> MoveAsync(Guid id, [FromBody] MoveColumnRequest request)
    {
        var moved = await service.MoveAsync(id, request.BoardId, request.ToOrder);
        if (!moved) return BadRequest();

        return NoContent();
    }
}