<%
	' Class: Login
	' This is a simple class used to slightly protect a directory
	' This is not very secure, but rather just a "hey don't go here"
	' kind of security. It does not require a database. To create a 
	' login you could do the following
	' (code)
	' Dim MyLogin
	' Set MyLogin = new Login
	' MyLogin.DataFile = Session("SERVER_INSTALL_PATH") & "\AppDatastore\users.dat"
	' 
	' UserLevel = MyLogin.DoLogin(Request.Form("username"), Request.Form("password"))
	' (end code)
	'
	' The code sets a cookie, and after login you can check to see if
	' they are still logged in by doing something like
	' (code)
	' If(Not MyLogin.IsLoggedIn()) Then
	'	'show login
	' Else
	'	'do somethign else
	' End If
	'
	' When you are ready to end the session just do
	' (code)
	' MyLogin.DoLogout()
	' (end code)
	'
	' The file is a simple text file that is in the form
	' (code)
	' username:password:level
	' (end code)
	'
	' Where username  and password are just that, and level can be anything you'd like
	' (ADMIN, USER, MARKETING, etc)
	Class Login
		Private m_DataFile
		
		Public Property Get DataFile()
			DataFile = m_DataFile
		End Property
		
		Public Property Let DataFile(p_Data)
			m_DataFile = p_Data
		End Property
		
		'///////////////////////////////////
		Public Function DoLogin(strUser, strPass)
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			Set f = fs.OpenTextFile(DataFile, 1)
			
			Dim strLine, LOGIN_COOKIE
			Dim arr
			LOGIN_COOKIE="l06c0ok3"
			
			Do Until f.AtEndOfStream
				strLine = f.ReadLine
				arr = Split(strLine, ":")
				
				If LCase(arr(0)) = LCase(strUser) And LCase(arr(1)) = LCase(strPass) Then
					Response.Cookies(LOGIN_COOKIE) = Rot13(strUser)
					DoLogin = arr(2)
					Exit Do
				End If
			Loop
			
			f.Close
			
			Set f = Nothing
			Set fs = Nothing
		End Function
		
		Public Function DoLogout()
			Dim LOGIN_COOKIE
			LOGIN_COOKIE="l06c0ok3"
			
			Response.Cookies(LOGIN_COOKIE) = ""
		End Function
		
		Function IsLoggedIn()
			Dim fname, LOGIN_COOKIE
			
			LOGIN_COOKIE="l06c0ok3"
			fname = Request.Cookies(LOGIN_COOKIE)
			
			If (fname = "") Then
				IsLoggedIn = false
			Else
				IsLoggedIn = true
			End If
		End Function
		
		Function Rot13(rot13text)
			rot13text_rotated = "" '' the function will return this string
			For i = 1 to Len(rot13text)
				j = Mid(rot13text, i, 1) '' take the next character in the string
				k = Asc(j) '' find out the character code
				If k >= 97 and k =< 109 then
					k = k + 13 '' a ... m inclusive become n ... z
				elseif k >= 110 and k =< 122 then
					k = k - 13 '' n ... z inclusive become a ... m
				elseif k >= 65 and k =< 77 then
					k = k + 13 '' A ... M inclusive become N ... Z
				elseif k >= 78 and k =< 90 then
					k = k - 13 '' N ... Z inclusive become A ... M
				End If
				''add the current character to the string returned by the function
				
				rot13text_rotated = rot13text_rotated & Chr(k)
			Next
			Rot13 = rot13text_rotated
		End Function
		
	End Class
%>