package com.hoteltools.tbsupport;

import javax.ejb.EJBObject;
import java.rmi.RemoteException;

/** 
 * Users interface
 * @author Eugenia Duncan
 */

public interface Users extends EJBObject 
{
    public int getUserId() throws RemoteException;
	 public String getUserName() throws RemoteException;
	 public String getPassword() throws RemoteException;
//	 public String getPhone() throws RemoteException;
//	 public String getCellPhone() throws RemoteException;
//	 public String getCompany() throws RemoteException;

//	 public void setUserId(int user_id) throws RemoteException;
//	 public void setUserName(String username) throws RemoteException;
//	 public void setPassword(String password) throws RemoteException;
//	 public void setPhone(String phone) throws RemoteException;
//	 public void setCellPhone(String cell_phone) throws RemoteException;
//	 public void setCompany(String company) throws RemoteException;
}

/**
 *	$Log: Users.java,v $
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

