package com.hoteltools.tbsupport;

import javax.ejb.EJBHome;
import javax.ejb.CreateException;
import java.rmi.RemoteException;

/** 
 * StatHome interface
 * @author Eugenia Duncan 
 */

public interface StatHome extends EJBHome 
{
    public Stat create() throws CreateException, RemoteException;
}

/**
 *	$Log: StatHome.java,v $
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

