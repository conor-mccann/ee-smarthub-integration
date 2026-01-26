class SmartHubError(Exception):
    """Base exception for Smart Hub errors."""

class SmartHubAuthError(SmartHubError):
    """Exception for authentication errors."""

class SmartHubConnectionError(SmartHubError):
    """Exception for connection errors."""