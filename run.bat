@echo off
rem This is a utility to parse JUnit/XUnit XML files into JSON formats required by qTest APIs.


SET UPDATE="false"
SET GIT="no"
SET BRANCH=""

:loop
IF NOT "%1"=="" (
    IF "%1"=="-g" (
        SET GIT="yes"
        SHIFT
        GOTO :loop
    )
    IF "%1"=="-u" (
        SET UPDATE="update"
        SHIFT
        GOTO :loop
    )
    IF "%1"=="-b" (
        SET BRANCH=%2
        SHIFT
        GOTO :loop
    )
    SHIFT
    GOTO :loop
)

for /f tokens^=*^ delims^=^ eol^= %%i in ('call python getlocalrepo.py') do set LOCALREPO=%%i
for /f tokens^=*^ delims^=^ eol^= %%i in ('call python getrepourl.py') do set REPOSRC=%%i

IF  %GIT% == "yes" (
    echo FETCHING TESTS FROM GITHUB
    IF %BRANCH% == "" (
        echo UPDATING LOCAL REPOSITORY
        call git clone %REPOSRC% || pushd %LOCALREPO% & call git pull & popd
    ) ELSE (
        echo UPDATING LOCAL REPOSITORY AND CREATING BRANCH
        call git clone %REPOSRC% || pushd %LOCALREPO% & call git checkout -b %BRANCH% || call git checkout %BRANCH% & call git rebase master & popd
    )
)

echo RUNNING TESTS

for /f tokens^=*^ delims^=^ eol^= %%i in ('call python getscheduledtests.py') do set TEST=%%i
for /f tokens^=*^ delims^=^ eol^= %%i in ('call python runscheduledtests.py "%LOCALREPO%"') do set JMXFILE=%%i

IF "%JMXFILE%" == "None" (

    echo FILE NOT FOUND

) ELSE (

    pushd %LOCALREPO% & call jmeter -n -t %JMXFILE% & popd
    echo UPLOADING TO qTEST

    IF "%TEST%" == "None" (

        call python executetests.py %LOCALREPO% %UPDATE%
    ) ELSE (
            echo UPLOADING SCHEDULED TESTS

            python uploadtoqtest.py "%TEST%" %LOCALREPO% %UPDATE%
    )
)

echo DONE

