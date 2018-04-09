
package com.hoteltools.impl;
import java.util.*;

/**
 *	Builds a dynamic grid
 *	Usage:   Call addColumnHeader to add each column header. Order added dictates column order
 *			 Call createRow before adding fields for that row
 *			 Call addField to add a field to the current row
 *			 When done adding fields, call buildTable to return an html string
 *
 * @author Eugenia Duncan
 *			  
 *	$Log: TableBuilder.java,v $
 *	
 *	Revision 1.1.4.1  2001/05/11 17:15:46  eduncan
 *	new files for Toolbox Support
 *	
 * 
 */

public class TableBuilder 
{
	HashMap		colListByNum = new HashMap();
	HashMap		colList = new HashMap();
	HashMap		rowList = new HashMap();
	HashMap		curRowMap;
	int			curCol = 0;
	int			curRow = -1;
	
	/** Add a column header. The order in which this is called dictates column order */
	public void addColumnHeader( String hdr )
	{
		if (null == colList.get( hdr ))
		{
			colList.put( hdr, new Integer( curCol ) );
			colListByNum.put( new Integer( curCol ), hdr );
			curCol = curCol + 1;
		}
	}
	
	/** Create a new row. Call this before adding fields to a row */
	public void createRow()
	{
		curRow = curRow + 1;
		curRowMap = new HashMap();
		rowList.put( new Integer( curRow ), curRowMap );
	}
	
	/** Add a field to the current row */
	public void addField( String columnName, String columnValue )
	{
		curRowMap.put( colList.get( columnName ), columnValue );
	}
	
	/** Build an html string containing the table */
	public String buildTable()
	{
		StringBuffer html = new StringBuffer(10000);
		html.append("<tr>");

		// Build header line
		for (int i = 0; i < colListByNum.size(); i++)
		{
			html.append( "<th><center>" + colListByNum.get( new Integer( i ) ) + "</center></th>" );
		}
		html.append( "</tr>" );

		// Build data rows
		for (int i = 1; i < rowList.size(); i++)
		{
			curRowMap = (HashMap) rowList.get( new Integer( i ) );
			html.append( "<tr>" );
			for (int j = 0; j < colList.size(); j++)
			{
				Object crm = curRowMap.get( new Integer( j ) );
				if(crm == null) crm = new String("&nbsp;");
				html.append( "<td><center>" + crm + "</center></td>" );
			}
			html.append( "</tr>" );
		}
	  	return html.toString();
	}
}
