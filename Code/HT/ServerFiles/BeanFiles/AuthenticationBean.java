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
 * AuthenticationBean class
 * @author Eugenia Duncan
 */

public class AuthenticationBean implements SessionBean 
{
	private SessionContext ctx = null;

	private LogOutput log = new LogOutput("AuthenticationBean");
   
	public AuthenticationBean()
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
					throw new Exception("Username not found for " + username + ".");
				else
					throw new Exception("Password does not match password for " + username + ".");
		
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

