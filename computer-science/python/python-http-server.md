# 使用Python标准库实现一个基本的 http 服务器


wp_id: 626
Status: draft
Date: 2018-06-22 09:32:00
Modified: 2020-05-16 11:13:32


HTTPserver inherit the BaseServer Class, BaseServer Class has the following methods:

	serve_forever	serve forever using select
	process_request	create a new instance of Requset Handler to handle the request
		ForkingMixin and ThreadingMixin will override it
	ForkingMixin.process_request	create a new process to process the request
	ThreadingMixin.process_requeset	create a new thread to process the request
	handle_requset	calls select get_request verify_request and process_reuset


What a http server does is to wait there and response to each of our request, thus, to implement a http server in python. we need two things, a server waiting, a handler to handle each request.

BaseHTTPServer module gives us two class we need, BaseHTTPServer.HTTPServer and BaseHTTPServer.BaseHTTPHandler.

HTTPServer is a subclass of SocketServer.TCPServer, it's a blocking server. It has one method which is particlarly useful, `serve_forever`.

`BaseHTTPRequestHandler` will be instaniated each time a request comes. With method, SPAM, do_SPAM method will be called with on arguments. All of the relevant information is stored in instance variables of the handler. Subclasses should not need to override or extend the __init__() method. All of this is managed automatically by the server class.

`BaseHTTPRequestHandler` variables:

	client_address	(host, port) tuple
	server	the server instance
	command	'GET' or whatever
	path	reuqest path
	request_version	'HTTP/1.0' or whatever
	headers	class.MessageClass instance, a dict like struct
	rfile	input stream, read this file to get the body
	wfile	write stream, write this file to return response body
	connection	the connection object, inherited from StreamRequestHandler
	
class variables
	protocol_version	by default, it's 'HTTP/1.0', should be chanaged to http/1.1
	MessageClass	by defualt, it's mimetools.Message, consider override it
	
methods
	handle	calls handle_one_request(), should not override
	handle_one_request	calls do_*(), should not override
	send_error(code, [message])	sends and logs an error, body will be empty regrading the RFC
	send_response(code, [message])	sends and logs an response, followed by Server and Date headers
	send_header(k, v)	sends a header
	end_headers()	sends a \r\n to end headers
	log_request/log_error/log_message	logs...
	version/date_time/address_string()	
	
	
A Basic http server


class S(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write("<html><body><h1>hi!</h1></body></html>")

    def do_HEAD(self):
        self._set_headers()
        
    def do_POST(self):
        # Doesn't do anything with posted data
        self._set_headers()
        self.wfile.write("<html><body><h1>POST!</h1></body></html>")


Examples

using serve_forever:

def run(server_class=BaseHTTPServer.HTTPServer,
        handler_class=BaseHTTPServer.BaseHTTPRequestHandler):
    server_address = ('', 8000)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

using custom loop:

def run_while_true(server_class=BaseHTTPServer.HTTPServer,
                   handler_class=BaseHTTPServer.BaseHTTPRequestHandler):
    """
    This assumes that keep_running() is a function of no arguments which
    is tested initially and after each request.  If its return value
    is true, the server continues.
    """
    server_address = ('', 8000)
    httpd = server_class(server_address, handler_class)
    while keep_running():
        httpd.handle_request()