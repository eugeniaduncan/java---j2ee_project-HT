package com.hoteltools.siteconfig;

import javax.ejb.*;
import java.rmi.*;

/** 
 * DeviceHome interface
 * @author Eugenia Duncan
 */

public interface DeviceHome extends EJBHome 
{
    Device create() throws CreateException, RemoteException;
}

/**
 *	$Log$
 *
 */

