package com.hoteltools.tbsupport;

import javax.ejb.*;
import java.rmi.*;

/** 
 * TBSupport interface
 * @author Eugenia Duncan
 */

public interface TBSupport extends EJBObject 
{
	public boolean isAuthentic(String usnm, String pswd) throws RemoteException;

   public String showHistory(long org_ID, String connection, String power,
									  String shutdown, String pb_connection, String status,
									  String dates, String date1, String date2)
                             throws RemoteException;

	public String showOrg() throws RemoteException;

	public String showStatus() throws RemoteException;
	public String showStatus(long orgs) throws RemoteException;
}

/**
 *	$Log
 *
 */

