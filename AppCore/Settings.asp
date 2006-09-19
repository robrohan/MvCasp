<!--
	+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
	| Session(...)                                                       |
	+====================================================================+
	| CONTROLLER                     | The Controller to use             |
	+--------------------------------------------------------------------+
	| METHOD                         | The Method to run                 |
	+--------------------------------------------------------------------+
	| VIEW                           | The view file to uses             |
	+--------------------------------------------------------------------+
	| ERRORS                         | Array of request errors           |
	+====================================================================+
-->
<%
	APP_DEBUG = true
	INDEX_PAGE = "index"
	'the file extension of the m v c files
	FILE_EXT = ".asp"
	'The directory where this application is installed / if on the root, /myapp, etc
	INSTALL_PATH = Replace(Request.ServerVariables("PATH_INFO"),"/" & (INDEX_PAGE & FILE_EXT),"")
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
	Session("APP_DEBUG") = APP_DEBUG
	Session("ERROR_VIEW") = ERROR_VIEW
	
	Session("CONTROLLER") = CONTROLLER
	Session("METHOD") = METHOD
	Session("VIEW") = VIEW
	
	Dim AppErrors(0)
	Session("ERRORS") = AppErrors
	
	Session("LINK_PATH") = INSTALL_PATH & "/" & INDEX_PAGE & FILE_EXT & "?" & URL_COMMAND_VAR & "="
	Session("LINK_DELIM") = C_M_Delimiter
%>