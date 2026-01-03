namespace SnapTaskApi.Api.Controllers;

using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Api.Contracts.Requests.Cards;
using SnapTaskApi.Application.UseCases.Cards;
using SnapTaskApi.Domain.Entities;

[ApiController]
[Route("api/[controller]")]
public class CardsController : ControllerBase
{
    private readonly CreateCard create;
    private readonly GetCardById getById;
    private readonly UpdateCard update;
    private readonly DeleteCard delete;

    public CardsController(CreateCard create, GetCardById getById, UpdateCard update, DeleteCard delete)
    {
        this.create = create;
        this.getById = getById;
        this.update = update;
        this.delete = delete;
    }

    [HttpPost]
    public async Task<IActionResult> CreateAsync([FromBody] CreateCardRequest request)
    {
        var card = await create.AddCardAsync(request);
        return CreatedAtRoute("GetByCardId", new { id = card.Id }, card );
    }

    [HttpGet("{id:guid}", Name = "GetByCardId")]
    public async Task<IActionResult> GetByIdAsync([FromRoute] Guid id)
    {
        var card = await getById.GetByCardIdAsync(id);
        if (card is null) return NotFound();

        return Ok(card);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, [FromBody] UpdateCardRequest request)
    {
        var updated = await update.UpdateCardAsync(id, request.Title, request.Description);
        if(!updated) return NotFound();

        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id)
    {
        var deleted = await delete.DeleteCardAsync(id);
        if (!deleted) return NotFound();

        return NoContent();
    }

}
