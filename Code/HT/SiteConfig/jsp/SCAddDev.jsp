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
 * JSP Name:    SCAddDev.jsp                                        *
 * Author:      Eugenia Duncan                                      *
 * Parameters:                                                      *
 * Description:                                                     *
 *                                                                  *
 ********************************************************************
*/
%>

<%!
	private LogOutput log = new LogOutput("SCAddDev");
	private String err_message     = null;

	private String html_devices    = null;
	private String site            = null;

	private String hidden_dev_val   = null;
%>

<%
	site = (String) session.getAttribute("site");

	if (request.getParameter("dev_selected") != null && request.getParameter("dev_selected").equals("truth"))
	{
		System.out.println("device selected");

		session.removeAttribute("device_to_add");
	  
		session.setAttribute("device_to_add", hidden_dev_val);

		System.out.println("hidden_dev_val (added device) = "+hidden_dev_val);

		response.sendRedirect("/jsp/SCChoiceAdd.jsp");
		
	}

	if (request.getParameter("abandon") != null)
	{
		System.out.println("abandon AddDev");

		response.sendRedirect("/jsp/SCSelection.jsp");
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
	 function validate()
	 {
		  if (document.formAddDevice.devices.selectedIndex == 0)
		  {
				alert("A device must be chosen.");
		  }
	 }

	 function showDevicesList()
	 {
			var index_dev = document.formAddDevice.devices.selectedIndex;
			var value_dev = document.formAddDevice.devices.options[index_dev].text;

			document.formAddDevice.hid_dev_index.value = index_dev;
			document.formAddDevice.hid_dev_val.value   = value_dev;

			document.formAddDevice.dev_selected.value  = "truth";

			document.formAddDevice.submit();
	 }

	 function loadValues()
	 {
		  document.formAddDevice.dev_selected.value  = "falsehood";
	 }
	
	</script>
</head>
<body bgcolor="#000080" text="#ffffff">

<center>
	<h1><strong><font face="times">SITE CONFIGURATION ADD DEVICE PAGE</font></strong></h1><br>
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
<form name="formAddDevice" method="post" action="/jsp/SCAddDev.jsp">
<input type="hidden" name="hid_dev_val" value="<%=hidden_dev_val%>">
<input type="hidden" name="dev_selected">

<table width="60%" height="60%" border="10">

				<tr align="center">
					<td align="center"> 			
						<h2>Choose device to be added:</h2>  			
					</td>
				</tr>
				
				<tr align="center">
					<td align="center">
							<br>
							<center>
								<select name="devices" size="8" onchange="showDeviceList();">
									<option selected value="None">Devices:
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</option>
																		
									<%=html_devices%>
								
								</select>
							</center>
							<br>
					</td>
				</tr>
							
				<tr align="center">
					<td align="center">
						Go Back to Selection Page:  
						&nbsp;&nbsp;
						<button name="abandon" onclick="abandonChoice();">Abandon</button>  
					</td>								
				</tr>
</table>
</form>
</center>

</body>
</html>





