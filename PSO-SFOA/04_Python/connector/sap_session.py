"""
python/connector/sap_session.py

Production skeleton for SAP2000 v24 session management.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import logging
from typing import Any

import comtypes.client

logger = logging.getLogger(__name__)


class SapConnectionError(RuntimeError):
    """Raised when SAP2000 connection fails."""


@dataclass(slots=True)
class SapConfig:
    app_path: Path
    model_path: Path
    attach_to_running: bool = True
    visible: bool = True


class SapSession:
    """Manage a SAP2000 COM session."""

    def __init__(self, config: SapConfig) -> None:
        self.config = config
        self.sap_object: Any | None = None
        self.sap_model: Any | None = None
        self.connected = False

    def __enter__(self) -> "SapSession":
        self.connect()
        self.open_model()
        return self

    def __exit__(self, exc_type, exc, tb) -> None:
        self.close()

    def connect(self) -> None:
        if self.connected:
            return

        helper = comtypes.client.CreateObject("SAP2000v1.Helper")
        helper = helper.QueryInterface(comtypes.gen.SAP2000v1.cHelper)

        if self.config.attach_to_running:
            try:
                self.sap_object = helper.GetObject("CSI.SAP2000.API.SapObject")
            except Exception:
                self.sap_object = helper.CreateObject(str(self.config.app_path))
                self._check(self.sap_object.ApplicationStart(), "ApplicationStart")
        else:
            self.sap_object = helper.CreateObject(str(self.config.app_path))
            self._check(self.sap_object.ApplicationStart(), "ApplicationStart")

        self.sap_model = self.sap_object.SapModel
        self.connected = True
        logger.info("Connected to SAP2000.")

    def open_model(self) -> None:
        self._require_connection()
        self._check(
            self.sap_model.File.OpenFile(str(self.config.model_path)),
            "OpenFile",
        )

    def get_model(self):
        self._require_connection()
        return self.sap_model

    def close(self, save: bool = False) -> None:
        if self.sap_object is not None:
            try:
                self.sap_object.ApplicationExit(save)
            finally:
                self.sap_object = None
                self.sap_model = None
                self.connected = False

    def _require_connection(self) -> None:
        if not self.connected:
            raise SapConnectionError("SAP2000 is not connected.")

    @staticmethod
    def _check(ret: int, action: str) -> None:
        if ret != 0:
            raise SapConnectionError(f"{action} failed. Return code={ret}")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    cfg = SapConfig(
        app_path=Path(r"C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe"),
        model_path=Path(r"D:\Project\MasterModel.sdb"),
    )

    with SapSession(cfg) as session:
        print("Connected:", session.connected)
        print(session.get_model())
