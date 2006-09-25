<%
	Class ImplUtils
		
		Public Function MakeControlMethod()
			MakeControlMethod = Session("CONTROLLER") & C_M_Delimiter & Session("METHOD")
		End Function
		
		Public Function CreateLink(strController, strMethod)
			CreateLink = Session("LINK_PATH") & strController & Session("LINK_DELIM") & strMethod
		End Function
		
		Public Function BreakoutContolMethod()
			Dim strControlMethod 
			Dim aryControlMethod
			strControlMethod = Request.QueryString(URL_COMMAND_VAR)
		
			aryControlMethod = Split(strControlMethod, C_M_Delimiter)
			
			If(UBound(aryControlMethod) > 0) Then
				Session("CONTROLLER") = aryControlMethod(0)
				If(UBound(aryControlMethod) >= 1) Then
					Session("METHOD") = aryControlMethod(1)
				End If
			End If
		End Function
		
		Public Function ShowView(strViewPath)		
			ViewFile = Session("INSTALL_PATH") & "/View/" & strViewPath
			
			If FileExists(Server.MapPath(ViewFile)) Then 
				ShowView = Server.Execute(ViewFile)
			Else
				AddError("View '" & Session("VIEW") & "' is not defined (" & ViewFile & ")")
				Server.Execute( Session("INSTALL_PATH") & "/View/" & Session("ERROR_VIEW") & Session("FILE_EXT") )
			End If
		End Function
		
		Public Function FileExists(strFilepath)
			Set FSO = CreateObject("Scripting.FileSystemObject")
			FileExists = FSO.FileExists(strFilepath)
		End Function
		
		Public Function AddError(strText)
			aryErrors = Session("ERRORS")
			iErrorSize = UBound(aryErrors)
			Redim Preserve aryErrors(iErrorSize+1)
			aryErrors(iErrorSize) = strText
			Session("ERRORS") = aryErrors
		End Function
		
		Public Function HasErrors()
			If(UBound(aryErrors) > 0) Then
				HasErrors = true
			Else
				HasErrors = false
			End If
		End Function
	End Class
	
	Set Utils = new ImplUtils
%>

