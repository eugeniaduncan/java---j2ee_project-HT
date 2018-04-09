@echo on
@rem This script should be used to set up your environment for 
@rem compiling and running the examples included with WebLogic 
@rem Server. It contains the following variables: 
@rem 
@rem WL_HOME   - This must point to the root directory of your WebLogic 
@rem             installation. 
@rem JAVA_HOME - Determines the version of Java used to compile  
@rem             and run examples. This variable must point to the 
@rem             root directory of a complete JDK installation. See 
@rem             the WebLogic platform support page 
@rem             (http://www.weblogic.com/docs51/platforms/index.html)
@rem             for an up-to-date list of supported JVMs on Windows NT. 
@rem 
@rem When setting these variables below, please use short file names(8.3). 
@rem To display short (MS-DOS) filenames, use "dir /x". File names with 
@rem spaces will break this script.
@rem 
@rem jDriver for Oracle users: This script assumes that native libraries 
@rem required for jDriver for Oracle have been installed in the proper 
@rem location and that your system PATH variable has been set appropriately. 
@rem For additional information, refer to Installing and Setting up WebLogic 
@rem Server (/install/index.html in your local documentation set or on the 
@rem Internet at http://www.weblogic.com/docs51/install/index.html). 

@rem Set user-defined variables.
set WL_HOME=c:\weblogic
set JAVA_HOME=c:\jdk1.3
@rem set JAVA_HOME=c:\progra~1\micros~1.2

@if exist %WL_HOME%\classes\boot\weblogic\Server.class goto checkJava
@echo.
@echo The WebLogic Server wasn't found in directory %WL_HOME%.
@echo Please edit the setEnv.cmd script so that the WL_HOME
@echo variable points to the WebLogic Server installation directory.
@goto finish

:checkJava
@if exist %JAVA_HOME%\bin\java.exe goto java
@if exist %JAVA_HOME%\Bin\JView.exe goto jview
@if exist %JAVA_HOME%\..\JView.exe goto jview
@echo.
@echo The JDK wasn't found in directory %JAVA_HOME%.
@echo Please edit the setEnv.cmd script so that the JAVA_HOME
@echo variable points to the location of your JDK.
@goto finish

:java
set RMIFORMS=
set JDK_CLASSES=%JAVA_HOME%\lib\tools.jar;c:\j2sdkee1.2.1\lib\j2ee.jar
@if exist %JAVA_HOME%\lib\classes.zip goto jdk11
@goto setEnv

:jdk11
set JDK_CLASSES=%JAVA_HOME%\lib\classes.zip;
@goto setEnv

:jview
set JDK_CLASSES=%windir%\Java\classes\classes.zip;
set RMIFORMS=;%WL_HOME%\lib\rmiForMs.zip
@goto setEnv

:setEnv
set CLIENT_CLASSES=%WL_HOME%\myserver\clientclasses;c:\src\crete\source\jlib\toolboxapi.jar;c:\src\crete\source\java;c:\src\crete\source\test;c:\src\barbados\source\jlib\toolboxapi.jar;c:\src\barbados\source\java\;c:\src\barbados\source\test;c:\src\integration\source\jlib\toolboxapi.jar;c:\src\integration\source\java;c:\src\integration\source\test;%WL_HOME%\myserver\clientclasses\examples\ejb\basic\statelessSession;
set SERVER_CLASSES=%WL_HOME%\myserver\serverclasses
set SERVLET_CLASSES=%WL_HOME%\myserver\servletclasses

set CLASSPATH=%JDK_CLASSES%;%WL_HOME%\license;%WL_HOME%\classes;%WL_HOME%\lib\weblogic510sp6.jar;%WL_HOME%\classes12.zip;%WL_HOME%\lib\weblogicaux.jar;%CLIENT_CLASSES%;%SERVER_CLASSES%;%SERVLET_CLASSES%;%RMIFORMS%

set PATH=%WL_HOME%\bin;%JAVA_HOME%\bin;%PATH%

:finish
