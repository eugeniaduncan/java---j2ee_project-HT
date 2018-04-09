<%@ page contentType="text/html" errorpage="/jsp/SCError.jsp"%>

<%
/*
 ********************************************************************
 * JSP Name:    SCLogout.jsp                                        *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%
	// if user attempts to bypass login procedure to open this page, redirect back to login	
	if (!((String) session.getAttribute("PageFrom")).equals("1000"))
	{
		response.sendRedirect("SCLogin.jsp");
	}

	session.removeAttribute("PageFrom");
	
	session.invalidate();
%>


<html>
<head>
	<title>Logout Page</title>
</head>
<body bgcolor="#000080" text="#FFFFFF">
<br>
<br>
<br>
<center><h1>You have successfully logged out.</h1></center>
</body>
</html>

