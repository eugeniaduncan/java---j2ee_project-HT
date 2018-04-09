package com.hoteltools.tbsupport;

import javax.ejb.EntityBean;
import javax.ejb.EntityContext;
import javax.ejb.CreateException;
import java.rmi.RemoteException;

/** 
 * UsersBean class
 * @author Eugenia Duncan
 */

/**
 * This container-managed persistent entity bean represents a user record.
 */

public class UsersBean implements EntityBean
{
	// ----------Container-managed fields----------

	protected EntityContext ctx;

	public int user_id;
	public String username;
	public String password;
//	public String phone;
//	public String cell_phone;
//	public String company;
	
	public UsersBean()
	{
	}
	
	// -----------Business logic methods-----------

		// Getter methods

	public int getUserId() throws RemoteException
	{
		return user_id;
	}
	
	public String getUserName() throws RemoteException
	{
		return username;
	}

	public String getPassword() throws RemoteException
	{
		return password;
	}
/*
	public String getPhone() throws RemoteException
	{
		return phone;
	}

	public String getCellPhone() throws RemoteException
	{
		return cell_phone;
	}

	public String getCompany() throws RemoteException
	{
		return company;
	}
*/	
		// Setter methods
/*
	public void setUserId(int user_id) throws RemoteException
	{
		this.user_id = user_id;
	}
	
	public void setUserName(String username) throws RemoteException
	{
		this.username = username;
	}

	public void setPassword(String password) throws RemoteException
	{
		this.password = password;
	}

	public void setPhone(String phone) throws RemoteException
	{
		this.phone = phone;
	}

	public void setCellPhone(String cell_phone) throws RemoteException
	{
		this.cell_phone = cell_phone;
	}

	public void setCompany(String company) throws RemoteException
	{
		this.company = company;
	}
*/

	// ----------EJB-required container methods----------
/*	
	public void ejbCreate(int user_id, String username, String password,
								 String phone, String cell_phone, String company)
								 throws CreateException, RemoteException
	{
		this.user_id    = user_id;
		this.username   = username;
		this.password   = password;
		this.phone      = phone;
		this.cell_phone = cell_phone;
		this.company    = company;
	}

	public void ejbPostCreate(int user_id, String username, String password,
									  String phone, String cell_phone, String company)
									  throws RemoteException 
	{
	}
*/
	public UsersPK ejbCreate(int user_id, String username, String password)
								 throws CreateException, RemoteException
	{
		this.user_id    = user_id;
		this.username   = username;
		this.password   = password;
	  //this.phone      = phone;
      //this.cell_phone = cell_phone;
	  //this.company    = company;

		return new UsersPK(user_id);
	}

	public void ejbPostCreate(int user_id, String username, String password)
									  throws RemoteException 
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
	
	public void setEntityContext(EntityContext ctx) throws RemoteException
	{
		this.ctx=ctx;
	}

	public void unsetEntityContext() throws RemoteException
	{
		this.ctx=null;
	}
}

/**
 *	$Log: UsersBean.java,v $
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

