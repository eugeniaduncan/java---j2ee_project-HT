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
 * JSP Name:    SCConfig.jsp                                        *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%!
	private final String JNDI_NAME = "ejb.Device";
	private String err_message     = null;

	private String html_device     = null;
	private String html_info       = null;
	private String site            = null;
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
		  document.formConfig.hid_mod.value = "truth";
		  document.formConfig.hid_add.value = "falsehood";
		  document.formConfig.hid_rem.value = "falsehood";
	 }

	 function validateAdd()
	 {
		  document.formConfig.hid_mod.value = "falsehood";
		  document.formConfig.hid_add.value = "truth";
		  document.formConfig.hid_rem.value = "falsehood";
	 }

	 function validateRemove()
	 {
		  document.formConfig.hid_mod.value = "falsehood";
		  document.formConfig.hid_add.value = "falsehood";
		  document.formConfig.hid_rem.value = "truth";
	 }

	 function showDevices()
	 {
			var index_org = document.formConfig.orgs.selectedIndex;
			var value_org = document.formConfig.orgs.options[index_org].value;

			document.formConfig.hid_org_index.value  = index_org;
			document.formConfig.hid_org_val.value    = value_org;

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
				document.formConfig.devices.selectedIndex    = 0;
		  }

		  document.formConfig.org_selected.value  = "falsehood";
		  document.formConfig.dev_selected.value  = "falsehood";

		  document.formConfig.hid_mod.value = "falsehood";
		  document.formConfig.hid_add.value = "falsehood";
		  document.formConfig.hid_rem.value = "falsehood";
	 }
	
	</script>
</head>
<body bgcolor="#000080" text="#ffffff">

<center>
	<h1><strong><font face="times">SITE CONFIGURATION SUMMARY PAGE</font></strong></h1><br>
	<h3><strong><font face="times" color="white"><%=site%></font></strong></h3>
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
<br>
<h2>Device:  <%=html_device%></h2>
<br>
<form name="formConfig" method="post" action="/jsp/SCConfig.jsp">

<%=html_info%>

<table width="60%" cols="2" border="5">	
	<tr align="center">
		<td align="center">
			Save Configuration:
			&nbsp;&nbsp;
			<button name="save" onclick="saveChoices();">Save</button>  
		</td>								
		<td align="center">
			Save &amp; Send to Toolbox:
			&nbsp;&nbsp;
			<button name="send" onclick="sendChoices();">Save &amp; Send</button>  
		</td>								
	</tr>
	<tr align="center">
		<td align="center">
			Configure Properties:
			&nbsp;&nbsp;
			<button name="next" onclick="configureChoices();">Next</button>  
		</td>								
		<td align="center">
			Go Back to Selection Page:
			&nbsp;&nbsp;
			<button name="abandon" onclick="abandonChoices();">Abandon</button>  
		</td>								
	</tr>
</table>	
</form>
</center>

</body>
</html>





