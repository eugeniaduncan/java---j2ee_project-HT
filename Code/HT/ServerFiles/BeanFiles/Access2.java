package com.hoteltools.tbsupport;

import javax.ejb.EJBObject;
import java.rmi.RemoteException;

/** 
 * Access2 interface
 * @author Eugenia Duncan 
 */

public interface Access2 extends EJBObject 
{
    public String accessDB(long t) throws RemoteException;
}

/**
 *	$Log$
 *
 */

