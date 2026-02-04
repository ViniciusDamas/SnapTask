namespace SnapTaskApi.Api.Controllers;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Api.Contracts.Requests.Cards;
using SnapTaskApi.Application.UseCases.Cards;
using SnapTaskApi.Domain.Entities.Cards;
using SnapTaskApi.WebApi.Contracts.Requests.Cards;

//[Authorize]
[ApiController]
[Route("api/[controller]")]
public class CardsController : ControllerBase
{
    private readonly CreateCard create;
    private readonly GetCardById getById;
    private readonly UpdateCard update;
    private readonly UpdateCardStatus updateStatus;
    private readonly DeleteCard delete;

    public CardsController(CreateCard create, GetCardById getById, UpdateCard update, UpdateCardStatus updateStatus, DeleteCard delete)
    {
        this.create = create;
        this.getById = getById;
        this.update = update;
        this.updateStatus = updateStatus;
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

    [HttpPatch("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, [FromBody] UpdateCardRequest request)
    {
        var updated = await update.UpdateCardAsync(id, request.Title, request.Description);
        if(!updated) return NotFound();

        return NoContent();
    }

    [HttpPatch("{id}/status")]
    public async Task<IActionResult> UpdateStatus(Guid id, [FromBody] UpdateCardStatusRequest req)
    {
        var ok = await updateStatus.UpdateStatusAsync(id, req.Status);
        return ok ? NoContent() : NotFound();
    }



    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id)
    {
        var deleted = await delete.DeleteCardAsync(id);
        if (!deleted) return NotFound();

        return NoContent();
    }

}
