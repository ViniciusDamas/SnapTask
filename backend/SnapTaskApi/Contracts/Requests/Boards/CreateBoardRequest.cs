using System.ComponentModel.DataAnnotations;

namespace SnapTaskApi.Contracts.Requests.Boards;

public sealed class CreateBoardRequest
{
    [Required]
    public string Name { get; set; } = string.Empty;
}