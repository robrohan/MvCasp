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
			Dim emailaddr
			
			If Len(emailaddr) > 0 Then
				Set myMail = CreateObject("CDO.Message")
				myMail.Subject = Subject
				myMail.From = From
				myMail.To = ToEmail
				myMail.TextBody = txtMessage
				
				myMail.Send
				Set myMail = Nothing
			End If
		End Function
		
	End Class
%>