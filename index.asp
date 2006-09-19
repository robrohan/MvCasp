<!-- #include file="AppCore/Settings.asp" -->
<!-- #include file="AppCore/Utils.asp" -->
 
<%
	'get the controller and method out of the url and into the session
	Utils.BreakoutContolMethod()
	
	'Run the controller if it exists
	ControllerFile = INSTALL_PATH & "/Controller/" & Session("CONTROLLER") & FILE_EXT
	If Utils.FileExists(Server.MapPath(ControllerFile)) Then 
		Server.Execute(ControllerFile)
	Else
		Utils.AddError("Controller '" & Session("CONTROLLER") & "' is not defined (" & ControllerFile & ")")
	End If
	
	Utils.ShowView(Session("VIEW") & FILE_EXT)
	
	''////////////////////////////////////////////////////////////////

	If(Session("APP_DEBUG")) Then
		Response.Write("<link rel='stylesheet' type='text/css' href='AppCore/Debug.css' />")
		Response.Write("<div id='mvcasp_debug'>")
		Response.Write("<p><strong>Controller</strong>: " & Session("CONTROLLER") & "</p>")
		Response.Write("<p><strong>Method</strong>: " & Session("METHOD") & "</p>")
		Response.Write("<p><strong>View</strong>: " & Session("VIEW") & "</p>")
		Response.Write("<hr/>")
		
		For Each name In Request.ServerVariables
			Response.Write("<p><strong>" & name & "</strong>: " & Request.ServerVariables(name) & "</p>")
		Next
		
		Response.Write("</div>")
	End If
	
	'Since there is no such thing as the request scope in asp (writeable one) kill
	'the session so it will be treated like a request scope
	Session.Abandon
%>