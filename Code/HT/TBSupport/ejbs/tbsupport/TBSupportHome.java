package com.hoteltools.tbsupport;

import javax.ejb.*;
import java.rmi.*;

/** 
 * TBSupportHome interface
 * @author Eugenia Duncan
 */

public interface TBSupportHome extends EJBHome 
{
    public TBSupport create() throws CreateException, RemoteException;
}

/**
 *	$Log$
 *
 */

