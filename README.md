
# /* About java---j2ee_project-HT */

Summary:

This repo provides the programming code of a J2EE (Java Enterprise Edition) web app that I wrote a while back for a company I worked for that had gone out of business at that time.  It is fortunate that the former owners and managers of this former company had granted express permission to use the code that I wrote as a Java Developer / Software Engineer, as well as relevant correspondence for this project, according to responses back to verbal and written requests.  At the time of this project, the Dot Com Bubble burst (Y2K), so many similar IT companies and firms also went out of business as a result.  However, I enjoyed the challenge of building an entire web application during my stay, and the code and the process has been posted.

About the Project:

I designed two high-tech web-based applications as a central point of information for major hotel chains in the metro of Atlanta, GA.  Technologies used included the J2EE (Java Enterprise Edition) framework, Apache Tomcat/Ant servlet server, WebLogic application server and Oracle 8i database.  Although, at that time, technologies such as AJAX and SPA's (Single Page Applications) were not available, note that the code structure is still quite modular due to the flexibility of J2EE technology.

The two web applications built were called (1.) the Toolbox Support App and (2.) the Site Configuration App.  The former app was completed within a few months.  The latter app was not totally completed due to the company's demise taking place during that part of the project.  However, most of the app was finished, and thus it is still also useful as a demo example of the flow of a Java EE web application.

Technical Description of the Applications:

Toolbox Support App – Web app using JSPs (Java Server Pages) and JavaScript on the front end and running queries on the back end via EJB/JDBC (Enterprise Java Beans / Java Database Connectivity) in order to pull the statistics/metrics (power outages, connectivity issues, etc.) of remote stations (toolboxes).  Parameters were updated and stored in the database using JMS technology sent from the units.

Site Configuration App – Web app using JSPs and JavaScript on the front end and running queries on the back end via EJB/JDBC in order to configure all device parameters (baud rate, flow control, etc.) for each remote station.  Parameters were updated and stored in the database using JMS technology sent from the units.

