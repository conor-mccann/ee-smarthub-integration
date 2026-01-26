""" Data models for the EE Smart Hub integration. """
from __future__ import annotations

from dataclasses import dataclass, field
import uuid


@dataclass
class SmartHubConfig:
    """Configuration for connecting to the Smart Hub."""

    host: str
    password: str
    serial_number: str | None = None
    client_id: str = field(default_factory=lambda: f"ha-{uuid.uuid4().hex[:12]}")


@dataclass
class ConnectedDevice:
    """Represents a device connected to the Smart Hub."""
    
    mac_address: str
    ip_address: str
    hostname: str
    user_friendly_name: str
    interface_type: str
    active: bool = False
    frequency_band: str | None = None
    bytes_sent: int = 0
    bytes_received: int = 0

    @property
    def name(self) -> str:
        """Return the best available name for the device."""
        return self.user_friendly_name or self.hostname or self.mac_address
