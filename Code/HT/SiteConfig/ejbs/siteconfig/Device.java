package com.hoteltools.siteconfig;

import javax.ejb.*;
import java.rmi.*;

/** 
 * Device interface
 * @author Eugenia Duncan
 */

public interface Device extends EJBObject 
{
	String listDevices(String org) throws RemoteException;

	String gatherInfo(String dev, String org) throws RemoteException;

	Set compareDeviceSets() throws RemoteException;

	Set comparePropSets() throws RemoteException;
}

/**
 *	$Log
 *
 */

