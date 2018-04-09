package com.hoteltools.tbsupport;

import javax.ejb.SessionBean;
import javax.ejb.SessionContext;
import javax.ejb.CreateException;
import java.rmi.RemoteException;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;
import java.sql.Timestamp;
import java.text.DateFormat;
import com.hoteltools.platform.util.HTDatabase;
import com.hoteltools.platform.util.DatasourceConnectionException;
import com.hoteltools.platform.util.LogOutput;

/** 
 * AccessBean class
 * @author Eugenia Duncan
 */

public class AccessBean implements SessionBean 
{
	private SessionContext ctx = null;

	private LogOutput log = new LogOutput("AccessBean");
	
	public AccessBean()
	{
	}
	
	// Business logic methods.
	
	public String accessDB(long org_ID, String connection, String power,
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
		long fail = 0L;
	
		StringBuffer html = new StringBuffer(750);
		String html_output = null;

		String insert1 = null;
		Date assignment1 = null;

		String insert2 = null;
		Date assignment2 = null;
		
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
	
			// Execute the SQL statement to get the organization's Failure Mode ID
			ResultSet results1 = statement.executeQuery("select FAIL_MODE_ID from FAILURE_API_JOURNAL where ORGANIZATION_ID =" + org_id);
						
			while (results1.next())
			{
				
				fail = results1.getLong(1);
				
				// For each problem issue in the List above, select all the tickets for that code
				for ( int counter = 0; counter < ref_code.size(); counter ++)
				{ 				
					clause = "select DATE_OPENED, DATE_OCCURED, REASON from ROOT_CAUSE_ANALYSIS where PROBLEM_CATEGORY =" + ref_code.get(counter) + " and FAIL_MODE_ID = " + fail +" " + time_period;
					
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
					
				}// for loop
			}
	
			html_output = html.toString();
			flag = true;
			
		}
		catch (Exception e)
		{
			log.debug("Exception:\n" + e);
			html_output = "<tr><center><font color=\"white\">Database not appropriately responding at this time.</font></center></tr>";
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
				html_output = "<tr><center><font color=\"white\">Database not appropriately responding at this time.</font></center></tr>";
				flag = false;
			}
	
			log.debug("flag (accessDB()) = " + flag);
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
 *	$Log: AccessBean.java,v $
 *	Revision 1.2.4.1  2001/05/24 19:30:17  eduncan
 *	updated version
 *	
 *	Revision 1.1.4.3  2001/05/24 19:11:32  eduncan
 *	problem_category modification
 *	
 *	Revision 1.1.4.2  2001/05/23 20:32:10  eduncan
 *	modifications made
 *	
 *	Revision 1.1.4.1  2001/05/18 17:55:09  eduncan
 *	Added implementation files.
 *	
 *	Revision 1.1.2.1  2001/05/11 17:11:09  eduncan
 *	new files for Toolbox Support
 *	
 *
 */

