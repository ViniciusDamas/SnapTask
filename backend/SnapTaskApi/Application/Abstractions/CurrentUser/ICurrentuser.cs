namespace SnapTaskApi.Application.Abstractions.CurrentUser;
public interface ICurrentUser
{
    Guid UserId { get; }
    bool IsAuthenticated { get; }
}
