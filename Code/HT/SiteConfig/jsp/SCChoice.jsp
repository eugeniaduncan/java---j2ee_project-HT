<%@ page contentType="text/html" errorPage="/jsp/SCError.jsp"%>

<%@ page import =   "javax.naming.*,
							java.sql.*,
							com.hoteltools.tbsupport.OrgID,
							com.hoteltools.tbsupport.OrgIDHome,
							com.hoteltools.platform.util.LogOutput,
							com.hoteltools.platform.util.HTDatabase,
							com.hoteltools.platform.util.DatasourceConnectionException"
%>

<%
/*
 ********************************************************************
 * JSP Name:    SCChoice.jsp                                        *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%!
	private final String JNDI_NAME1 = "ejb.OrgID";
	private String err_message      = null;

	private String html_select      = null;
	private String html_devices     = null;
	private String html_info        = null;

	private String hidden_org_index = null;
	private String hidden_org_val   = null;

	private String hidden_dev_index = null;
	private String hidden_dev_val   = null;

	private String hidden_save		  = null;
	private String hidden_send		  = null;

	private String hidden_mod		  = null;
	private String hidden_add		  = null;
	private String hidden_rem		  = null;
%>

<%
	selectOutput();

	hidden_org_index  = request.getParameter("hid_org_index");
	hidden_org_val    = request.getParameter("hid_org_val");
	hidden_dev_index  = request.getParameter("hid_dev_index");
	hidden_dev_val    = request.getParameter("hid_dev_val");

	System.out.println("hidden_org_index ="+hidden_org_index);
	System.out.println("hidden_org_val ="  +hidden_org_val);
	System.out.println("hidden_dev_index ="+hidden_dev_index);
	System.out.println("hidden_dev_val ="  +hidden_dev_val);

	
	// if user attempts to bypass login procedure to open this page, redirect back to login
	if (!((String) session.getAttribute("PageFrom")).equals("150"))
	{
		response.sendRedirect("/jsp/SCLogin.jsp");
	}


	// if user submits logout, redirect to logout page
	if (request.getParameter("loggout") != null)
	{
		session.removeAttribute("PageFrom");
		String page_from = "1000";
		session.setAttribute("PageFrom", page_from);
		response.sendRedirect("/jsp/SCLogout.jsp");					
	}
	

	// if org selected
	if (request.getParameter("org_selected") != null && request.getParameter("org_selected").equals("truth"))
	{
		System.out.println("org selected");

		if (hidden_org_index.equals("0"))
		{
			System.out.println("org if");

			html_devices         = null;
			html_info            = null;
		}
		else
		{
			System.out.println("org else");

			session.removeAttribute("devices_list");
			session.removeAttribute("org_id");
			
			html_devices = findDevices(hidden_org_val);
			html_info    = null;

			session.setAttribute("devices_list", html_devices);
			session.setAttribute("org_id", hidden_org_val);
		}
	}

	// if devices selected
	if (request.getParameter("dev_selected") != null && request.getParameter("dev_selected").equals("truth"))
	{
		System.out.println("devices selected");

		if (hidden_dev_index.equals("0"))
		{
			System.out.println("dev if");

			html_info            = null;
		}
		else
		{
			System.out.println("dev else");

			html_devices = (String) session.getAttribute("devices_list");

			String org_id = (String) session.getAttribute("org_id");

			session.setAttribute("dev_val", hidden_dev_val);

			System.out.println("hidden_dev_val ="+hidden_dev_val+", org_id = "+org_id);

			html_info = findInfo(hidden_dev_val, org_id);
		}
	}

	// if modify button submitted
	if (request.getParameter("hid_mod") != null && request.getParameter("hid_mod").equals("truth"))
	{
		System.out.println("hid_mod equals truth - Modify button clicked.");
		response.sendRedirect("/jsp/SCConfig.jsp");
	}

	// if add button submitted
	if (request.getParameter("hid_add") != null && request.getParameter("hid_add").equals("truth"))
	{
		System.out.println("hid_add equals truth - Add button clicked.");
		response.sendRedirect("/jsp/SCConfig.jsp");
	}

	// if remove button submitted
	if (request.getParameter("hid_rem") != null && request.getParameter("hid_rem").equals("truth"))
	{
		System.out.println("hid_rem equals truth - Remove button clicked.");
		response.sendRedirect("/jsp/SCConfig.jsp");
	}

	// if save button submitted
	if (request.getParameter("hid_save") != null && request.getParameter("hid_save").equals("truth"))
	{
		System.out.println("hid_save equals truth - Save button clicked.");
		response.sendRedirect("/jsp/SCConfig.jsp");
	}

	// if save&send button submitted
	if (request.getParameter("hid_send") != null && request.getParameter("hid_send").equals("truth"))
	{
		System.out.println("hid_send equals truth - Save&Send button clicked.");
		response.sendRedirect("/jsp/SCConfig.jsp");
	}
%>

<%!
private void selectOutput()
{
	/* this method loads organization choices into 
	   organization combo box using OrgID ejb */

	boolean flag = false;
	Context ctx  = null;
	try
	{	  
		// get context
		ctx = new InitialContext();
  
		// get org ids for select tag
		OrgIDHome orghome = (OrgIDHome) ctx.lookup(JNDI_NAME1);
		OrgID org = orghome.create();
		html_select = org.accessDB();
		flag = true;
		org.remove();
	}
	catch (Exception e)
	{
		// general exception (catches all exceptions not previously caught)
		System.out.println("Exception:\n"+ e);
		err_message = "There was a processing error.  Contact system administrator.\n";
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
			System.out.println("Failed to close context.");
			err_message = "There was a processing error.  Contact administrator.\n";
			flag = false;
		}

		System.out.println("flag (selectOutput()) = " + flag);
	}
}
%>

<html>
<head>
	<style type="text/css">
	<!--
		#errorMsg{color:red;text-weight:bold;FONT:24pt;}
	-->
	</style>
	<title>Selection Page</title>
	<script language="javascript">
	 
	 function validateSave()
	 {
		  var validity = true;

		  document.formConfig.hid_save.value = "truth";
		  document.formConfig.hid_send.value = "falsehood";

		  if (document.formConfig.orgs.selectedIndex == 0)
		  {
				alert("An organization must be selected.");
				validity = false;
		  }

		  if (validity == true) document.formConfig.submit();
		  else location.reload();
	 }	 

	 function validateSaveAndSend()
	 {
		  var validity = true;

		  document.formConfig.hid_save.value = "falsehood";		  
		  document.formConfig.hid_send.value = "truth";

		  if (document.formConfig.orgs.selectedIndex == 0)
		  {
				alert("An organization must be selected.");
				validity = false;
		  }

		  if (validity == true) document.formConfig.submit();
		  else location.reload();
	 }

	 function validateModify()
	 {
	 }

	 function validateAdd()
	 {
	 }

	 function validateRemove()
	 {
	 }

	 function showDevices()
	 {
			var index_org = document.formConfig.orgs.selectedIndex;
			var value_org = document.formConfig.orgs.options[index_org].value;

			document.formConfig.hid_org_index.value  = index_org;
			document.formConfig.hid_org_val.value    = value_org;

			document.formConfig.org_selected.value  = "truth";
			document.formConfig.dev_selected.value  = "falsehood";

			document.formConfig.hid_save.value = "falsehood";
			document.formConfig.hid_send.value = "falsehood";

			document.formConfig.devices.selectedIndex = 0;

			var index_dev = document.formConfig.devices.selectedIndex;

			document.formConfig.hid_dev_index.value = document.formConfig.devices.selectedIndex;
			document.formConfig.hid_dev_val.value   = document.formConfig.devices.options[index_dev].text;

			document.formConfig.submit();
	 }

	 function showAll()
	 {
			var index_dev = document.formConfig.devices.selectedIndex;
			var value_dev = document.formConfig.devices.options[index_dev].text;

			document.formConfig.hid_dev_index.value = index_dev;
			document.formConfig.hid_dev_val.value   = value_dev;

			var index_org = document.formConfig.orgs.selectedIndex;
			var value_org = document.formConfig.orgs.options[index_org].value;

			document.formConfig.hid_org_index.value = index_org;
			document.formConfig.hid_org_val.value   = value_org;

			document.formConfig.org_selected.value  = "falsehood";
			document.formConfig.dev_selected.value  = "truth";

			document.formConfig.hid_save.value = "falsehood";
			document.formConfig.hid_send.value = "falsehood";

			document.formConfig.submit();
	 }

	 function loadValues()
	 {
		  document.formConfig.orgs.selectedIndex       = document.formConfig.hid_org_index.value;
		  document.formConfig.devices.selectedIndex    = document.formConfig.hid_dev_index.value;

		  if (document.formConfig.orgs.selectedIndex == 0)
		  {
				document.formConfig.devices.selectedIndex    = 0;
		  }

		  document.formConfig.org_selected.value  = "falsehood";
		  document.formConfig.dev_selected.value  = "falsehood";

		  document.formConfig.hid_save.value = "falsehood";
		  document.formConfig.hid_send.value = "falsehood";
	 }
	
	</script>
</head>
<body bgcolor="#000080" text="#ffffff" onload="loadValues();">

<center>
	<h1><strong><font face="times">SITE CONFIGURATION SELECTION PAGE</font></strong></h1>
</center>
<!--
	<table>
		<tr>
			<td>
				<form method="post" action="/jsp/page.jsp">
					<input type="submit" name="loggedout" value="Logout">
				</form>
			</td>
			<td>
				<form method="post" action="/jsp/page.jsp">
					<input type="submit" name="selection" value="Back to Options Page">
				</form>
			</td>
		</tr>
	</table>
-->	

<center>
<span id="errorMsg">
<%=err_message%>
<br>
</span>
</center>

<center>
<form name="formConfig" method="post" action="/jsp/SCSelection.jsp">
<input type="hidden" name="hid_org_index" value="<%=hidden_org_index%>">
<input type="hidden" name="hid_org_val" value="<%=hidden_org_val%>">

<input type="hidden" name="hid_dev_index" value="<%=hidden_dev_index%>">
<input type="hidden" name="hid_dev_val" value="<%=hidden_dev_val%>">

<input type="hidden" name="hid_save" value="<%=hidden_save%>">
<input type="hidden" name="hid_send" value="<%=hidden_send%>">

<input type="hidden" name="hid_mod" value="<%=hidden_mod%>">
<input type="hidden" name="hid_add" value="<%=hidden_add%>">
<input type="hidden" name="hid_rem" value="<%=hidden_rem%>">

<input type="hidden" name="org_selected">
<input type="hidden" name="dev_selected">

<table width="60%" cols="1" border="10">
 <caption><h3>Device Configuration</h3></caption>
	
				<tr>
					<td align="center" colspan="2">
					(1st step)&nbsp;&nbsp;
					<strong>Select organization:</strong>
						<select name="orgs" onchange="showDevices();">
							<option selected value="None">Organization Here</option> <%=html_select%>
						</select>
					</td>
				</tr>
				
				<tr align="center">
					<td width="50%">
						<table>
							<tr>
								<td>
							Click on a device to view its description and properties below.<br>
							<center>
								<select name="devices" size="6" onchange="showAll();">
									<option selected value="None">Devices:
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</option>
																		
									<%=html_devices%>
								
								</select>
							</center>
								</td>
							</tr>
							
							<tr align="center">
								<td>
									<button name="modify_device" onclick="validateModify();">Modify Device</button>  
								&nbsp;&nbsp;
									<button name="add_device" onclick="validateAdd();">Add Device</button>  
								&nbsp;&nbsp;
									<button name="remove_device" onclick="validateRemove();">Remove Device</button>  
								</td>								
							</tr>
						</table>
					</td>
				</tr>				
</table>
<br>

<%=html_info%>
			
</form>
</center>

</body>
</html>





