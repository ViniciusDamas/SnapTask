namespace SnapTaskApi.Contracts.Requests.Columns;
public class CreateColumnRequest
{
    public Guid BoardId { get; set; }
    public string Name { get; set; } = string.Empty;
}