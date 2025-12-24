namespace SnapTaskApi.Domain.Entities;

public class Board
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;

    public List<Column> Columns { get; set; } = new();
}