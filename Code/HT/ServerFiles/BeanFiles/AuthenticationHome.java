package com.hoteltools.tbsupport;

import javax.ejb.EJBHome;
import javax.ejb.CreateException;
import java.rmi.RemoteException;

/** 
 * AuthenticationHome interface
 * @author Eugenia Duncan
 */

public interface AuthenticationHome extends EJBHome 
{
    public Authentication create() throws CreateException, RemoteException;
}

/**
 *	$Log$
 *
 */

