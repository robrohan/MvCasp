<%
	' Class: Mailer
	' Simple class to wrap up sending mail. Example usage:
	' (code)
	' Dim MyMailer
	' Set MyMailer = new Mailer
	'		
	' MyMailer.ToEmail = "test@gmail.com"
	' MyMailer.From = "test@blarg.com"
	' MyMailer.Subject = "Form Submission"
	' MyMailer.SendMail("test mail")
	' (end code)
	Class Mailer
		Private m_ToEmail
		Private m_Subject
		Private m_From
		
		Public Property Get ToEmail()
			ToEmail = m_ToEmail
		End Property
		
		Public Property Let ToEmail(p_Data)
			m_ToEmail = p_Data
		End Property
		
		Public Property Get Subject()
			Subject = m_Subject
		End Property
		
		Public Property Let Subject(p_Data)
			m_Subject = p_Data
		End Property
		
		Public Property Get From()
			From = m_From
		End Property
		
		Public Property Let From(p_Data)
			m_From = p_Data
		End Property
		
		'///////////////////////////////////
				
		Function SendMail(txtMessage)
			If Len(ToEmail) > 0 Then
				Set myMail = CreateObject("CDO.Message") 

				'If we need to use an external SMTP server, this will setup the configuration
				'Change the values in AppCore/Settings.asp instead of here
				If Session("USE_SMTP") Then
					Set baseNS = "http://schemas.microsoft.com/cdo/configuration/"
					myMail.Configuration.Fields.Item(baseNS & "sendusing") = Session("SEND_USING")
					myMail.Configuration.Fields.Item(baseNS & "smtpserver") = Session("SMTP_SERVER")
					myMail.Configuration.Fields.Item(baseNS & "smtpserverport") = Session("SMTP_SERVER_PORT")
					myMail.Configuration.Fields.Item(baseNS & "smtpusessl") = Session("SMTP_USE_SSL")
					myMail.Configuration.Fields.Item (baseNS & "smtpconnectiontimeout") = Session("SMTP_CONNECTION_TIMEOUT")

					'If the SMTP server needs authentication
					If Session("USE_SMTP_AUTH") Then
						myMail.Configuration.Fields.Item(baseNS & "smtpauthenticate") = Session("SMTP_AUTHENTICATE")
						myMail.Configuration.Fields.Item(baseNS & "sendusername") = Session("SEND_USERNAME")
						myMail.Configuration.Fields.Item (baseNS & "sendpassword") = Session("SEND_PASSWORD")
					End If

					myMail.Configuration.Fields.Update
				End If
				'=== SMTP server configuration ===

				myMail.Subject = Subject
				myMail.From = From
				myMail.To = ToEmail
				'myMail.HTMLBody = "this is the body"
				myMail.TextBody = txtMessage

				myMail.Send
				Set myMail = Nothing
			End If
		End Function
		
	End Class
%>