package com.hoteltools.tbsupport;

import java.io.Serializable;

/** 
 * UsersPK interface
 * @author Eugenia Duncan
 */

public class UsersPK implements Serializable
{
	public int user_id;

	public UsersPK(int user_id)
	{
		this.user_id = user_id;
	}

	public UsersPK()
	{
	}

	public String toString()
	{
		return (new Integer(user_id)).toString();
	}

	public int hashCode()
	{
		return user_id;
	}

	public boolean equals(Object obj)
	{
		return ((UsersPK) obj).user_id == this.user_id;
	}
}

/**
 *	$Log: UsersPK.java,v $
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

