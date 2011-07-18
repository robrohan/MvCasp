<%
'	+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
'	| Session(...)                                                       |
'	+====================================================================+
'	| CONTROLLER                     | The Controller to use             |
'	+--------------------------------------------------------------------+
'	| METHOD                         | The Method to run                 |
'	+--------------------------------------------------------------------+
'	| VIEW                           | The view file to uses             |
'	+--------------------------------------------------------------------+
'	| ERRORS                         | Array of request errors           |
'	+====================================================================+

	APP_DEBUG = true
	INDEX_PAGE = "index"
	'the file extension of the m v c files
	FILE_EXT = ".asp"
	'The directory where this application is installed / if on the root, /myapp, etc
	INSTALL_PATH = Replace(Request.ServerVariables("PATH_INFO"),"/" & (INDEX_PAGE & FILE_EXT),"")
	SERVER_INSTALL_PATH = Replace(Request.ServerVariables("PATH_TRANSLATED"), "\" & (INDEX_PAGE & FILE_EXT),"")
	'The default controller "page"
	CONTROLLER = "Example"
	'The default method
	METHOD = "DoIt"
	'The default view
	VIEW = "ExampleView"
	
	'The default error view
	ERROR_VIEW = "DefaultError"
	
	'the delimiter for the CONTROLLER/METHOD parameter passed in the url
	'for example index.asp?C=testcontroller.dosomething
	C_M_Delimiter = "."
	'The url variable that has the controller / method
	URL_COMMAND_VAR = "C"
	
	'////////////////////////////////////////////////////////////////////////////////////////
	'-- SMTP settings --
	' If the server is setup with a default SMTP server this is not needed; however, it is
	' pretty common to have a different server for email sending.  This should work for most
	' cases 
	Session("USE_SMTP") = False
		'Send the message using the network (SMTP over the network).
		Session("SEND_USING") = 2
		Session("SMTP_SERVER") = "mail.yoursite.com"
		Session("SMTP_SERVER_PORT") = 25
		Session("SMTP_USE_SSL") = False
		Session("SMTP_CONNECTION_TIMEOUT") = 60
	Session("USE_SMTP_AUTH") = False
		'1 = clear-text authentication
		Session("SMTP_AUTHENTICATE") = 1
		Session("SEND_USERNAME") = "a@b.com"
		Session("SEND_PASSWORD") = "password"
	'-- SMTP settings --
	
	Session("APP_DEBUG") = APP_DEBUG
	Session("ERROR_VIEW") = ERROR_VIEW
	
	Session("CONTROLLER") = CONTROLLER
	Session("METHOD") = METHOD
	Session("VIEW") = VIEW
	
	Dim AppErrors(0)
	Session("ERRORS") = AppErrors
	
	Session("LINK_PATH") = INSTALL_PATH & "/" & INDEX_PAGE & FILE_EXT & "?" & URL_COMMAND_VAR & "="
	Session("LINK_DELIM") = C_M_Delimiter
	Session("INSTALL_PATH") = INSTALL_PATH
	Session("SERVER_INSTALL_PATH") = SERVER_INSTALL_PATH
	Session("FILE_EXT") = FILE_EXT
%>