package com.hoteltools.tbsupport;

import javax.ejb.EJBObject;
import java.rmi.RemoteException;

/** 
 * Authentication interface
 * @author Eugenia Duncan
 */

public interface Authentication extends EJBObject 
{
    public boolean isAuthentic(String username, String password) throws RemoteException;
}

/**
 *	$Log$
 *
 */

