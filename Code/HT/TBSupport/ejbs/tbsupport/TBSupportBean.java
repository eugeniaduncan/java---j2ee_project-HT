package com.hoteltools.tbsupport;

import javax.ejb.*;
import java.rmi.*;
import java.util.*;
import java.sql.*;
import java.text.*;
import com.hoteltools.impl.TableBuilder;
import com.hoteltools.platform.util.HTDatabase;
import com.hoteltools.platform.util.DatasourceConnectionException;
import com.hoteltools.platform.util.LogOutput;

/** 
 * TBSupportBean class
 * @author Eugenia Duncan
 */

public class TBSupportBean implements SessionBean 
{
	private SessionContext ctx = null;

	private LogOutput log = new LogOutput("TBSupportBean");
	
	public TBSupportBean()
	{
	}
	
	// Business logic methods.

	public boolean isAuthentic(String usnm, String pswd) throws RemoteException
	{
		boolean flag            = false;
		Connection connection   = null;

		String username         = usnm;
		String password         = pswd;
		String result_name      = "";
		String result_password  = "";
		boolean username_flag   = false;
		boolean password_flag   = false;

		try
		{
			//try to make a database connection
			try
			{
				connection = HTDatabase.getConnection();
			}
			catch (DatasourceConnectionException dsce)
			{
				throw new SQLException("Datasource Connection Exception experienced:\n" + dsce.getMessage());
			}

			//get the userNames and passwords from the tables
			Statement statement = connection.createStatement();
			ResultSet result_user = statement.executeQuery("select USER_NAME, USER_SECURED_PASSWORD from SYSTEM_USER" );

			//if there is no result set in the database, throw an exception
			if (result_user == null)
			{
				throw new Exception("ResultSet not found.");
			}

			//if there is a result set in the database (or multiple) run through the result set
			// and test for the matching password
			while (result_user.next())
			{
				result_name = result_user.getString(1);

				if (result_name.equals(username))
				{
					username_flag = true;
					result_password = result_user.getString(2);

					if (result_password.equals(password))
					{
						password_flag = true;
					}
				}
			}

			//If the userID does not exist or the password does not match the found userID,
			//throw an exception
			if (username_flag == true && password_flag == true)
			{
				flag = true;
			}
			else 
				if (username_flag == false)
				{
					flag = false;
					log.debug("Username not found for " + username + ".");
				}
				else
				{
					flag = false;
					log.debug("Password does not match password for " + username + ".");
				}
		
		}
		catch (Exception e)
		{
			log.debug("Exception:\n" + e);
			flag = false;
		}
		finally
		{
			try
			{
				//close the connection
				connection.close();
				connection = null;
			}
			catch (Exception con)
			{
				log.debug("Exception:\n" + con);
				flag = false;
			}

			log.debug("flag (isAuthentic()) = " + flag);

		}

		return flag;
	}

	
	public String showHistory(long org_ID, String connection, String power,
								     String shutdown, String pb_connection, String status,
								     String dates, String date1, String date2)
								     throws RemoteException	
	{  
		boolean flag = false;
		Connection connect = null;
		
		long org_id    = org_ID;
		String conn    = connection;
		String pow     = power;
		String sd      = shutdown;
		String pb		= pb_connection;
		String stat    = status;
		String dts   	= dates;
		String dt1	   = date1;
		String dt2  	= date2;

		String time_period = null;
		
		String clause = null;
		String prob_cat = "";
		long fail = 0L;
	
		StringBuffer html = new StringBuffer(750);
		String html_output = null;

		String insert1 = null;
		Timestamp assignment1 = null;

		String insert2 = null;
		Timestamp assignment2 = null;
		
		String insert3 = null;
		String assignment3 = null;

		DateFormat df1 = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.FULL);
		
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

			// Get the dates
			if (dts.equals("")) time_period = " and DATE_OPENED between to_date(\'" + dt1 + "\',\'mm/dd/yyyy\') AND to_date(\'" + dt2 + "\',\'mm/dd/yyyy\')";
		
			else if (!dts.equals("")) time_period = " and DATE_OPENED > sysdate - " + dts + "";
		
			else time_period = "";
			
			Statement statement = connect.createStatement();
			
			// Create a list with all the problem issues the user is looking for
			List ref_code = new ArrayList(); 
			
			if (conn != null)
			{
				ref_code.add("0");
				ref_code.add("1");
				ref_code.add("2");
				ref_code.add("6");
			}
			
			if (pow != null)
			{
				ref_code.add("3");
				ref_code.add("4");
				ref_code.add("5");
			}
	
			if (sd != null)
			{
				ref_code.add("7");
				ref_code.add("8");
			}
	
			if (pb != null)
			{
				ref_code.add("9");
				ref_code.add("10");
			}

			// Build the headers for the display table
			html.append("<tr>");
			html.append("<th><center>DATE LOGGED</center></th>");
			html.append("<th><center>DATE OCCURED</center></th>");
			html.append("<th><center>REASON</center></th>");
			html.append("</tr>");  	
	
			// Execute the SQL statement to get the organizations Failure Mode ID
			ResultSet results1 = statement.executeQuery("select FAIL_MODE_ID from FAILURE_API_JOURNAL " +
																	  "where ORGANIZATION_ID =" + org_id);
						
			while (results1.next())
			{
				
				fail = results1.getLong(1);

				if (ref_code.size() > 0)
				{
					prob_cat = "(PROBLEM_CATEGORY = " + ref_code.get(0);
					
					// For each problem issue in the List above, select all the tickets for that code
					for ( int counter = 1; counter < ref_code.size(); counter ++)
					{
						prob_cat += " or PROBLEM_CATEGORY = " + ref_code.get(counter);
					}
	
					prob_cat += ") ";
	
					clause = "select DATE_OPENED, DATE_OCCURED, REASON from ROOT_CAUSE_ANALYSIS "+ 
								"where " + prob_cat +
								"and FAIL_MODE_ID = " + fail +" "+ time_period +" "+
								"order by DATE_OCCURED";
				}
				else
				{
					html_output = "No data in database for chosen categories.";
					return html_output;
				}
				
				ResultSet results2 = statement.executeQuery(clause);
				
				while (results2.next())
				{
					// Display each ticket as a row in the table
					html.append("<tr>");

					// Column 1
					assignment1 = results2.getTimestamp(1);

					if (results2.wasNull())
					{
						insert1 = "&nbsp;";
						html.append("<td><center>" + insert1 + "</center></td>");
					}
					else
					{
						insert1 = df1.format(assignment1);
						html.append("<td><center>" + insert1 + "</center></td>");
					}

					// Column 2
					assignment2 = results2.getTimestamp(2);

					if (results2.wasNull())
					{
						insert2 = "&nbsp;";
						html.append("<td><center>" + insert2 + "</center></td>");
					}
					else
					{
						insert2 = df1.format(assignment2);
						html.append("<td><center>" + insert2 + "</center></td>");
					}

					// Column 3
					assignment3 = results2.getString(3);

					if (results2.wasNull())
					{
						insert3 = "&nbsp;";
						html.append("<td>" + insert3 + "</td>");
					}
					else
					{
						insert3 = assignment3;
						html.append("<td>" + insert3 + "</td>");
					}

					html.append("</tr>");
				
				}					
			}
	
			html_output = html.toString();
			flag = true;
			
		}
		catch (Exception e)
		{
			log.debug("Exception:\n" + e);
			html_output = "<tr><center><font color=\"white\">" +
				"Program Error.\nContact administrator.</font></center></tr>";
			flag = false;
		}
		finally
		{
			try
			{
				// Close the connection
				connect.close();
				connect = null;
			}
			catch (Exception excon)
			{
				// Possible NullPointerException.
				log.debug("Exception:\n" + excon);
				html_output = "<tr><center><font color=\"white\">" +
					"Program Error.\nContact administrator.</font></center></tr>";
				flag = false;
			}
	
			log.debug("flag (showHistory()) = " + flag);
		}
	
		return html_output;
	}


	public String showOrg() throws RemoteException	
	{  
		boolean flag = false;
		Connection connect = null;
	
		StringBuffer html = new StringBuffer(750);
		String html_output = null;
		
		try
		{
			// Attempt to retrieve a database connection (hotelPool).
			if (connect == null)
			{
				String connString = "weblogic.jdbc.jts.hotelPool";
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
	
			String state = "select ORGANIZATION_ID, DESCRIPTION from HTCRM_ORGANIZATION_MASTER order by ORGANIZATION_ID";   

			ResultSet results = statement.executeQuery(state);

			while (results.next())
			{
				long orgid = results.getLong(1);
				String descr = results.getString(2);

				html.append("<option value = \"" + orgid + "\">" + descr + " - " + orgid + "</option>");
			}

			html_output = html.toString();
			flag = true;
			
		}
		catch (Exception e)
		{
			log.debug("Exception:\n" + e);
			html_output = "<tr><center>Database not appropriately responding at this time.</center></tr>";
			flag = false;
		}
		finally
		{
			try
			{
				//close the connection
				connect.close();
				connect = null;
			}
			catch (Exception excon)
			{
				//Possible NullPointerException.
				log.debug("Exception:\n" + excon);
				html_output = "<tr><center>Database not appropriately responding at this time.</center></tr>";
				flag = false;
			}
	
			log.debug("flag (showOrg()) = " + flag);
		}
	
		return html_output;
	}


	public String showStatus() throws RemoteException	
	{  
		boolean flag       = false;
		Connection connect = null;
		String html_output = null;
		String state       = null;
		DateFormat df1 = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.FULL);
		
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

			TableBuilder tb = new TableBuilder();

			Statement statement = connect.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			
			state =  "SELECT HTCRM_ORGANIZATION_MASTER_SYN.DESCRIPTION, TB_STATUS.ORGANIZATION_ID, TB_STATUS.STATUS_KEY, TB_STATUS.VALUE, FAILURE_API_JOURNAL.LAST_HEARTBEAT"
					  +" FROM HTCRM_ORGANIZATION_MASTER_SYN, TB_STATUS, FAILURE_API_JOURNAL"
					  +" WHERE HTCRM_ORGANIZATION_MASTER_SYN.ORGANIZATION_ID = TB_STATUS.ORGANIZATION_ID AND FAILURE_API_JOURNAL.ORGANIZATION_ID = TB_STATUS.ORGANIZATION_ID"
					  +" ORDER BY TB_STATUS.ORGANIZATION_ID";

			ResultSet results = statement.executeQuery(state);

			tb.createRow();
			tb.addColumnHeader("Organization Name");
			tb.addColumnHeader("Site Id");
			tb.addColumnHeader("Toolbox Connection");
			tb.addColumnHeader("Toolbox Power");
			tb.addColumnHeader("Toolbox Running?");
			tb.addColumnHeader("Last Heartbeat");
			tb.addColumnHeader("Protocol Box");
			
			while (results.next())
			{
				String hdr = results.getString(3);
				tb.addColumnHeader(hdr);
			}

			results.beforeFirst();

			if (results.isBeforeFirst())
			{
				long curOrg        = 0L;
				String descr       = null;
				long org_id        = 0L;
				String org_id_hdr  = null;
				String val         = null;
				String value       = null;
				String heart       = null;
				String heart_added = null;
				Timestamp heartbeat     = null;

				//Set up time comparison variables
				//If heartbeat has not occurred within the last 15 minutes, it will highlight red.
				Calendar now = Calendar.getInstance();
				now.add(Calendar.MINUTE, -15);
				java.util.Date fifteen_min_ago = now.getTime();

				while (results.next())
				{
					descr      = results.getString(1);
					if (results.wasNull()) descr = "&nbsp;";

					org_id     = results.getLong(2);
					if (results.wasNull()) org_id = 00000L;

					org_id_hdr = results.getString(3);
					if (results.wasNull()) org_id_hdr = "&nbsp;";

					val        = results.getString(4);
					if (results.wasNull()) val = "&nbsp;";

					heartbeat  = results.getTimestamp(5);
					if (results.wasNull()) heart_added = "&nbsp;";
					else
					{
						heart = df1.format(heartbeat);

						if(fifteen_min_ago.after(heartbeat))
							heart_added = "<strong><font color=\"red\">"+heart+"</font></strong>";
						else
							heart_added = heart;
					}
						
					if (!(org_id == curOrg))
					{
						tb.createRow();
						curOrg = org_id;
						tb.addField("Organization Name", descr);
						tb.addField("Site Id", String.valueOf(org_id));
						tb.addField("Last Heartbeat", heart_added);
					}
					if (org_id_hdr.equals("Toolbox Connection") || org_id_hdr.equals("Toolbox Power")
						|| org_id_hdr.equals("Toolbox Running?") || org_id_hdr.equals("Protocol Box"))
					{
						if ((org_id_hdr.equals("Toolbox Connection")) && (!val.equals("Primary")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Toolbox Power")) && (!val.equals("On")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Toolbox Running?")) && (!val.equals("Yes")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Protocol Box")) && (!val.equals("Connected")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else
						{
							tb.addField(org_id_hdr, val);
						}
					}
					else if(org_id_hdr.trim().length() >= 9 && org_id_hdr.trim().startsWith("PB Device"))
					{
						if (org_id_hdr.trim().substring(0,9).equals("PB Device") && (!val.equals("Connected")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else
							tb.addField(org_id_hdr, val);
					}
					else
					{
						tb.addField(org_id_hdr, val);
					}
				}

				html_output = tb.buildTable();
			}
			else html_output = "<tr><center><font color=\"white\">" +
				"Site chosen not found in database.</font></center></tr>";

			flag = true;  
		}
		catch (Exception e)
		{
			log.debug("Exception:\n" + e);
			html_output = "<tr><center><font color=\"white\">" +
				"Database not appropriately responding at this time.\n" +
				"Program Error.\nContact administrator.</font></center></tr>";
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
				log.debug("Exception:\n" + excon);
				html_output = "<tr><center><font color=\"white\">" +
					"Program Error.\nContact administrator.</font></center></tr>";
				flag = false;
			}
	
			log.debug("flag (showStatus()) = " + flag);
		}
	
		return html_output;
	}

	
	// overloaded method
	public String showStatus(long orgs) throws RemoteException	
	{  
		boolean flag       = false;
		Connection connect = null;
		String html_output = null;
		String state       = null;
		long org           = orgs;
		DateFormat df1 = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.FULL);
		
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

			TableBuilder tb = new TableBuilder();

			Statement statement = connect.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			
			state =  " SELECT HTCRM_ORGANIZATION_MASTER_SYN.DESCRIPTION, TB_STATUS.ORGANIZATION_ID, TB_STATUS.STATUS_KEY, TB_STATUS.VALUE, FAILURE_API_JOURNAL.LAST_HEARTBEAT"
					  +" FROM HTCRM_ORGANIZATION_MASTER_SYN, TB_STATUS, FAILURE_API_JOURNAL"
					  +" WHERE TB_STATUS.ORGANIZATION_ID = " + org + " AND HTCRM_ORGANIZATION_MASTER_SYN.ORGANIZATION_ID = " + org + " AND FAILURE_API_JOURNAL.ORGANIZATION_ID = " + org;

			ResultSet results = statement.executeQuery(state);

			tb.createRow();
			tb.addColumnHeader("Organization Name");
			tb.addColumnHeader("Site Id");
			tb.addColumnHeader("Toolbox Connection");
			tb.addColumnHeader("Toolbox Power");
			tb.addColumnHeader("Toolbox Running?");
			tb.addColumnHeader("Last Heartbeat");
			tb.addColumnHeader("Protocol Box");

			while (results.next())
			{
				String hdr = results.getString(3);
				tb.addColumnHeader(hdr);
			}

			results.beforeFirst();

			if (results.isBeforeFirst())
			{
				String descr       = null;
				long org_id        = 0L;
				String heart       = null;
				String heart_added = null;
				Timestamp heartbeat     = null;
				String org_id_hdr  = null;
				String val         = null;
				String value       = null;

				//Set up time comparison variables
				//If heartbeat has not occurred within the last 15 minutes, it will highlight red.
				Calendar now = Calendar.getInstance();
				now.add(Calendar.MINUTE, -15);
				java.util.Date fifteen_min_ago = now.getTime();

				tb.createRow();

				while (results.next())
				{
					descr      = results.getString(1);
					if (results.wasNull()) descr = "&nbsp;";

					org_id     = results.getLong(2);
					if (results.wasNull()) org_id = 00000L;

					org_id_hdr = results.getString(3);
					if (results.wasNull()) org_id_hdr = "&nbsp;";

					val        = results.getString(4);
					if (results.wasNull()) val = "&nbsp;";

					heartbeat  = results.getTimestamp(5);
					if (results.wasNull()) heart_added = "&nbsp;";
					else
					{
						heart = df1.format(heartbeat);

						if(fifteen_min_ago.after(heartbeat))
							heart_added = "<strong><font color=\"red\">"+heart+"</font></strong>";
						else
							heart_added = heart;
					}

					tb.addField("Organization Name", descr);
					tb.addField("Site Id", String.valueOf(org_id));
					tb.addField("Last Heartbeat", heart_added);
					
					if (org_id_hdr.equals("Toolbox Connection") || org_id_hdr.equals("Toolbox Power")
						|| org_id_hdr.equals("Toolbox Running?") || org_id_hdr.equals("Protocol Box"))
					{
						if ((org_id_hdr.equals("Toolbox Connection")) && (!val.equals("Primary")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Toolbox Power")) && (!val.equals("On")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Toolbox Running?")) && (!val.equals("Yes")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Protocol Box")) && (!val.equals("Connected")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else
						{
							tb.addField(org_id_hdr, val);
						}
					}
					else if(org_id_hdr.trim().length() >= 9 && org_id_hdr.trim().startsWith("PB Device"))
					{
						if (org_id_hdr.trim().substring(0,9).equals("PB Device") && (!val.equals("Connected")))
						{
							value = "<strong><font color=\"red\">"+val+"</font></strong>";
							tb.addField(org_id_hdr, value);
						}
						else
							tb.addField(org_id_hdr, val);
					}
					else
					{
						tb.addField(org_id_hdr, val);
					}
				}

				html_output = tb.buildTable();
			}
			else html_output = "<tr><center><font color=\"white\">" +
				"Site chosen not found in database.</font></center></tr>";

			flag = true;  
		}
		catch (Exception e)
		{
			log.debug("Exception:\n" + e);
			html_output = "<tr><center><font color=\"white\">" +
				"Database not appropriately responding at this time.\n" +
				"Program Error.\nContact administrator.</font></center></tr>";
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
				log.debug("Exception:\n" + excon);
				html_output = "<tr><center><font color=\"white\">" +
					"Program Error.\nContact administrator.</font></center></tr>";
				flag = false;
			}
	
			log.debug("flag (showStatus(orgs)) = " + flag);
		}
	
		return html_output;
	}
	  
	
	// EJB-required container methods.
	
	public void ejbCreate() throws CreateException, RemoteException
	{
	}
	
	public void ejbActivate() throws RemoteException 
	{
	}
	
	public void ejbPassivate() throws RemoteException
	{
	}
	
	public void ejbRemove() throws RemoteException
	{
	}
	
	public void ejbLoad() throws RemoteException
	{
	}
	
	public void ejbStore() throws RemoteException
	{
	}
	
	public void setSessionContext(SessionContext ctx) throws RemoteException
	{
		this.ctx=ctx;
	}

}

/**
 *	$Log: TBSupportBean.java,v $
 *	Revision 1.1.2.2  2001/06/13 19:13:12  eduncan
 *	minor changes made for error messages
 *	
 *	Revision 1.1.2.1  2001/06/12 20:16:34  eduncan
 *	no message
 *	
 *
 */

