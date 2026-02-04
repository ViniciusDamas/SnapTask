using SnapTaskApi.Domain.Entities.Columns;
using System.Text.Json.Serialization;

namespace SnapTaskApi.Domain.Entities.Cards;

public class Card
{
    public Guid Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int Order {  get; set; }
    public CardStatus Status { get; private set; } = CardStatus.Open;
    public Guid ColumnId { get; set; }

    [JsonIgnore]
    public Column Column { get; set; } = null!;

    public void SetStatus(CardStatus status)
    {
        if (Status == status) return;
        Status = status;
    }
}