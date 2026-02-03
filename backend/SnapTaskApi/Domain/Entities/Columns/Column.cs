using SnapTaskApi.Domain.Entities.Boards;
using SnapTaskApi.Domain.Entities.Cards;
using System.Text.Json.Serialization;

namespace SnapTaskApi.Domain.Entities.Columns;

public class Column {

    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int Order { get; set; }

    public List<Card> Cards { get; set; } = new();
    public Guid BoardId { get; set; }

    [JsonIgnore]
    public Board Board { get; set; } = null!;
}