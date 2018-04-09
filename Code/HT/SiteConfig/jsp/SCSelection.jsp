<%@ page contentType="text/html" errorPage="/jsp/SCError.jsp"%>

<%@ page import =   "javax.naming.*,
							java.sql.*,
							com.hoteltools.tbsupport.TBSupport,
							com.hoteltools.tbsupport.TBSupportHome,
							com.hoteltools.siteconfig.Device,
							com.hoteltools.siteconfig.DeviceHome,
							com.hoteltools.platform.util.LogOutput,
							com.hoteltools.platform.util.HTDatabase,
							com.hoteltools.platform.util.DatasourceConnectionException"
%>

<%
/*
 ********************************************************************
 * JSP Name:    SCSelection.jsp                                     *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%!
	private final String JNDI_NAME1 = "ejb.TBSupport";
	private final String JNDI_NAME2 = "ejb.Device";

	private Context ctx = new InitialContext();
	private Device dev = null;

	private LogOutput log = new LogOutput("SCSelection");

	private String err_message      = null;

	private String html_select      = null;
	private String html_devices     = null;
	private String html_info        = null;

	private String hidden_org_index = null;
	private String hidden_org_val   = null;
	private String hidden_org_text  = null;

	private String hidden_dev_index = null;
	private String hidden_dev_val   = null;

	private String hidden_mod		  = null;
	private String hidden_add		  = null;
	private String hidden_rem		  = null;
%>

<%
	
	boolean flag = false;
	
	try
	{
		selectOutput();
	
		hidden_org_index  = request.getParameter("hid_org_index");
		hidden_org_val    = request.getParameter("hid_org_val");
		hidden_org_text   = request.getParameter("hid_org_text");
		hidden_dev_index  = request.getParameter("hid_dev_index");
		hidden_dev_val    = request.getParameter("hid_dev_val");
		hidden_mod			= request.getParameter("hid_mod");
		hidden_add			= request.getParameter("hid_add");
		hidden_rem			= request.getParameter("hid_rem");
	
		System.out.println("hidden_org_index ="+hidden_org_index);
		System.out.println("hidden_org_val ="  +hidden_org_val);
		System.out.println("hidden_org_text ="  +hidden_org_text);
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
	
			try
			{
				dev.remove();
				ctx.close();
			}
			catch (Exception e)
			{
				log.debug("Exception:\n" + e);
				err_message = "There was a processing error.  Contact administrator.\n";
			}
	
			session.removeAttribute("dev");
			session.removeAttribute("ctx");
			session.removeAttribute("devices_list");
			session.removeAttribute("device");
			session.removeAttribute("org_id");
			session.removeAttribute("site");

			if (hidden_org_index.equals("0"))
			{
				System.out.println("org if");
	
				html_devices = null;
				html_info    = null;
			}
			else
			{
				System.out.println("org else");
	
				html_devices = showDevices(hidden_org_val);
				html_info    = null;
	
				session.setAttribute("devices_list", html_devices);
				session.setAttribute("org_id", hidden_org_val);
				session.setAttribute("site", hidden_org_text);
			}
		}
	
		// if devices selected
		if (request.getParameter("dev_selected") != null && request.getParameter("dev_selected").equals("truth"))
		{
			System.out.println("devices selected");

			session.removeAttribute("device");
	
			if (hidden_dev_index.equals("0"))
			{
				System.out.println("dev if");
	
				html_info = null;
			}
			else
			{
				System.out.println("dev else");
	
				html_devices = (String) session.getAttribute("devices_list");
	
				String org_id = (String) session.getAttribute("org_id");
	
				session.setAttribute("device", hidden_dev_val);
	
				System.out.println("hidden_dev_val ="+hidden_dev_val+", org_id = "+org_id);
	
				html_info = showInfo(hidden_dev_val, org_id);
			}
		}
	
		// if modify button submitted
		if (request.getParameter("hid_mod") != null && request.getParameter("hid_mod").equals("truth"))
		{
			System.out.println("hid_mod equals truth - Modify button clicked.");
			response.sendRedirect("/jsp/SCChoiceMod.jsp");
		}
	
		// if add button submitted
		if (request.getParameter("hid_add") != null && request.getParameter("hid_add").equals("truth"))
		{
			System.out.println("hid_add equals truth - Add button clicked.");
			response.sendRedirect("/jsp/SCChoiceAdd.jsp");
		}
	
		// if remove button submitted
		if (request.getParameter("hid_rem") != null && request.getParameter("hid_rem").equals("truth"))
		{
			System.out.println("hid_rem equals truth - Remove button clicked.");
			response.sendRedirect("/jsp/SCConfirm.jsp");
		}

		flag = true;
	}
	catch
	{
		try
		{
			dev.remove();
			ctx.close();
		}
		catch (Exception e)
		{
			log.debug("Exception:\n" + e);
			err_message = "There was a processing error.  Contact administrator.\n";
		}

		flag = false;
	}
	finally
	{
		log.debug("flag (service()) = " + flag);
	}
%>

<%!
private void selectOutput()
{
	/* this method loads organization choices into 
	   organization combo box */

	boolean flag = false;
	Context context = null;

	try
	{	  
		// get context
		context = new InitialContext();
  
		// get org ids for select tag
		TBSupportHome tbsHome = (TBSupportHome) context.lookup(JNDI_NAME1);
		TBSupport tbs = tbsHome.create();
		html_select = tbs.showOrg();
		flag = true;
		tbs.remove();
	}
	catch (Exception e)
	{
		// general exception (catches all exceptions not previously caught)
		log.debug("Exception:\n"+ e);
		err_message = "There was a processing error.  Contact system administrator.\n";
		flag = false;
	}
	finally
	{
		try
		{
			context.close();
		}
		catch (Exception e)
		{
			// a failure occurred closing context
			log.debug("Failed to close context.");
			err_message = "There was a processing error.  Contact administrator.\n";
			flag = false;
		}

		log.debug("flag (selectOutput()) = " + flag);
	}
}
%>

<%!
private String showDevices(String org)
{
	/* this method loads the devices into device combo box */

	boolean flag = false;
	String html  = null;

	try
	{	  
		// get org ids for select tag
		DeviceHome devhome = (DeviceHome) ctx.lookup(JNDI_NAME2);
		dev = devhome.create();
		html = dev.listDevices(org);
		flag = true;
	}
	catch (Exception e)
	{
		// general exception (catches all exceptions not previously caught)
		System.out.println("Exception:\n"+ e);
		err_message = "There was a processing error.  Contact system administrator.\n";
		flag = false;

		try
		{
			dev.remove();
			ctx.close();
		}
		catch (Exception ex)
		{
			log.debug("Exception:\n" + ex);
			err_message = "There was a processing error.  Contact administrator.\n";
		}
	}
	finally
	{
		log.debug("flag (showDevices()) = " + flag);
	}

	return html;
}
%>

<%!
private String showInfo(String device, String org)
{
	/* this method loads properties into table */

	boolean flag = false;
	String html  = null;

	try
	{	   
		html = dev.gatherInfo(device, org);
		session.setAttribute("dev", dev);
		session.setAttribute("ctx", ctx);
		flag = true;
	}
	catch (Exception e)
	{
		// general exception (catches all exceptions not previously caught)
		System.out.println("Exception:\n"+ e);
		err_message = "There was a processing error.  Contact system administrator.\n";
		flag = false;

		try
		{
			dev.remove();
			ctx.close();
		}
		catch (Exception ex)
		{
			log.debug("Exception:\n" + ex);
			err_message = "There was a processing error.  Contact administrator.\n";
		}
	}
	finally
	{
		log.debug("flag (showInfo()) = " + flag);
	}

	return html;
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
	 function validateModify()
	 {
		  if (document.formConfig.orgs.selectedIndex == 0)
		  {
				alert("An organization must be chosen.");
		  }

		  document.formConfig.hid_mod.value = "truth";
		  document.formConfig.hid_add.value = "falsehood";
		  document.formConfig.hid_rem.value = "falsehood";
	 }

	 function validateAdd()
	 {
		  if (document.formConfig.orgs.selectedIndex == 0)
		  {
				alert("An organization must be chosen.");
		  }

		  document.formConfig.hid_mod.value = "falsehood";
		  document.formConfig.hid_add.value = "truth";
		  document.formConfig.hid_rem.value = "falsehood";
	 }

	 function validateRemove()
	 {
		  if (document.formConfig.orgs.selectedIndex == 0)
		  {
				alert("An organization must be chosen.");
		  }

		  if (document.formConfig.devices.selectedIndex == 0)
		  {
				alert("A device must be chosen.");
		  }

		  document.formConfig.hid_mod.value = "falsehood";
		  document.formConfig.hid_add.value = "falsehood";
		  document.formConfig.hid_rem.value = "truth";
	 }

	 function showDevices()
	 {
			var index_org = document.formConfig.orgs.selectedIndex;
			var value_org = document.formConfig.orgs.options[index_org].value;
			var text_org  = document.formConfig.orgs.options[index_org].text;

			document.formConfig.hid_org_text.value  = text_org;
			document.formConfig.hid_org_index.value = index_org;
			document.formConfig.hid_org_val.value   = value_org;

			document.formConfig.org_selected.value  = "truth";
			document.formConfig.dev_selected.value  = "falsehood";

			document.formConfig.hid_mod.value = "falsehood";
			document.formConfig.hid_add.value = "falsehood";
			document.formConfig.hid_rem.value = "falsehood";

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

			document.formConfig.hid_mod.value = "falsehood";
			document.formConfig.hid_add.value = "falsehood";
			document.formConfig.hid_rem.value = "falsehood";
			
			document.formConfig.submit();
	 }

	 function loadValues()
	 {
		  document.formConfig.orgs.selectedIndex       = document.formConfig.hid_org_index.value;
		  document.formConfig.devices.selectedIndex    = document.formConfig.hid_dev_index.value;

		  if (document.formConfig.orgs.selectedIndex == 0)
		  {
				document.formConfig.devices.selectedIndex = 0;
		  }

		  document.formConfig.org_selected.value  = "falsehood";
		  document.formConfig.dev_selected.value  = "falsehood";

		  document.formConfig.hid_mod.value = "falsehood";
		  document.formConfig.hid_add.value = "falsehood";
		  document.formConfig.hid_rem.value = "falsehood";
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
<input type="hidden" name="hid_org_text" value="<%=hidden_org_text%>">

<input type="hidden" name="hid_dev_index" value="<%=hidden_dev_index%>">
<input type="hidden" name="hid_dev_val" value="<%=hidden_dev_val%>">

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





