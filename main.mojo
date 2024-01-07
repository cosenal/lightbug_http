from lightbug_http.io.bytes import Bytes
from lightbug_http.python.server import PythonServer
from lightbug_http.service import Printer

# from lightbug_http.sys.server import SysServer


fn main() raises:
    var server = PythonServer()
    let handler = Printer()
    server.listen_and_serve("0.0.0.0:8080", handler)
