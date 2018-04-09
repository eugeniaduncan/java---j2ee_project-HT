<%@ page contentType="text/html" errorpage="/jsp/TBError.jsp" %>

<%
/*
 ********************************************************************
 * JSP Name:    TBHistory.jsp                                       *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%!
	private String err_message = "";
	private String html = null;
	private String site = null;
%>

<%
	// if user attempts to bypass login procedure to open this page, redirect back to login	
	if (!((String) session.getAttribute("PageFrom")).equals("200"))
	{
		response.sendRedirect("TBLogin.jsp");
	}

	// assign html variable with html string from selection page
	html = (String) session.getAttribute("htmloutHistory");
	site = (String) session.getAttribute("site_info");

	// if user submits logout, redirect to logout page
	if (request.getParameter("loggedout") != null)
	{
		session.removeAttribute("PageFrom");
		String page_from = "1000";
		session.setAttribute("PageFrom", page_from);
		response.sendRedirect("/jsp/TBLogout.jsp");					
	}

	// if user submits selection, redirect back to selection page
	if (request.getParameter("selection") != null)
	{
		session.removeAttribute("site_info");
		session.removeAttribute("PageFrom");
		String page_from = "100";
		session.setAttribute("PageFrom", page_from);
		response.sendRedirect("/jsp/TBSelection.jsp");					
	}
%>


<html>
<head>
	<style type="text/css">
	<!--
		#errorMsg{color:red;text-weight:bold;FONT:24pt;}
		th{text-weight:bold;}
	-->
	</style>
	<title>History Page</title>
</head>
<body bgcolor="#000080">
<center>
	<h1><strong><font face="times" color="white">TOOLBOX SITE HISTORY PAGE</font></strong></h1><br>
	<h3><strong><font face="times" color="white"><%=site%></font></strong></h3>
</center>
<center>
	<span id="errorMsg">
	<%=err_message%><br>
	</span>
</center>
	<table>
		<tr>
			<td>
				<form method="post" action="/jsp/TBHistory.jsp">
					<input type="submit" name="loggedout" value="Logout">
				</form>
			</td>
			<td>
				<form method="post" action="/jsp/TBHistory.jsp">
					<input type="submit" name="selection" value="Back to Selection Page">
				</form>
			</td>
		</tr>
	</table>
	<br>
	<center>
		<table border="5" bordercolor="#000000" bgcolor="#ffffff">
			<%=html%>
		</table>
	</center>
	<br>
</body>
</html>
