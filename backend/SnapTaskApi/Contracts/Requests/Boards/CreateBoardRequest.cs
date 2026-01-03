namespace SnapTaskApi.Contracts.Requests.Boards;

using System.ComponentModel.DataAnnotations;
public sealed class CreateBoardRequest
{
    [Required]
    public string Name { get; set; } = string.Empty;
}