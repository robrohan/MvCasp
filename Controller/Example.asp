<!-- #include file="../Model/ExampleObject.asp" -->
<%
	Select Case Session("METHOD")
		Case "DoIt"
			Set MyObj = new ExampleObject
			MyObj.BitOData = 2
			MyObj.AddOne()
			
			Session("BitOData") = MyObj.BitOData
		
		Case "DoItAgain"
			Session("BitOData") = "Howdy, this is more information"
		
	End Select
	
	Session("VIEW") = "ExampleView"
%>
