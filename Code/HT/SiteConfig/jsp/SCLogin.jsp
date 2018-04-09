<%@ page contentType="text/html" errorPage="/jsp/SCError.jsp"%>

<%@ page import =   "javax.naming.Context,
							javax.naming.InitialContext,
							java.util.Enumeration,
							com.hoteltools.tbsupport.TBSupport,
							com.hoteltools.tbsupport.TBSupportHome,
							com.hoteltools.platform.util.LogOutput"
%>

<%
/*
 ********************************************************************
 * JSP Name:    SCLogin.jsp                                         *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%!
	private final String JNDI_NAME = "ejb.TBSupport";
	private String err_message	    = "";
	private String username		    = "";
	private String password		    = "";
	private LogOutput log          = new LogOutput("SCLogin");
	private boolean flag_out       = false;
%>

<%

	if (request.getParameter("submit") != null)
	{
		// reassign variables as input from client
		username = request.getParameter("usnm");
		password = request.getParameter("pswd");
		err_message = "";

		if (validateForm())
		{
			log.debug("Form validated.");
			if (validateEntries())
			{
				log.debug("Entries validated.");

				//String page_from = "100";

				session.setMaxInactiveInterval(900);
				session.setAttribute("UserID", username);
				session.setAttribute("Passwd", password);
				//session.setAttribute("PageFrom", page_from);

				log.debug("Forward to SCSelection.jsp.");

				response.sendRedirect("/jsp/SCSelection.jsp");		
			}
			else if (flag_out==true)
			{
				log.debug("Entries NOT validated.");

				err_message = "There was a processing error.  Contact system administrator.\n";
			}
			else
			{
				log.debug("Entries NOT validated.");

				err_message = "UserID and password are NOT valid.";				
			}
		}
		else
		{
			log.debug("Form NOT validated.");
		}
	}
%>

<%!
private boolean validateForm()
{
	boolean flag = false;
	
	// get the user ID and password - if either are left blank, error message
	
	if (username.equals("") || password.equals(""))
	{
		err_message = "You must enter a userID AND a password.";
		flag = false;
	}
	else
	{
		err_message = "";
		flag = true;
	}

return flag;
}

%>

<%!
private boolean validateEntries()
{
	boolean flag = false;
	Context ctx = null;
	
	try
	{
		// get context
		ctx = new InitialContext();

		// get authentication
		TBSupportHome tbshome = (TBSupportHome) ctx.lookup(JNDI_NAME);
		TBSupport tbs = tbshome.create();
		flag = tbs.isAuthentic(username, password);
		tbs.remove();
	}
	catch (Exception e)
	{
		// general exception
		log.debug("Exception:\n"+ e);
		flag_out = true;
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
			log.debug("Failed to close jndi context.");
			flag_out = true;
			flag = false;
		}
	}

return flag;
}
%>

<html>
<head>
	<style type="text/css">
	<!--
		#errorMsg{color:red;text-weight:bold;FONT:24pt;}
	-->
	</style>
	<title>Support Login</title>
	<script language="javascript">

		function resetPage()
		{
			 document.form1.usnm.value = "";
			 document.form1.pswd.value = "";
			 document.all.errorMsg.style.display = "none";
		}
		
		function newSettings()
		{
			 document.form1.usnm.value = "";
			 document.form1.pswd.value = "";
		}

	</script>
	
</head>
<body bgcolor="#000080" text="#FFFFFF" onload="newSettings();">
<br>
<br>
<center><h1><strong><font face="times" size="+5">SITE CONFIGURATION<br>LOGIN PAGE</font></strong></h1></center>
<br>
<br>
<center>
<span id="errorMsg"><%=err_message%></span>
<br>
</center>
<br>
<br>
<center>
<form name="form1" method="post" action="/jsp/SCLogin.jsp">
	<table width="50%" height="30%" border="20">
		<tr>
			<td align="center"><strong>USER NAME</strong></td>
			<td align="center"><input type="text" name="usnm" value="<%=username%>" maxlength="10"></td>
		</tr>
		<tr>
			<td align="center"><center><strong>PASSWORD</strong></center></td>
			<td align="center"><input type="password" name="pswd" value="<%=password%>" maxlength="10"></td>
		</tr>
		<tr>
		<td align="center"><input type="submit" name="submit" value="Login"></td>
		<td><marquee align="middle" direction="ltr" behavior="slide">&lt;&#151; <em>Log on!</em></marquee></td>
		</tr>
		<tr>
		<td align="center"><button name="reset" onclick="resetPage();">Reset</button></td>
		<td></td>
		</tr>		
	</table>
	<br>
</form>
</center>
</html>








