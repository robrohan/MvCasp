<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!-- #include file="../AppCore/Utils.asp" -->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Error</title>
</head>
<body>
	<p>Oops, an error</p>
	<%
		aryErrors = Session("ERRORS")
		If(Utils.HasErrors) Then
			For i = 0 to UBound(aryErrors)
				Response.Write(i & ": " & Session("ERRORS")(i) & "<br>")
			Next
		End If
	%>
</body>
</html>