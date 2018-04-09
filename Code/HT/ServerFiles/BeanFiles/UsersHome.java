package com.hoteltools.tbsupport;

import javax.ejb.EJBHome;
import javax.ejb.CreateException;
import javax.ejb.FinderException;
import java.rmi.RemoteException;
import java.util.Enumeration;

/** 
 * UsersHome interface
 * @author Eugenia Duncan
 */

public interface UsersHome extends EJBHome 
{
//  public Users create(int user_id, String username, String password,
//								 String phone, String cell_phone, String company)
//								 throws CreateException, RemoteException;

    public Users create(int user_id, String username, String password)
								 throws CreateException, RemoteException;

	 public Users findByPrimaryKey(UsersPK key) throws FinderException, RemoteException;

	 public Users findByUserID(int id) throws FinderException, RemoteException;

	 public Enumeration findByUserName(String name) throws FinderException, RemoteException;
 
	 public Enumeration findByPassword(String pswd) throws FinderException, RemoteException;

//	 public Enumeration findByPhone(String ph) throws FinderException, RemoteException;

//	 public Enumeration findByCellPhone(String cell_ph) throws FinderException, RemoteException;

//	 public Enumeration findByCompany(String comp) throws FinderException, RemoteException;

//	 public Enumeration findAllUsers() throws FinderException, RemoteException;
}

/**
 *	$Log: UsersHome.java,v $
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

