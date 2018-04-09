<%@ page contentType="text/html" errorPage="/jsp/TBError.jsp"%>

<%@ page import =   "javax.naming.Context,
							javax.naming.InitialContext,
							com.hoteltools.platform.util.LogOutput,
							com.hoteltools.tbsupport.TBSupport,
							com.hoteltools.tbsupport.TBSupportHome"
%>

<%
/*
 ********************************************************************
 * JSP Name:    TBSelection.jsp                                     *
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
	private String html_output_hist = null;
	private String html_output_stat = null;
	private String html_select = null;
	private LogOutput log = new LogOutput("TBSelection");
%>

<%
	/* call this method to load organization choices
	   into the organization combo box */
	selectOutput();

	// if user attempts to bypass login procedure to open this page, redirect back to login
	if (!((String) session.getAttribute("PageFrom")).equals("100"))
	{
		response.sendRedirect("/jsp/TBLogin.jsp");
	}

	// if user submits logout, redirect to logout page
	if (request.getParameter("loggout") != null)
	{
		session.removeAttribute("PageFrom");
		String page_from = "1000";
		session.setAttribute("PageFrom", page_from);
		response.sendRedirect("/jsp/TBLogout.jsp");					
	}

	// if user submits history, redirect to history page
	if (request.getParameter("history") != null)
	{
		// assign variables from form input
		String org1        = request.getParameter("orgs1");
		String connection  = request.getParameter("conn");
		String power       = request.getParameter("pwr");
		String shutdown    = request.getParameter("shdn");
		String pb_connect  = request.getParameter("pb_conn");
		String stat        = request.getParameter("status");
		String date1       = null;
		String date2       = null;
		String dates       = null;
		String orgs_text   = request.getParameter("org_text");

		session.setAttribute("site_info", orgs_text);


			if((request.getParameter("dates")).equals("interval_choice"))
			{
				date1  = request.getParameter("date1");
				date2  = request.getParameter("date2");
				dates  = "";
			}

			else
			{
				date1 = "";
				date2 = "";
				dates= request.getParameter("dates");
			}

			long ID     = 0L;

			err_message = "";

			try
			{
				ID = Long.parseLong(org1);
			}
			catch (NumberFormatException nfe)
			{
				log.debug("NumberFormatException: \n" + nfe.getMessage());
				throw nfe;
			} 

			processValues(ID, connection, power, shutdown, pb_connect, stat, dates, date1, date2);
			session.setAttribute("htmloutHistory", html_output_hist);
			session.removeAttribute("PageFrom");
			String page_from = "200";
			session.setAttribute("PageFrom", page_from);
			response.sendRedirect("/jsp/TBHistory.jsp");			 	
		
	}

	// if user submits status, redirect to status page
	if (request.getParameter("status") != null)
	{
		String org2 = request.getParameter("orgs2");
		session.removeAttribute("org_variable");
		session.setAttribute("org_variable", org2);
		session.removeAttribute("PageFrom");
		String page_from = "300";
		session.setAttribute("PageFrom", page_from);
		response.sendRedirect("/jsp/TBStatus.jsp");					
	}
%>

<%!
private void processValues(long i, String connection, String power, String shutdown, String pb_connection, 
									String stat, String dates, String date1, String date2)
{
	/* this method assigns html for the history page */

	boolean flag = false;
	Context ctx  = null;

	long org     = i;
	String con   = connection;
	String pow   = power;
	String sd    = shutdown;
	String pb    = pb_connection;
	String st    = stat;
	String d     = dates;
	String d1    = date1;
	String d2    = date2;

	try
	{				  
		// get context
		ctx = new InitialContext();
  
		// get html output
		TBSupportHome tbsHome = (TBSupportHome) ctx.lookup(JNDI_NAME);
		TBSupport tbs = tbsHome.create();
		html_output_hist = tbs.showHistory(org, con, pow, sd, pb, st, d, d1, d2);
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
			ctx.close();
		}
		catch (Exception e)
		{
			// a failure occurred closing context
			log.debug("Failed to close context.");
			err_message = "There was a processing error.  Contact administrator.\n";
			flag = false;
		}

		log.debug("flag (processValues()) = " + flag);
	}
}
%>

<%!
private void selectOutput()
{
	/* this method loads organization choices into 
	   organization combo box */

	boolean flag = false;
	Context ctx  = null;
	try
	{	  
		// get context
		ctx = new InitialContext();
  
		// get org ids for select tag
		TBSupportHome tbsHome = (TBSupportHome) ctx.lookup(JNDI_NAME);
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
			ctx.close();
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


<html>
<head>
	<style type="text/css">
	<!--
		#errorMsg{color:red;text-weight:bold;FONT:24pt;}
	-->
	</style>
	<title>Selection Page</title>
	<script language="javascript">

	 interval_dates = false;

	 function selectDate()
	 {
		  /* this function will check if time period combo box 
			  selection is where user inputs his own time interval */

		  if (document.formHistory.dates.value == "interval_choice") 
		  {
				document.all.chosen_dates.style.display = "";
				todaysdate = new Date();
				document.formHistory.date2.value = (todaysdate.getMonth()+1).toString()+"/"+(todaysdate.getDate()).toString()+"/"+(todaysdate.getYear()).toString();
				interval_dates = true;		  
		  } 
		  else
		  {
				document.all.chosen_dates.style.display = "none";
				interval_dates = false;
		  }
	 }

	 function checkDateFormat(strDate)
	 {
		  /* this function will check for a date that is in the format mm/dd/yyyy */
		  
		  var strDateArray;
		  var strDay;
		  var strMonth;
		  var strYear;
		  var intDay;
		  var intMonth;
		  var intYear;
		  var blnDateFound = false;
		  
		  /* Loop through the separator array, and find the one that is contained in
		  the strDate parameter.*/
		  
		  /* Get the month, day, and year.*/
		  if (strDate.indexOf("/") != -1) 
		  {
				strDateArray = strDate.split("/");

				if (strDateArray.length != 3) 
				{
					 return false;
				} 
				else 
				{
					 strMonth = strDateArray[0];
					 strDay = strDateArray[1];
					 strYear = strDateArray[2];
					 blnDateFound = true;
				}
		  }
		  
		  /* If no date was found yet, the entry is not a date.*/
		  if (!blnDateFound)
		  {
				return false;
		  }
		  
		  /* Verify that the month, day, and year are integers.*/
		  if (isInt(strMonth))
		  {
				intMonth = parseInt(strMonth,10);
		  }
		  else
		  {
				return false;
		  }
		  
		  if (isInt(strDay))
		  {
				intDay = parseInt(strDay,10);
		  }
		  else
		  {
				return false;
		  }
		  
		  if (isInt(strYear))
		  {
				intYear = parseInt(strYear,10);
		  }
		  else
		  {
				return false;
		  }
		  
		  /* Verify that the month is valid*/
		  if (intMonth < 1 || intMonth > 12)
		  {
				return false;
		  }
		  
		  /* Verify that the year is valid*/
		  if (intYear < 2000)
		  {
				return false;
		  }
		  
		  /* Verify that the day is valid*/
		  if ((intMonth==1 || intMonth==3 || intMonth==5 || intMonth==7 ||
		  intMonth==8 || intMonth==10 || intMonth==12) && (intDay < 1 || intDay > 31))
		  {
				return false;
		  }
		  else if ((intMonth==4 || intMonth==6 || intMonth==9 || intMonth==11) && (intDay < 1 || intDay > 30))
		  {
				return false;
		  }
		  else if (intMonth==2)
		  {
				if (intDay < 1)
				{
					 return false;
				}
				else if (isLeapYear(intYear))
				{
					 if (intDay > 29)
					 {
						  return false;
					 }
				}
				else
				{
					 if (intDay > 28)
					 {
						  return false;
					 }
				}
		  }
		  
		  /* Everything has passed.  The inputted string is a date.*/
		  return true;  
	 }

	 function isInt(strValue)
	 {
		  /* verify that the parameter inputted is an int*/
		  var intElement;
		  var intTemp;
		  
		  for (intElement=0; intElement<strValue.length; intElement++)
		  {
				intTemp = parseInt(strValue.charAt(intElement),10);

				if (isNaN(intTemp))
				{
					 return false;
				}
		  }
		  /* The parameter is an int*/
		  return true;
	 }

	 function isLeapYear(intYear)
	 {
		  /*If the inputted year is a leap year return true, otherwise return false*/
		  if (intYear % 100 == 0)
		  {
				if (intYear % 400 == 0)
				{
					 return true;
				} 
		  }
		  else if (intYear % 4 == 0)
		  {
				return true;
		  }
		  /* not a leap year*/
		  return false;
	 }

	 function validateHistory()
	 {
		  /* this function checks validity of all formHistory input,
		     and submits if validated or reloads if not validated */

		  var validity = true;
	 
		  // check if either of the combo boxes has no selection
		  if(document.formHistory.orgs1.value == "None")
		  {
				alert("An organization must be selected.");
				validity = false;
		  }

		  if(document.formHistory.conn.checked == false && document.formHistory.pwr.checked == false &&
			  document.formHistory.shdn.checked == false && document.formHistory.pb_conn.checked == false)
		  {
				alert("At least one checkbox must be selected must be selected.");
				validity = false;
		  }
		  
		  if(document.formHistory.dates.value == "None")
		  {
				alert("A date must be selected.");
				validity = false;
		  }
 	  
		  /* make the following checks only if the time period combo box 
			  selection is where user inputs his own time interval */
		  if(interval_dates == true)
		  {
				// check if interval dates are valid in length (8-10 characters)
				if(document.formHistory.date1.value.length > 10 || document.formHistory.date1.value.length < 8)
				{
					 alert("Incorrect date format for beginning date (wrong number of characters).");
					 validity = false;
				}
				
				if(document.formHistory.date2.value.length > 10 || document.formHistory.date2.value.length < 8)
				{
					 alert("Incorrect date format for ending date (wrong number of characters).");
					 validity = false;
				}
				// check if ending date is mistakenly earlier than beginning date
				if(new Date(document.formHistory.date2.value).getTime() < new Date(document.formHistory.date1.value).getTime())
				{
					 alert("Interval dates not in chronological order.");
					 validity = false;
				}
				// check if beginning date and ending date are mistakenly the same
				if(new Date(document.formHistory.date2.value).getTime() == new Date(document.formHistory.date1.value).getTime())
				{
					 alert("Interval dates cannot be the same.");
					 validity = false;
				}
				// finally, check if interval dates are valid using method checkDateFormat above
				if(!checkDateFormat(document.formHistory.date1.value))
				{
					 alert("Beginning date of date time interval is invalid.");
					 validity = false;
				}
				
				if(!checkDateFormat(document.formHistory.date2.value))
				{
					 alert("Ending date of date time interval is invalid.");
					 validity = false;
				}
		  }
		  
		  if(validity == true) 
		  {
				var sel = document.formHistory.orgs1.options.selectedIndex;
				document.formHistory.org_text.value = document.formHistory.orgs1.options[sel].text;
				document.formHistory.submit();
		  }
		  else location.reload();
	 }

	 function validateStatus()
	 {
		  /* this function checks validity of all formStatus input,
		     and submits if validated or reloads if not validated */

		  var validity = true;
	 
		  // check if the combo box has no selection
		  if(document.formStatus.orgs2.value == "None")
		  {
				alert("An organization must be selected.");
				validity = false;
		  }
		  
		  if(validity == true) document.formStatus.submit();
		  else location.reload();
	 }

	</script>
</head>
<body bgcolor="#000080" text="#ffffff">

<center>
	<h1><strong><font face="times">TOOLBOX SELECTION PAGE</font></strong></h1>
</center>

<center>
<span id="errorMsg">
<%=err_message%>
</span>
</center>

<center>
<table>
	<tr>
		<td>
		<form name="formHistory" method="post" action="/jsp/TBHistory.jsp">
		<input type="hidden" name="org_text" value="">
			<table border="1">
				<caption><strong>History</strong></caption>
				<tr>
					<td>
					<strong>Select organization:</strong><br>
						<select name="orgs1">
							<option selected value="None">Organization Here</option>
							<%=html_select%>
						</select>
					</td>
				</tr>
				<tr>
					<td><strong>Choose the issues to view: </strong><br>
						<!--//Create the checkboxes-->
						<input type="checkbox" name="conn" value="connection">
						<strong>Toolbox Connections</strong><br>
						<input type="checkbox" name="pwr" value="power">
						<strong>Toolbox Power</strong><br>
						<input type="checkbox" name="shdn" value="shutdown">
						<strong>Toolbox Shut Downs</strong><br>
						<input type="checkbox" name="pb_conn" value="pb_connection">
						<strong>Protocol Box Connections</strong><br>						
					</td>
				</tr>
				<tr>
					<td><strong>Select time period: </strong><br>
						<select name="dates" onchange="selectDate();">
							<option selected value="None">Time Period Here</option>
							<option value="365">Year-To-Date</option>
							<option value="182.5">6 mo-To-Date</option>
							<option value="91.25">3 mo-To-Date</option>
							<option value="(730/24)">Within last mo</option>
							<option value="14">Within last 2 wks</option>
							<option value="7">Within last wk</option>
							<option value="3">Within last 3 days</option>
							<option value="2">Within last 2 days</option>
							<option value="1">Within last 24 hours</option>
							<option value="(1/24)">Within last hour</option>
							<option value="(1/48)">Within last 30 mins</option>
							<option value="interval_choice">Select your own time interval.</option>
						</select>
						<br>
						<div id="chosen_dates" style="display:none;">
							<input type="text" name="date1" value="mm/dd/yyyy">
							&nbsp;to&nbsp;
							<input type="text" name="date2">
							<br>
						</div>
					</td>
				</tr>
				<!--//Submit Button--> <br>
				<tr>
					<td>
						<strong>Submit to see History:</strong>
						<button name="history" onclick="validateHistory();">History</button>
					</td>
				</tr>
			</table>
		</form>
		</td>
	</tr>
 
	<tr>
		<td>
			<form name="formStatus" method="post" action="/jsp/TBStatus.jsp">
			<center>
				<table border="1">
					<caption><strong>Status</strong></caption>
					<tr>
						<td>
						<strong>Select organization:</strong><br>
							<select name="orgs2">
								<option selected value="None">Organization Here</option>
								<option value="All">All listed organizations.</option>
								<%=html_select%>
							</select>
						</td>
					</tr>					
					<tr>
						<td>
							<strong>Submit to see Status:</strong>
							<button name="status" onclick="validateStatus();">Status</button>							
						</td>
					</tr>
				</table>
				</center>
			</form>
		</td>
	</tr>
</table>
</center>

<form name="formLogout" method="post" action="/jsp/TBLogout.jsp">
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





