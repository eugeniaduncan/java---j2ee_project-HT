package com.hoteltools.tbsupport;

import javax.ejb.EJBObject;
import java.rmi.RemoteException;

/** 
 * Stat interface
 * @author Eugenia Duncan 
 */

public interface Stat extends EJBObject 
{
    public String accessDB() throws RemoteException;
	 public String accessDB(long orgs) throws RemoteException;
}

/**
 *	$Log: Stat.java,v $
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

