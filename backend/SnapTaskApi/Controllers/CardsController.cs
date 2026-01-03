namespace SnapTaskApi.Controllers;

using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Contracts.Requests.Cards;
using SnapTaskApi.Application.UseCases.Cards;

[ApiController]
[Route("api/[controller]")]
public class CardsController : ControllerBase
{
    private readonly CreateCard create;

    public CardsController(CreateCard create) => this.create = create;

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateCardRequest request)
    {
        var card = await create.AddCardAsync(request);
        return CreatedAtRoute("GetByCardId", new { id = card.Id, card });
    }

}
