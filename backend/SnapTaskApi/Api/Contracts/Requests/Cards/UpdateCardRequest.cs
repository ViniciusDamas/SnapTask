using System.ComponentModel.DataAnnotations;

namespace SnapTaskApi.Api.Contracts.Requests.Cards;

public sealed class UpdateCardRequest
{
    [Required]
    public string Title { get; set; } = string.Empty;
    public string Description {get; set;} = string.Empty;
}
