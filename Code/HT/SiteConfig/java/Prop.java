package com.hoteltools.impl;
import java.util.*;

/**
 * @author Eugenia Duncan
 */

public class Prop 
{

	public StringBuffer outputPropertyTable(HashMap m, boolean have_prop_val)
	{
		HashMap curMap      = m;
		List curList        = null;
		Set key_set         = curMap.keySet();
		Iterator i          = key_set.iterator();
		StringBuffer html   = new StringBuffer(500);
		boolean repeat      = false;
		boolean havePropVal = have_prop_val;
	
		html.append("<table width=\"50%\" border=\"10\">");
		html.append("<tr align=\"center\">");
		html.append("<td align=\"center\" colspan=\"2\">");
		html.append("<strong>Device description:&nbsp;&nbsp;</strong>");
		html.append(device_descr);
		html.append("</td>");
		html.append("</tr>");
	
		try
		{
			while(i.hasNext())
			{
				Object key = i.next();
		
				curList = (List) curMap.get(key);
				
				int value = Integer.parseInt(curList.get(4).toString());
		
				switch (value)
				{
				case 0:
				case 1:
				case 2:
					//1st row
					//property description
					html.append("<tr>");
					html.append("<table width=\"50%\" border=\"5\">");
					html.append("<tr align=\"center\">");
					html.append("<td align=\"center\" colspan=\"2\">");
					html.append(curList.get(3));
					html.append("</td>");
					html.append("</tr>");
			
					//2nd row
					//property name
					html.append("<tr align=\"center\">");
					html.append("<td align=\"left\" width=\"25%\">");
					html.append(curList.get(0));
					html.append("</td>");
					//property value
					html.append("<td align=\"center\" width=\"25%\">");
					html.append("<input type=\"text\" name=\"" +
									 curList.get(0) + "\" value=\"" + curList.get(1) +
									 "\" size=\"15\" maxlength=\"50\">");
					html.append("</td>");
					html.append("</tr>");
					html.append("</table>");
	
					html.append("<tr>");
					break;
				case 3:
					//1st row
					//property description
					html.append("<tr>");
	
					html.append("<table width=\"50%\" border=\"5\">");
					html.append("<tr align=\"center\">");
					html.append("<td align=\"center\" colspan=\"2\">");
					html.append(curList.get(3));
					html.append("</td>");
					html.append("</tr>");
		
					//2nd row
					//property name
					html.append("<tr align=\"center\">");
					html.append("<td align=\"left\" width=\"25%\">");
					html.append(curList.get(0));
					html.append("</td>");
					//property value
					html.append("<td align=\"center\" width=\"25%\">");
					html.append("<select name=\""+curList.get(0)+"\">");
		
					StringTokenizer default_list = new StringTokenizer(curList.get(2).toString(),",;");
					String[] text = new String[default_list.countTokens()];
		
					while(default_list.hasMoreTokens())
					{
						for(int j = 0; j < text.length; j++)
						{
							text[j] = default_list.nextToken();
						}
					}

					for(int j = 1; j < text.length; j++)
					{
						if (text[j].equals(text[0]))
							repeat = true;
					}

					int k = 0;

					if (repeat==true)
					{
						k = 1;
						if (havePropVal==true)
							html.append("<option value=\""+text[0]+"\">"+text[0]+"</option>");
						else html.append("<option selected value=\""+text[0]+"\">"+text[0]+"</option>");
					}
					else
					{
						k = 0;
						if (havePropVal!=true)
							html.append("<option selected value=\""+text[0]+"\">"+text[0]+"</option>");

					}

					for(int j = k; j < text.length; j++)
					{
						if (havePropVal==true)
						{
							if(text[j].equals(curList.get(1)))
								html.append("<option selected value=\""+text[j]+"\">"+text[j]+"</option>");
							else
								html.append("<option value=\""+text[j]+"\">"+text[j]+"</option>");
						}
						else
						{		if (j==0) continue;
								html.append("<option value=\""+text[j]+"\">"+text[j]+"</option>");
						}
					}

					html.append("</select>");
					html.append("</td>");
					html.append("</tr>");
					html.append("</table>");
					html.append("<tr>");
					break;	
				}
			
			}

			html.append("</table>");
	
			havePropVal = false;
		
		}
		catch(Exception e)
		{
			System.out.println("Exception: " + e);
		}
	
		return html;
	}


}
