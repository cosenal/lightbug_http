from lightbug_http.http import HTTPRequest, HTTPResponse, OK, NotFound
from lightbug_http.io.bytes import Bytes, bytes
from lightbug_http.strings import to_string
from lightbug_http.header import HeaderKey


trait HTTPService:
    fn func(self, req: HTTPRequest) raises -> HTTPResponse:
        ...


@value
struct Printer(HTTPService):
    fn func(self, req: HTTPRequest) raises -> HTTPResponse:
        var uri = req.uri
        print("Request URI: ", to_string(uri.request_uri))

        var header = req.headers
        print("Request protocol: ", req.protocol)
        print("Request method: ", req.method)
        print(
            "Request Content-Type: ", to_string(header[HeaderKey.CONTENT_TYPE])
        )

        var body = req.body_raw
        print("Request Body: ", to_string(body))

        return OK(body)


@value
struct Welcome(HTTPService):
    fn func(self, req: HTTPRequest) raises -> HTTPResponse:
        var uri = req.uri

        if uri.path == "/":
            var html: Bytes
            with open("static/lightbug_welcome.html", "r") as f:
                html = f.read_bytes()
            return OK(html, "text/html; charset=utf-8")

        if uri.path == "/logo.png":
            var image: Bytes
            with open("static/logo.png", "r") as f:
                image = f.read_bytes()
            return OK(image, "image/png")

        return NotFound(uri.path)


@value
struct ExampleRouter(HTTPService):
    fn func(self, req: HTTPRequest) raises -> HTTPResponse:
        var body = req.body_raw
        var uri = req.uri

        if uri.path == "/":
            print("I'm on the index path!")
        if uri.path == "/first":
            print("I'm on /first!")
        elif uri.path == "/second":
            print("I'm on /second!")
        elif uri.path == "/echo":
            print(to_string(body))

        return OK(body)


@value
struct TechEmpowerRouter(HTTPService):
    fn func(self, req: HTTPRequest) raises -> HTTPResponse:
        var uri = req.uri

        if uri.path == "/plaintext":
            return OK("Hello, World!", "text/plain")
        elif uri.path == "/json":
            return OK('{"message": "Hello, World!"}', "application/json")

        return OK("Hello world!")  # text/plain is the default
