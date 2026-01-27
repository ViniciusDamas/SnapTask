namespace SnapTaskApi.Api.Controllers;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using SnapTaskApi.Api.Contracts.Requests.Boards;
using SnapTaskApi.Application.Abstractions.CurrentUser;
using SnapTaskApi.Application.UseCases.Boards;
using SnapTaskApi.Infrastructure.Identity;
using SnapTaskApi.Infrastructure.Security;
using SnapTaskApi.WebApi.Security;

//[Authorize]
[ApiController]
[Route("api/[controller]")]
public class BoardsController : ControllerBase
{
    private readonly UserManager<ApplicationUser> users;
    private readonly JwtTokenService jwt;

    private readonly CreateBoard create;
    private readonly GetBoardById getById;
    private readonly GetAllBoards getAll;
    private readonly UpdateBoard update;
    private readonly DeleteBoard delete;

    public BoardsController(
        UserManager<ApplicationUser> users, 
        JwtTokenService jwt, 
        CreateBoard create, 
        GetBoardById getById, 
        GetAllBoards getAll, 
        UpdateBoard update, 
        DeleteBoard delete)
    {
        this.users = users;
        this.jwt = jwt;
        this.create = create;
        this.getById = getById;
        this.getAll = getAll;
        this.update = update;
        this.delete = delete;
    }

    [HttpPost]
    public async Task<IActionResult> CreateAsync([FromBody] CreateBoardRequest request)
    {
        var userId = User.GetRequiredUserId();

        var board = await create.CreateAsync(request.Name, userId);

        return CreatedAtRoute("GetBoardById", new { id = board.Id }, board);
    }

    [HttpGet("{id:guid}", Name = "GetBoardById")]
    public async Task<IActionResult> GetByIdAsync([FromRoute] Guid id)
    {
        var board = await getById.GetByIdWithDetailsAsync(id);
        if (board is null) return NotFound();

        return Ok(board);
    }

    [Authorize]
    [HttpGet]
    public async Task<IActionResult> GetAllAsync([FromServices] ICurrentUser currentUser)
    {
        var boards = await getAll.GetAllAsync(currentUser.UserId);
        return Ok(boards);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, [FromBody] UpdateBoardRequest request)
    {
        var updated = await update.UpdateNameAsync(id, request.Name);
        if (!updated) return NotFound();

        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id)
    {
        var deleted = await delete.DeleteAsync(id);
        if (!deleted) return NotFound();

        return NoContent();
    }
}
