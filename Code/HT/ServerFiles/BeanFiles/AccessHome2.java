package com.hoteltools.tbsupport;

import javax.ejb.EJBHome;
import javax.ejb.CreateException;
import java.rmi.RemoteException;

/** 
 * AccessHome2 interface
 * @author Eugenia Duncan 
 */

public interface AccessHome2 extends EJBHome 
{
    public Access2 create() throws CreateException, RemoteException;
}

/**
 *	$Log$
 *
 */

