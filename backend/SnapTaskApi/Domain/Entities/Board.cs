namespace SnapTaskApi.Domain.Entities;

public class Board
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public Guid OwnerUserId { get; private set; }
    public List<Column> Columns { get; set; } = new();
    private Board() { }

    public Board(string name, Guid ownerUserId)
    {
        Id = Guid.NewGuid();
        Name = name;
        CreatedAt = DateTime.UtcNow;
        OwnerUserId = ownerUserId;
    }
}