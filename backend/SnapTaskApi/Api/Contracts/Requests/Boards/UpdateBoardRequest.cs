namespace SnapTaskApi.Api.Contracts.Requests.Boards;

using System.ComponentModel.DataAnnotations;
public sealed class UpdateBoardRequest
{
    [Required]
    public string Name { get; set; } = string.Empty;
}