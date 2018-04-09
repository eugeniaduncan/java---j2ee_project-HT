package com.hoteltools.tbsupport;

import javax.ejb.SessionBean;
import javax.ejb.SessionContext;
import javax.ejb.CreateException;
import java.rmi.RemoteException;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.hoteltools.platform.util.HTDatabase;
import com.hoteltools.platform.util.DatasourceConnectionException;
import com.hoteltools.platform.util.LogOutput;

/** 
 * AccessBean2 class
 * @author Eugenia Duncan
 */

public class AccessBean2 implements SessionBean 
{
	private SessionContext ctx = null;

	private LogOutput log = new LogOutput("AccessBean2");
	
	public AccessBean2()
	{
	}
	
	// Business logic methods.
	
	public String accessDB(long t) throws RemoteException	
	{  
		boolean flag = false;
		Connection connect = null;
		
		long ticket    = t;

		String clause = null;
		long fail = 0L;
	
		StringBuffer html = new StringBuffer(750);
		String html_output = null;
		
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
	
			statement.executeQuery("update ROOT_CAUSE_ANALYSIS set DATE_CLOSED = SYSDATE where TROUBLE_TICKET_ID = " + ticket);    

			html.append("<b>THE FOLLOWING TICKET HAS BEEN CLOSED: </b><br><br>");
			html.append("<tr>");
			html.append("<th><center>FAILMODE ID</center></th>");
			html.append("<th><center>TROUBLE TICKET_ID</center></th>");
			html.append("<th><center>DATE OPENED</center></th>");
			html.append("<th><center>DATE CLOSED</center></th>");
			html.append("<th><center>REASON</center></th>");
			html.append("<th><center>PROBLEM CATEGORY</center></th>");
			html.append("<th><center>DATE OCCURED</center></th>");
			html.append("</tr>");

			ResultSet results3 = statement.executeQuery("select FAIL_MODE_ID, TROUBLE_TICKET_ID, DATE_OPENED, DATE_CLOSED, REASON, PROBLEM_CATEGORY, DATE_OCCURED from ROOT_CAUSE_ANALYSIS where TROUBLE_TICKET_ID =" + ticket);

			while (results3.next()) {

				 html.append("<tr>");
				 html.append("<td><center>" + results3.getLong(1)   + "</center></td>");
				 html.append("<td><center>" + results3.getString(2) + "</center></td>");
				 html.append("<td><center>" + results3.getTimestamp(3)   + "</center></td>");
				 html.append("<td><center>" + results3.getTimestamp(4)   + "</center></td>");
				 html.append("<td><center>" + results3.getString(5) + "</center></td>");
				 html.append("<td><center>" + results3.getLong(6)   + "</center></td>");
				 html.append("<td><center>" + results3.getTimestamp(7)   + "</center></td>");
				 html.append("</tr>");
			}

			html_output = html.toString();
			flag = true;
			
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
				connect.close();
				connect = null;
			}
			catch (Exception excon)
			{
				//Possible NullPointerException.
				log.debug("Exception:\n" + excon);
				flag = false;
			}
	
			log.debug("flag (accessDB2()) = " + flag);
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
 *	$Log$
 *
 */

