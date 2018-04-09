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
 * OrgIDBean class
 * @author Eugenia Duncan
 */

public class OrgIDBean implements SessionBean 
{
	private SessionContext ctx = null;

	private LogOutput log = new LogOutput("OrgIDBean");
	
	public OrgIDBean()
	{
	}
	
	// Business logic methods.
	
	public String accessDB() throws RemoteException	
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
 *	$Log: OrgIDBean.java,v $
 *	Revision 1.2.4.1  2001/05/24 19:30:17  eduncan
 *	updated version
 *	
 *	Revision 1.1.4.1  2001/05/18 17:55:09  eduncan
 *	Added implementation files.
 *	
 *	Revision 1.1.2.1  2001/05/11 17:11:09  eduncan
 *	new files for Toolbox Support
 *	
 *
 */

