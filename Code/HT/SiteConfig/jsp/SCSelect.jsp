<%@ page contentType="text/html" errorPage="/jsp/SCError.jsp"%>

<%@ page import =   "javax.naming.Context,
							javax.naming.InitialContext,
							com.hoteltools.tbsupport.OrgID,
							com.hoteltools.tbsupport.OrgIDHome,
							java.sql.Connection,
							java.sql.Statement,
							java.sql.ResultSet,
							java.sql.SQLException,
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
	private final String JNDI_NAME1     = "ejb.OrgID";
	private String err_message          = null;
	private String html_select          = null;
	private String html_devices         = null;
	private String html_device_descr    = "Device descriptions...";
	private String html_prop_names      = null;
	private String html_prop_name_descr = "Property name descriptions...";
	private String html_info            = null;
	private String hidden_table_output  = null;
	private String hidden_org_index     = null;
	private String hidden_org_val       = null;
	private String hidden_dev_index     = null;
	private String hidden_dev_val       = null;
	private String hidden_prop_index    = null;
	private String hidden_prop_val      = null;
	private String hidden_config			= null;

	private HashMap prop_map = null;
	private List prop_list   = null;
	private Set dev_set      = null;
%>

<%
	selectOutput();

	hidden_org_index  = request.getParameter("hid_org_index");
	hidden_org_val    = request.getParameter("hid_org_val");
	hidden_dev_index  = request.getParameter("hid_dev_index");
	hidden_dev_val    = request.getParameter("hid_dev_val");
	hidden_prop_index = request.getParameter("hid_prop_index");
	hidden_prop_val   = request.getParameter("hid_prop_val");

	System.out.println("hidden_org_index ="+hidden_org_index);
	System.out.println("hidden_org_val ="+hidden_org_val);
	System.out.println("hidden_dev_index ="+hidden_dev_index);
	System.out.println("hidden_dev_val ="+hidden_dev_val);
	System.out.println("hidden_prop_index ="+hidden_prop_index);
	System.out.println("hidden_prop_val ="+hidden_prop_val);
	System.out.println("\nhtml_device_descr ="+html_device_descr);
	System.out.println("\nhtml_prop_name_descr ="+html_prop_name_descr+"\n");

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
	// if configure button not submitted
	if (request.getParameter("hid_config") != null && request.getParameter("hid_config").equals("falsehood"))
	{
		System.out.println("hid_config equals falsehood - Config button NOT clicked.");

		// if org selected
		if (request.getParameter("org_selected") != null && request.getParameter("org_selected").equals("truth"))
		{
			System.out.println("org selected");

			if (hidden_org_index.equals("0"))
			{
				System.out.println("org if");

				html_devices         = null;
				html_info            = null;
				hidden_table_output  = "No";
			}
			else
			{
				System.out.println("org else");

				session.removeAttribute("devices_list");
				session.removeAttribute("org_id");
			
				html_devices = findDevices(hidden_org_val);
				session.setAttribute("devices_list", html_devices);
				session.setAttribute("org_id", hidden_org_val);
	
			}
		}
		// if devices selected
		else if (request.getParameter("dev_selected") != null && request.getParameter("dev_selected").equals("truth"))
		{
			System.out.println("devices selected");

			if (hidden_dev_index.equals("0"))
			{
				System.out.println("dev if");

				html_info            = null;
				hidden_table_output  = "No";
			}
			else
			{
				System.out.println("dev else");

				session.removeAttribute("prop_names_list");
	
				html_devices        = (String) session.getAttribute("devices_list");

				String org_id       = (String) session.getAttribute("org_id");

				html_info           = findInfo(hidden_dev_val, org_id);
				
				hidden_table_output = "Yes";
			}
		}
		else
		{
			System.out.println("Neither org nor devices selected.");
		}
	}
	// if configure button submitted
	else if (request.getParameter("hid_config") != null && request.getParameter("hid_config").equals("truth"))
	{
		System.out.println("hid_config equals truth - Config button clicked.");
		response.sendRedirect("/jsp/SCConfig.jsp");
	}
	else
	{
		System.out.println("hid_config set to falsehood");
		hidden_config = "falsehood";
		hidden_table_output  = "No";
	}
%>

<%!
private String findDevices(String org)
{
	String org_id      = org;
	boolean flag       = false;
	Connection connect = null;
	String html_out    = null;
	StringBuffer html  = new StringBuffer(500);
	String state       = null;
	String res         = null;

	try
	{
		// Attempt to retrieve a database connection (toolPool).
		if (connect == null)
		{
			String connString = "weblogic.jdbc.jts.toolPool";

			try
			{  
				connect = HTDatabase.getConnection(true, connString);
			} 
			catch (DatasourceConnectionException dsce)
			{
				throw new SQLException("Datasource Connection Exception experienced:" + dsce.getMessage());
			}
			catch (Exception exc)
			{
				throw exc;
			}
		}

		Statement statement = connect.createStatement();

		state =  "SELECT DEVICE_LIST.DEVICE_NAME FROM DEVICE_LIST, SITE_CONFIG " + 
					"WHERE SITE_CONFIG.ORGANIZATION_ID = " + org_id +"AND DEVICE_LIST.DEVICE_ID = " + 
					"SITE_CONFIG.DEVICE_ID ORDER BY SITE_CONFIG.DEVICE_ID";

		ResultSet results = statement.executeQuery(state);

		dev_set = new HashSet();

		while(results.next())
		{
			res = results.getString(1);
			dev_set.add(res);
		}

		Iterator i = dev_set.iterator();

		while(i.hasNext())
		{
			html.append("<option>"+ i.next() +"</option>");
		}

		html_out = html.toString();

		flag = true;

	}
	catch (Exception e)
	{
		System.out.println("Exception: "+ e);

		flag = false;
	}
	finally
	{
		try
		{
			//close the connections
			connect.close();
			connect = null;
		}
		catch (Exception excon)
		{
			//Possible NullPointerException.
			System.out.println("Exception:\n" + excon);
			html_out = "<option>Database not appropriately responding at this time.</option>";
			flag = false;
		}

		System.out.println("flag = " + flag);
	}

	return html_out;

}
%>

<%!
private String findInfo(String dev, String org)
{
	String device      = dev;
	String org_id      = org;
	boolean flag       = false;
	Connection connect = null;
	String html_out    = null;
	StringBuffer html  = new StringBuffer(500);
	String state       = null;
	String res         = null;

	try
	{
		// Attempt to retrieve a database connection (toolPool).
		if (connect == null)
		{
			String connString = "weblogic.jdbc.jts.toolPool";

			try
			{  
				connect = HTDatabase.getConnection(true, connString);
			} 
			catch (DatasourceConnectionException dsce)
			{
				throw new SQLException("Datasource Connection Exception experienced:" + dsce.getMessage());
			}
			catch (Exception exc)
			{
				throw exc;
			}
		}

		Statement statement = connect.createStatement();

		state =  "SELECT DEVICE_LIST.DEVICE_NAME FROM DEVICE_LIST, SITE_CONFIG " + 
					"WHERE SITE_CONFIG.ORGANIZATION_ID = " + org_id +"AND DEVICE_LIST.DEVICE_ID = " + 
					"SITE_CONFIG.DEVICE_ID ORDER BY SITE_CONFIG.DEVICE_ID";

		ResultSet results = statement.executeQuery(state);

		Set set = new HashSet();

		while(results.next())
		{
			res = results.getString(1);
			set.add(res);
		}

		Iterator i = set.iterator();

		while(i.hasNext())
		{
			html.append("<option>"+ i.next() +"</option>");
		}

		html_out = html.toString();

		flag = true;

	}
	catch (Exception e)
	{
		System.out.println("Exception: "+ e);

		flag = false;
	}
	finally
	{
		try
		{
			//close the connections
			connect.close();
			connect = null;
		}
		catch (Exception excon)
		{
			//Possible NullPointerException.
			System.out.println("Exception:\n" + excon);
			html_out = "<option>Database not appropriately responding at this time.</option>";
			flag = false;
		}

		System.out.println("flag = " + flag);
	}

	return html_out;

}
%>

<%
private Hashmap getProp_Map()
{
	return prop_map;
}
%>

<%
private List getProp_List()
{
	return prop_list;
}
%>

<%
private Set getProp_Set()
{
	return prop_set;
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
	 
	 function validateConfig()
	 {
		  var validity = true;

		  document.formConfig.hid_config.value = "truth";

		  if (document.formConfig.orgs.selectedIndex == 0)
		  {
				alert("An organization must be selected.");
				validity = false;
		  }

		  if (validity == true) document.formConfig.submit();
		  else location.reload();
	 }

	 function findDevices()
	 {
			var index_org = document.formConfig.orgs.selectedIndex;
			var value_org = document.formConfig.orgs.options[index_org].value;

			document.formConfig.hid_org_index.value  = index_org;
			document.formConfig.hid_org_val.value    = value_org;

			document.formConfig.org_selected.value  = "truth";
			document.formConfig.dev_selected.value  = "falsehood";
			document.formConfig.prop_selected.value = "falsehood";

			document.formConfig.hid_config.value = "falsehood";

			document.formConfig.submit();
	 }

	 function findDevDescr()
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
			document.formConfig.prop_selected.value = "falsehood";

			document.formConfig.hid_config.value = "falsehood";

			document.formConfig.submit();
	 }

	 function findPropDescr()
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
			document.formConfig.dev_selected.value  = "falsehood";
			document.formConfig.prop_selected.value = "truth";

			document.formConfig.hid_config.value = "falsehood";

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
		  document.formConfig.prop_selected.value = "falsehood";

		  document.formConfig.hid_config.value = "falsehood";
	 }
	
	</script>
</head>
<body bgcolor="#000080" text="#ffffff" onload="loadValues();">

<center>
	<h1><strong><font face="times">SITE CONFIGURATION SELECTION PAGE</font></strong></h1>
</center>

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
<input type="hidden" name="hid_prop_index" value="<%=hidden_prop_index%>">
<input type="hidden" name="hid_prop_val" value="<%=hidden_prop_val%>">
<input type="hidden" name="hid_table_out" value="<%=hidden_table_output%>">
<input type="hidden" name="hid_config" value="<%=hidden_config%>">
<input type="hidden" name="org_selected">
<input type="hidden" name="dev_selected">
<input type="hidden" name="prop_selected">
<table width="60%" cols="1" border="5">
 <caption><h3>Device Configuration</h3></caption>
	
				<tr>
					<td align="center" colspan="2">
					(1st step)&nbsp;&nbsp;
					<strong>Select organization:</strong>
						<select name="orgs" onchange="findDevices();">
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
								<select name="devices" size="6" onchange="findDevDescr();">
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
									<button name="add_device" onclick="validateAdd();">Add Device</button>  
								&nbsp;&nbsp;
									<button name="remove_device" onclick="validateRemove();">Remove Device</button>  
								</td>								
							</tr>
						</table>
					</td>
				</tr>
				
				<div id="info" style="display:none;">
				<tr>
					<td>
						<table>
							<%=html_info%>
						</table>
					</td>
				</tr>
				</div>
				
								
				<!--//Submit Button-->
			
				<tr>
					<td align="center" colspan="2">
						<strong>Submit to configure device:</strong>
						<button name="config_device" onclick="validateConfig();">Configure Device</button>
					</td>
				</tr>
		  
</table>
</form>
</center>

<form name="formLogout" method="post" action="/jsp/SCSelection.jsp">
	<center>
		<table>
			<tr>
				<td>
					<input type="submit" name="loggout" value="Logout">
				</td>
			</tr>
		</table>
	</center>
</form>

</body>
</html>





