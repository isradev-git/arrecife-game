"""Sirve una exportación Web local sin reutilizar archivos antiguos del navegador."""

import sys
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


class NoCacheHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8767
    directory = Path(__file__).resolve().parents[1] / "game/build/web"
    assert (directory / "index.html").is_file(), "Exporta el juego Web antes de iniciar el servidor."
    ThreadingHTTPServer(("127.0.0.1", port), partial(NoCacheHandler, directory=str(directory))).serve_forever()
