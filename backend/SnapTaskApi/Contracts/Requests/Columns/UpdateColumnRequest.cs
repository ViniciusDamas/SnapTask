using System.ComponentModel.DataAnnotations;

namespace SnapTaskApi.Contracts.Requests.Columns;

public class UpdateColumnRequest
{
    [Required]
    public string Name { get; set; } = string.Empty;
}
