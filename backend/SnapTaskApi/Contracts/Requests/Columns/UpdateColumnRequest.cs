namespace SnapTaskApi.Contracts.Requests.Columns;

using System.ComponentModel.DataAnnotations;
public class UpdateColumnRequest
{
    [Required]
    public string Name { get; set; } = string.Empty;
}
