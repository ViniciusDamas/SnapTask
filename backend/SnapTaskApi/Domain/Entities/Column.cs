namespace SnapTaskApi.Domain.Entities;

public class Column {

    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int Order { get; set; }

    public List<Card> Cards { get; set; } = new();
    public Guid BoardId { get; set; }
    public Board Board { get; set; } = null!;
}