package com.hoteltools.tbsupport;

import javax.ejb.EJBObject;
import java.rmi.RemoteException;

/** 
 * Access interface
 * @author Eugenia Duncan
 */

public interface Access extends EJBObject 
{
    public String accessDB(long org_ID, String connection, String power,
								String shutdown, String pb_connection, String status,
								String dates, String date1, String date2)
                           throws RemoteException;
}

/**
 *	$Log: Access.java,v $
 *	Revision 1.2.4.1  2001/05/24 19:30:17  eduncan
 *	updated version
 *	
 *	Revision 1.1.4.2  2001/05/24 19:11:32  eduncan
 *	problem_category modification
 *	
 *	Revision 1.1.4.1  2001/05/18 17:55:09  eduncan
 *	Added implementation files.
 *	
 *	Revision 1.1.2.1  2001/05/11 17:11:09  eduncan
 *	new files for Toolbox Support
 *	
 *
 */

