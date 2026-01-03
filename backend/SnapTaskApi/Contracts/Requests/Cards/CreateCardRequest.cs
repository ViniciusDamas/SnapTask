namespace SnapTaskApi.Contracts.Requests.Cards;

using System.ComponentModel.DataAnnotations;
public class CreateCardRequest
{
    [Required]
    public string Title { get; set; } = string.Empty;

    public string? Description { get; set; }

    [Required]
    public Guid ColumnId { get; set; }
}
