namespace SnapTaskApi.Contracts.Requests.Columns;

public class MoveColumnRequest
{
    public int ToOrder { get; set; }
    public Guid BoardId { get; set; }
}
