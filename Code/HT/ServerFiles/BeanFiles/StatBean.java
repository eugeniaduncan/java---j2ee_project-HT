package com.hoteltools.tbsupport;

import javax.ejb.SessionBean;
import javax.ejb.SessionContext;
import javax.ejb.CreateException;
import java.rmi.RemoteException;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.text.DateFormat;
import com.hoteltools.platform.util.HTDatabase;
import com.hoteltools.platform.util.DatasourceConnectionException;
import com.hoteltools.impl.TableBuilder;
import com.hoteltools.platform.util.LogOutput;

/** 
 * StatBean class
 * @author Eugenia Duncan
 */

public class StatBean implements SessionBean 
{
	private SessionContext ctx = null;

	private LogOutput log = new LogOutput("StatBean");
	
	public StatBean()
	{
	}
	
	// Business logic methods.
	
	public String accessDB() throws RemoteException	
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
			tb.addColumnHeader("Connection");
			tb.addColumnHeader("Power");
			tb.addColumnHeader("Toolbox Running?");
			tb.addColumnHeader("Last Heartbeat");
			tb.addColumnHeader("Protocol Box");
			tb.addColumnHeader("Voicemail");
			tb.addColumnHeader("Call Accounting");

			while (results.next())
			{
				String hdr = results.getString(3);
				tb.addColumnHeader(hdr);
			}

			results.beforeFirst();

			if (results.isBeforeFirst())
			{
				long curOrg       = 0L;
				String descr      = null;
				long org_id       = 0L;
				String org_id_hdr = null;
				String val        = null;
				String value      = null;
				String heart      = null;
				Date heartbeat    = null;

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
					if (results.wasNull()) heart = "&nbsp;";
					else heart = df1.format(heartbeat);
						
					if (!(org_id == curOrg))
					{
						tb.createRow();
						curOrg = org_id;
						tb.addField("Organization Name", descr);
						tb.addField("Site Id", String.valueOf(org_id));
						tb.addField("Last Heartbeat", heart);
					}
					if (org_id_hdr.equals("Connection") || org_id_hdr.equals("Power")
						|| org_id_hdr.equals("Toolbox Running?") || org_id_hdr.equals("Protocol Box")
						|| org_id_hdr.equals("Voicemail") || org_id_hdr.equals("Call Accounting"))
					{
						if ((org_id_hdr.equals("Connection")) && (!val.equals("Primary")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Power")) && (!val.equals("Yes")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Toolbox Running?")) && (!val.equals("Yes")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Protocol Box")) && (!val.equals("Up")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Voicemail")) && (!val.equals("Up")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Call Accounting")) && (!val.equals("Up")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else
						{
							tb.addField(org_id_hdr, val);
						}
					}
					else
					{
						tb.addField(org_id_hdr, val);
					}
				}

				html_output = tb.buildTable();
			}
			else html_output = "<tr><center><font color=\"white\">Database not appropriately responding at this time.</font></center></tr>";

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
				//close the connections
				connect.close();
				connect = null;
			}
			catch (Exception excon)
			{
				//Possible NullPointerException.
				log.debug("Exception:\n" + excon);
				html_output = "<tr><center><font color=\"white\">Database not appropriately responding at this time.</font></center></tr>";
				flag = false;
			}
	
			log.debug("flag (accessDB()) = " + flag);
		}
	
		return html_output;
	}
	
	// overloaded method
	public String accessDB(long orgs) throws RemoteException	
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
			tb.addColumnHeader("Connection");
			tb.addColumnHeader("Power");
			tb.addColumnHeader("Toolbox Running?");
			tb.addColumnHeader("Last Heartbeat");
			tb.addColumnHeader("Protocol Box");
			tb.addColumnHeader("Voicemail");
			tb.addColumnHeader("Call Accounting");

			while (results.next())
			{
				String hdr = results.getString(3);
				tb.addColumnHeader(hdr);
			}

			results.beforeFirst();

			if (results.isBeforeFirst())
			{
				String descr      = null;
				long org_id       = 0L;
				String heart      = null;
				Date heartbeat    = null;
				String org_id_hdr = null;
				String val        = null;
				String value      = null;

				tb.createRow();

				while (results.next())
				{
					descr      = results.getString(1);
					if (results.wasNull()) descr = "&nbsp;";

					org_id     = results.getLong(2);
					if (results.wasNull()) org_id = 00000L;

					heartbeat  = results.getTimestamp(5);
					if (results.wasNull()) heart = "&nbsp;";
					else heart = df1.format(heartbeat);

					org_id_hdr = results.getString(3);
					if (results.wasNull()) org_id_hdr = "&nbsp;";

					val        = results.getString(4);
					if (results.wasNull()) val = "&nbsp;";

					tb.addField("Organization Name", descr);
					tb.addField("Site Id", String.valueOf(org_id));
					tb.addField("Last Heartbeat", heart);
			
					if (org_id_hdr.equals("Connection") || org_id_hdr.equals("Power")
						|| org_id_hdr.equals("Toolbox Running?") || org_id_hdr.equals("Protocol Box")
						|| org_id_hdr.equals("Voicemail") || org_id_hdr.equals("Call Accounting"))
					{
						if ((org_id_hdr.equals("Connection")) && (!val.equals("Primary")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Power")) && (!val.equals("Yes")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Toolbox Running?")) && (!val.equals("Yes")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Protocol Box")) && (!val.equals("Up")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Voicemail")) && (!val.equals("Up")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else if ((org_id_hdr.equals("Call Accounting")) && (!val.equals("Up")))
						{
							value = "<font color=\"red\">"+val+"</font>";
							tb.addField(org_id_hdr, value);
						}
						else
						{
							tb.addField(org_id_hdr, val);
						}
					}
					else
					{
						tb.addField(org_id_hdr, val);
					}
				}

				html_output = tb.buildTable();
			}
			else html_output = "<tr><center><font color=\"white\">Database not appropriately responding at this time.</font></center></tr>";

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
				//close the connections
				connect.close();
				connect = null;
			}
			catch (Exception excon)
			{
				//Possible NullPointerException.
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
 *	$Log: StatBean.java,v $
 *	Revision 1.2.4.1  2001/05/24 19:30:17  eduncan
 *	updated version
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

