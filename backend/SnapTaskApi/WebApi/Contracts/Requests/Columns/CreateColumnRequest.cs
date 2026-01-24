namespace SnapTaskApi.Api.Contracts.Requests.Columns;

using System.ComponentModel.DataAnnotations;
public class CreateColumnRequest
{
    [Required]
    public Guid BoardId { get; set; }

    [Required]
    public string Name { get; set; } = string.Empty;
}