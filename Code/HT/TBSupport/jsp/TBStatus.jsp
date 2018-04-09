<%@ page contentType="text/html" errorpage="/jsp/TBError.jsp" %>

<%@ page import =   "javax.naming.Context,
							javax.naming.InitialContext,
							com.hoteltools.platform.util.LogOutput,
							com.hoteltools.tbsupport.TBSupport,
							com.hoteltools.tbsupport.TBSupportHome"

%>

<%
/*
 ********************************************************************
 * JSP Name:    TBStatus.jsp                                        *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%!
	private final String JNDI_NAME = "ejb.TBSupport";
	private String err_message = "";
	private String html = null;
	private String html_output_stat = null;
	private LogOutput log = new LogOutput("TBStatus");
%>

<%
	// if user attempts to bypass login procedure to open this page, redirect back to login	
	if (!((String) session.getAttribute("PageFrom")).equals("300"))
	{
		response.sendRedirect("TBLogin.jsp");
	}

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
		session.removeAttribute("org_variable");
		session.removeAttribute("PageFrom");
		String page_from = "100";
		session.setAttribute("PageFrom", page_from);
		response.sendRedirect("/jsp/TBSelection.jsp");					
	}

	// if user submits update, redirect back to this page
	if (request.getParameter("update") != null) 		
	{
		response.sendRedirect("/jsp/TBStatus.jsp");					
	}

	// assign html variable with html string
	String org_id = (String) session.getAttribute("org_variable");
	statOutput(org_id);
	html = html_output_stat;
						
	
%>

<%!
private void statOutput(String orgs)
{
	/* this method assigns html for the status page */

	boolean flag = false;
	Context ctx  = null;
	String org   = orgs;
	long ID     = 0L;

	try
	{		  
		// get context
		ctx = new InitialContext();
  
		// get org ids for select tag
		TBSupportHome tbshome = (TBSupportHome) ctx.lookup(JNDI_NAME);
		TBSupport tbs = tbshome.create();
		if(org.equals("All"))
		{
			html_output_stat = tbs.showStatus();
		}
		else
		{
			try
			{
				ID = Long.parseLong(org);
			}
			catch (NumberFormatException nfe)
			{
				log.debug("NumberFormatException: \n" + nfe.getMessage());
				throw nfe;
			} 

			html_output_stat = tbs.showStatus(ID);
		}
		flag = true;
		tbs.remove();
	}
	catch (Exception e)
	{
		// general exception (catches all exceptions not previously caught)
		log.debug("Exception:\n"+ e);
		flag = false;
	}
	finally
	{
		try
		{
			ctx.close();
		}
		catch (Exception e)
		{
			// a failure occurred closing context
			log.debug("Failed to close context.");
			flag = false;
		}

		log.debug("flag (statOutput()) = " + flag);
	}
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
	<title>Status Page</title>
	<script language="javascript">

		  window.setInterval("document.formRefresh.submit()", 300000); 	
		
	</script>
</head>
<body bgcolor="#000080">
<center>
	<h1><strong><font face="times" color="white">TOOLBOX SITE STATUS PAGE</font></strong></h1>
</center>
<center>
	<span id="errorMsg">
	<%=err_message%><br>
	</span>
</center>
	<table>
		<tr>
			<td>
				<form method="post" action="/jsp/TBLogout.jsp">
					<input type="submit" name="loggedout" value="Logout">
				</form>
			</td>
			<td>
				<form method="post" action="/jsp/TBSelection.jsp">
					<input type="submit" name="selection" value="Back to Selection Page">
				</form>
			</td>
			<td>
				<form name="formRefresh" method="post" action="/jsp/TBStatus.jsp">
					<input type="submit" name="update" value="Refresh Table">
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
