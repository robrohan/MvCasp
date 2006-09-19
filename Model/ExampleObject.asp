<%
	Class ExampleObject
		Private m_BitOData
		
		Public Property Get BitOData()
			BitOData = m_BitOData
		End Property
		
		Public Property Let BitOData(p_Data)
			m_BitOData = p_Data
		End Property
		
		'///////////////////////////////////
		
		Public Function AddOne()
			BitOData = BitOData + 1
		End Function
	End Class
%>