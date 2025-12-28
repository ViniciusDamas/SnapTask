using System.ComponentModel.DataAnnotations;

namespace SnapTaskApi.Contracts.Requests.Columns;
public class CreateColumnRequest
{
    [Required]
    public Guid BoardId { get; set; }

    [Required]
    public string Name { get; set; } = string.Empty;
}