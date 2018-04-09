<%@ page contentType="text/html" isErrorPage="true"%>
<%@ page import="com.hoteltools.platform.util.LogOutput"%>

<%
/*
 ********************************************************************
 * JSP Name:    TBError.jsp                                         *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%
	
	StringBuffer html_data = new StringBuffer(750);
	LogOutput log = new LogOutput("TBError");

	try 
	{
	
		 html_data.append("<html> ");
		 html_data.append("<head><title>Support Login</title></head>");
		 html_data.append("<body>");
		 html_data.append("<form method=\"post\" action=\"/jsp/TBLogin.jsp\">");
		 html_data.append("<h1><b>ERROR!</b></h1><br><br>");
		 html_data.append("<br>");
		 html_data.append("<br><b>Click here to try again:</b><br><br>");
		 html_data.append("<input type=\"submit\" name=\"submit\" value=\"Retry\">");
		 html_data.append("</form> ");
		 html_data.append("</body>");
		 html_data.append("</html> ");
	
		 
	}
	catch  (Exception e)
	{
		log.debug("Exception:\n" + e);
	
	}

	session.removeAttribute("PageFrom");
	session.invalidate();

	if ("POST".equals(request.getMethod()))
	{

		response.sendRedirect("/jsp/TBLogin.jsp");
	
	}
	
%>

<%= html_data.toString()%>


