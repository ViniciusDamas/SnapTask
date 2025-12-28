using System.ComponentModel.DataAnnotations;

namespace SnapTaskApi.Contracts.Requests.Boards;

public sealed class UpdateBoardRequest
{
    [Required]
    public string Name { get; set; } = string.Empty;
}