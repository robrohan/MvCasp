<%
	' Class: CSVRecorder
	' This class is used to store information into a CVS file(s)
	' An example controller file would look like the following:
	'
	' (code)
	' Dim MyCSVRecorder
	' Set MyCSVRecorder = new CSVRecorder
	'
	' 'where to store the cvs data		
	' MyCSVRecorder.DataStore = Session("SERVER_INSTALL_PATH") & "\CollectionStore"
	' 'saves the form values to the CVS file using the hidden field "sort"
	' MyCSVRecorder.SaveValuesToFile()
	' (end code)
	' 
	' The Recorder requires the form field "sort" to be defined, and that field lists
	' all the fields and the order the recorder should save the values to the file in.
	'
	' The recorder automatically rolls files and creates a file called TotalProgram.csv
	' which is a running totally of the whole program.
	' The duration of the rolling and the start date of the files can be controlled by
	' setting hidden fields on the form. For example:
	'
	' <input type="hidden" name="sort" value="order:FIRST_NAME,LAST_NAME,TITLE,CONTACT">
	' <input type="hidden" name="startdate" value="2006/08/03">
	' <input type="hidden" name="duration" value="1">
	'
	' Author: 
	'	Rob Rohan (robrohan@gmail.com)
	' Date: 
	' 	2006-09-26
	Class CSVRecorder
		Private m_DataStore
		
		Public Property Get DataStore()
			DataStore = m_DataStore
		End Property
		
		Public Property Let DataStore(p_Data)
			m_DataStore = p_Data
		End Property
		
		'///////////////////////////////////
		Function GetSortArray()
			Dim strSort
			Dim arrStr
			Dim strSortVal
			
			strSort = Request.Form("sort")
			arrStr = Split(strSort,",")
			
			''Remove the "sort:" part of the sort hidden field 
			strSortVal = arrStr(0)
			strSortVal = Right(strSortVal, (Len(strSortVal) - 6) )
			arrStr(0) = strSortVal
			
			GetSortArray = arrStr
		End Function
		
		Function GetFileName()
			Dim dateFileDate
			Dim strFileName
			Dim numWeekDiff
			
			''get the difference between now and the start date in weeks
			numWeekDiff = DateDiff("ww",Request.Form("startdate"),Now())
			
			''now add the difference to the start date to get the filename
			dateFileDate = DateAdd("ww",(Request.Form("duration")*numWeekDiff),Request.Form("startdate"))
			
			strFileName = Year(dateFileDate) & "_" & Month(dateFileDate) & "_" & Day(dateFileDate)
			GetFileName = strFileName
		End Function
		
		Function HeaderValues()
			Dim strHeaderVals
			
			strHeaderVals = "SUBMIT DATE,"
			For Each i in GetSortArray
				strHeaderVals = strHeaderVals & Trim(i) & ","
			Next
			strHeaderVals = strHeaderVals & "REMOTE HOST,HTTP USER AGENT,"
			
			HeaderValues = Left(strHeaderVals,Len(strHeaderVals)-1)
		End Function
		
		Function RowValues()
			Dim strRowVals
			
			strRowVals = Now() & ","
			For Each i in GetSortArray
				strRowVals = strRowVals & CleanValue(Request.Form(Trim(i))) & ","
			Next
			strRowVals = strRowVals & CleanValue(Request.ServerVariables("REMOTE_HOST")) & "," & CleanValue(Request.ServerVariables("HTTP_USER_AGENT")) & ","
			
			RowValues = Left(strRowVals,Len(strRowVals)-1)
		End Function
		
		Function CleanValue(val)
			CleanValue = Trim(Replace(val,","," "))
		End Function
		
		Function AppendLine(filename)
			Dim fs, f, ts
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
						
			If (fs.FileExists(filename)) = false Then
				fs.CreateTextFile filename, true
				Set f = fs.GetFile(filename)
				Set ts = f.OpenAsTextStream(8)
				ts.Write(HeaderValues() & VBCrLF)
			Else
				Set f = fs.GetFile(filename)
				Set ts = f.OpenAsTextStream(8)
			End If
			
			ts.Write(RowValues() & VBCrLF)
			
			Set f = nothing
			Set fs = nothing
		End Function
		
		Function FormatForEmail()
			Dim emailvals
			For Each i in GetSortArray
				emailvals = emailvals & Trim(i) & ": " & Request.Form(Trim(i)) & VBCrLf
			Next
			
			FormatForEmail = emailvals
		End Function
		
		Function SaveValuesToFile()
			AppendLine(DataStore & "\" & GetFileName() & ".csv")
			AppendLine(DataStore & "\" & "TotalProgram.csv")
		End Function
	End Class
%>