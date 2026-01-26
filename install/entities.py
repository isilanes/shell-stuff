from pathlib import Path

from pydantic import BaseModel

from operations import ok, hi, ko


class ConfigFile(BaseModel):
    reference: Path
    destination: Path

    def deploy(self) -> bool:
        """
        Deploy reference file into destination, if necessary and possible.

        Returns:
            bool: True if successful, False otherwise.
        """
        if self.destination.is_file():
            ok("File", hi(str(self.destination)), "already exists")
            return True

        if not self.reference.is_file():
            ko("Tried to install file", hi(str(self.reference)), "but it does not exist!")
            return False

        self.reference.copy(self.destination)
        ok("Installed file", hi(str(self.destination)), "successfully")

        return True
