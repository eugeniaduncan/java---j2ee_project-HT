@echo off
@rem $Id: //depot/dev/src/startWebLogic.cmd#4 $

@rem This script can be used to start WebLogic Server. It contains 
@rem following variables: 
@rem 
@rem JAVA_HOME      - Determines the version of Java used to start  
@rem                  WebLogic Server. This variable must point to the 
@rem                  root directory of a JDK or JRE installation. See 
@rem                  the WebLogic platform support page 
@rem                  (http://www.weblogic.com/docs51/platforms/index.html)
@rem                  for an up-to-date list of supported JVMs on Windows NT. 
@rem                  Because of packaging differences between versions of Java, 
@rem                  this script will not work with a JRE 1.1.7 installation.
@rem PRE_CLASSPATH  - Use this variable to prepend jar files or directories to 
@rem                  the WEBLOGIC_CLASSPATH.
@rem POST_CLASSPATH - Use this variable to append jar files or directories to 
@rem                  the end of the WEBLOGIC_CLASSPATH.
@rem 
@rem When setting these variables below, please use short file names (8.3).  
@rem To display short (MS-DOS) filenames, use "dir /x". File names with 
@rem spaces will break this script. 
@rem 
@rem jDriver for Oracle users: This script assumes that native libraries 
@rem required for jDriver for Oracle have been installed in the proper 
@rem location and that your system PATH variable has been set appropriately. 
@rem For additional information, refer to Installing and Setting up WebLogic 
@rem Server (/install/index.html in your local documentation set or on the 
@rem Internet at http://www.weblogic.com/docs51/install/index.html). 

echo on
echo Calling setEnv
call .\setEnv
echo setEnv called
echo -----------------
echo starting weblogic
echo off

SETLOCAL

set JAVA_HOME=\jdk1.3

@rem Set user-defined variables. Note that JAVA_HOME will be taken 
@rem from the environment, if it is already defined.
if "%JAVA_HOME%" == "" set JAVA_HOME=.\jre1_2\jre
@rem if "%JAVA_HOME%" == "" set JAVA_HOME=\progra~1\micros~1.2
set PRE_CLASSPATH=\src\crete\source\build\;\src\crete\source\jlib\toolboxapi.jar;\src\barbados\source\build\;\src\barbados\source\jlib\toolboxapi.jar;\src\integration\source\build\;\src\integration\source\jlib\toolboxapi.jar;\jdk1.3\javamail113\mail.jar;\jdk1.3\jaf101\activation.jar
set POST_CLASSPATH=\weblogic\classes


@rem Check that script is being run from WebLogic root directory
if not exist license\WebLogicLicense.xml goto wrongplace
if not exist weblogic.policy goto wrongplace
goto checkJRE

:wrongplace
echo startWebLogic.cmd: must be run from the WebLogic installation directory. 1>&2
goto finish

:checkJRE
if exist %JAVA_HOME%\lib\nul goto whichJRE
if exist %JAVA_HOME%\classes\nul goto whichJRE
echo.
echo The JRE wasn't found in directory %JAVA_HOME%.
echo Please edit the startWebLogic.cmd script so that the JAVA_HOME
echo variable points to the root directory of your Java installation.
goto finish

:whichJRE
echo on
set PATH=.\bin;%PATH%
@if exist %JAVA_HOME%\Bin\JView.exe goto runWebLogicJview
@if exist %JAVA_HOME%\..\JView.exe goto runWebLogicJview
@if exist %JAVA_HOME%\lib\classes.zip goto setJava117
set JAVA_CLASSPATH=.\lib\weblogic510sp6boot.jar;.\classes\boot
goto runWebLogicJava

:setJava117
set JAVA_CLASSPATH=%JAVA_HOME%\lib\classes.zip;.\classes\boot;.\eval\cloudscape\lib\cloudscape.jar
goto runWebLogicJava

:runWebLogicJava
set WEBLOGIC_CLASSPATH=.\lib\weblogic510sp6.jar;.\classes12.zip;.\license;.\classes;.\lib\weblogicaux.jar;.\myserver\serverclasses

if "%PRE_CLASSPATH%" NEQ "" set WEBLOGIC_CLASSPATH=%PRE_CLASSPATH%;%WEBLOGIC_CLASSPATH%

if "%POST_CLASSPATH%" NEQ "" set WEBLOGIC_CLASSPATH=%WEBLOGIC_CLASSPATH%;%POST_CLASSPATH%

%JAVA_HOME%\bin\java -server -ms64m -mx64m -classpath %JAVA_CLASSPATH% -Dweblogic.class.path=%WEBLOGIC_CLASSPATH% -Dweblogic.home=. -Djava.security.manager -Djava.security.policy=.\weblogic.policy weblogic.Server
goto finish

:runWebLogicJview
set CLASSPATH=%windir%\Java\Classes\classes.zip

if "%PRE_CLASSPATH%" NEQ "" set CLASSPATH=%CLASSPATH%;%PRE_CLASSPATH%

set CLASSPATH=.\license;.\classes\boot;.\classes;.\lib\weblogicaux.jar;.\myserver\serverclasses;.\eval\cloudscape\lib\cloudscape.jar;.\lib\rmiForMs.zip

if "%POST_CLASSPATH%" NEQ "" set CLASSPATH=%CLASSPATH%;%POST_CLASSPATH%

if not exist %JAVA_HOME%\bin\jview.exe goto winntJview
%JAVA_HOME%\bin\jview /d:weblogic.system.disableWeblogicClassPath=true weblogic.Server
goto finish

:winntJview
%JAVA_HOME%\..\..\winnt\jview /d:weblogic.system.disableWeblogicClassPath=true weblogic.Server

:finish
ENDLOCAL