package com.hoteltools.siteconfig;

import javax.ejb.*;
import java.rmi.*;
import java.sql.*;
import java.util.*;
import com.hoteltools.platform.util.HTDatabase;
import com.hoteltools.platform.util.DatasourceConnectionException;
import com.hoteltools.platform.util.LogOutput;
import com.hoteltools.impl.Prop;

/** 
 * DeviceBean class
 * @author Eugenia Duncan
 */

public class DeviceBean implements SessionBean 
{
	private SessionContext ctx;

	private String username;

	private HashMap prop_map;
	private List[] prop_list;
	private Set dev_set;
	private String device_descr;

	private Set all_devs;
	private Set all_props;

	private LogOutput log = new LogOutput("DeviceBean");
	
	public DeviceBean()
	{
	}
	
	// Business logic methods.

	public String listDevices(String org)
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
	
			state =  "SELECT DEVICE_LIST.* FROM DEVICE_LIST, SITE_CONFIG " + 
						"WHERE SITE_CONFIG.ORGANIZATION_ID = " + org_id +"AND DEVICE_LIST.DEVICE_ID = " + 
						"SITE_CONFIG.DEVICE_ID ORDER BY SITE_CONFIG.DEVICE_ID";
	
			ResultSet results = statement.executeQuery(state);
	
			html.append("<option value=\"Toolbox\">Toolbox</option>");

			this.dev_set      = null;
			this.device_descr = null;
			this.prop_list    = null;
			this.prop_map     = null;
	
			this.dev_set = new HashSet();
	
			while(results.next())
			{
				res = results.getString(2);
				dev_set.add(res);
			}
	
			dev_set.remove("Toolbox");
	
			Iterator i = dev_set.iterator();
	
			while(i.hasNext())
			{
				String nextItem = (String) i.next();
	
				html.append("<option value=\""+ nextItem +"\">"+ nextItem +"</option>");
			}
	
			html_out = html.toString();
	
			flag = true;
	
		}
		catch (Exception e)
		{
			log.debug("Exception:\n"+ e);
	
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
				//Possible NullPointerException
				log.debug("Exception:\n" + excon);
				html_out = "<option>Database not appropriately responding at this time.</option>";
				flag = false;
			}
	
			log.debug("flag (listDevices()) = " + flag);
		}
	
		return html_out;
	
	}

	
	public String gatherInfo(String dev, String org)
	{
		String device      = dev;
		String org_id      = org;
		boolean flag       = false;
		Connection connect = null;
		String html_out    = null;
		StringBuffer html  = new StringBuffer(500);
	
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
	
			Statement statement1 = connect.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement statement2 = connect.createStatement();
	
			String state1 = null;
			String state2 = null;
	
			state1 =    "SELECT SITE_CONFIG.PARAM_NAME, SITE_CONFIG.PARAM_VALUE, PARAM_DESC.DEFAULT_VALUE, "+
							"PARAM_DESC.PARAM_DESC, PARAM_DESC.PARAM_TYPE, PARAM_DESC.VALUE_MASK, "+
							"PARAM_DESC.VALUE_MIN, PARAM_DESC.VALUE_MAX "+
							"FROM SITE_CONFIG, PARAM_DESC, DEVICE_LIST "+
							"WHERE SITE_CONFIG.ORGANIZATION_ID = " + org_id + ""+
							"AND DEVICE_LIST.DEVICE_NAME = \'" + device + "\' "+
							"AND SITE_CONFIG.DEVICE_ID = DEVICE_LIST.DEVICE_ID "+ 
							"AND PARAM_DESC.DEVICE_ID = DEVICE_LIST.DEVICE_ID "+
							"AND SITE_CONFIG.PARAM_NAME = PARAM_DESC.PARAM_NAME ";
	
			state2 =    "SELECT DEVICE_LIST.DESCRIPTION FROM DEVICE_LIST " +
							"WHERE DEVICE_LIST.DEVICE_NAME = \'" + device + "\' ";
	
			String resA = null;
			long resB	= 0L;
	
			ResultSet results1 = statement1.executeQuery(state1);
			ResultSet results2 = statement2.executeQuery(state2);

			this.prop_map  = new HashMap();
			this.prop_list = new ArrayList[20];
	
			int rows = 0;
	
			//get the number of rows
			results1.last();
			rows = results1.getRow();
			results1.beforeFirst();
	
			while(results1.next())
			{
				for(int i = 0; i < rows; i++)
				{
					prop_list[i] = new ArrayList();
	
					for(int n = 1; n < 7; n++)
					{
						resA = results1.getString(n);
						prop_list[i].add(resA);
					}
		
					for(int n = 7; n < 9; n++)
					{
						resB = results1.getLong(n);
						prop_list[i].add(new Long(resB));
					}
	
					prop_map.put(prop_list[i].get(0), prop_list[i]);
				}
			}
	/*		
			prop_list configuration
			0 = prop_name
			1 = prop_value
			2 = default_value
			3 = prop_desc
			4 = prop_type
			5 = mask
			6 = min
			7 = max
	*/
			while(results2.next())
			{
				this.device_descr = results2.getString(1);
			}

			Prop prop = new Prop();
	
			html = prop.outputPropertyTable(prop_map, true);
	
			html_out = html.toString();
	
			flag = true;
	
		}
		catch (Exception e)
		{
			log.debug("Exception:\n"+ e);
	
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
				//Possible NullPointerException
				log.debug("Exception:\n" + excon);
				html_out = "<option>Database not appropriately responding at this time.</option>";
				flag = false;
			}
	
			log.debug("flag (gatherInfo()) = " + flag);
		}
	
		return html_out;
	}

	public void makeNewDeviceSet()
	{
		boolean flag = false;

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
	
			String state = null;
	
			state  =    "SELECT DEVICE_NAME FROM DEVICE_LIST";
	
			String res = null;
	
			ResultSet results = statement.executeQuery(state);

			while(results.next())
			{
				res = results.getString(1);
				this.all_devs.add(res);
			}

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
				//close the connections
				connect.close();
				connect = null;
			}
			catch (Exception excon)
			{
				//Possible NullPointerException
				log.debug("Exception:\n" + excon);
				flag = false;
			}
	
			log.debug("flag (makeNewDeviceSet()) = " + flag);
		}
	}

	public void makeNewPropSet(String device)
	{
		boolean flag = false;

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
	
			Statement statement1 = connect.createStatement();
	
			String state1  =    "SELECT DEVICE_ID FROM DEVICE_LIST WHERE DEVICE_NAME = \'" + device + "\' ";
	
			long   res1 = 0L;
	
			ResultSet results1 = statement1.executeQuery(state1);

			while(results1.next())
			{
				res1 = results1.getLong(1); 	
			}

			Statement statement2 = connect.createStatement();

			String state2  =    "SELECT PARAM_DESC.PARAM_NAME FROM PARAM_DESC, DEVICE_LIST" +
									  "WHERE DEVICE_LIST.DEVICE_ID = " + res1;

			String res2 = null;

			ResultSet results2 = statement2.executeQuery(state2);

			while(results2.next())
			{
				res2 = results2.getString(1);
				this.all_props.add(res2);
			}

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
				//close the connections
				connect.close();
				connect = null;
			}
			catch (Exception excon)
			{
				//Possible NullPointerException
				log.debug("Exception:\n" + excon);
				flag = false;
			}
	
			log.debug("flag (makeNewPropSet()) = " + flag);
		}
	}

	public Set compareDeviceSets()
	{
		makeNewDeviceSet();

		Set all_devs = this.all_devs;
		Set dev_set  = this.dev_set;
		Set dev_new  = new HashSet();

		Iterator iAll = all_devs.iterator();
		Iterator iSet = dev_set.iterator();

		while(iSet.hasNext())
		{
			String nextItemSet = (String) iSet.next();

			while(iAll.hasNext())
			{
				String nextItemAll = (String) iAll.next();

				if (! nextItemAll.equals(nextItemSet))
				{
				}
			}
		}
	}

	public Set comparePropSets(String device)
	{
		makeNewPropSet(device);

		Set all_props = this.all_props;
		HashMap m     = this.prop_map;

		Set prop_set = m.keySet();
	}

	public String getUserName()
	{
		return this.username;
	}
	
	public HashMap getProp_Map()
	{
		return this.prop_map;
	}
	
	public List[] getProp_List()
	{
		return this.prop_list;
	}
	
	public Set getDeviceSet()
	{
		return this.dev_set;
	}

	public String getDeviceDescription()
	{
		return this.device_descr;
	}

	public Set getAllDevices()
	{
		return this.all_devs;
	}

	public Set getAllProps()
	{
		return this.all_props;
	}
		
	// EJB-required container methods.

	public void ejbCreate(String username) throws CreateException, RemoteException
	{
		this.username = username;
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
 */

