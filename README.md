# ums-test-automation

## Prerequisites:

1. Download and install the latest version of [Java SE Development Kit](http://www.oracle.com/technetwork/java/javase/downloads/index.html).
2. Download [Jmeter](http://jmeter.apache.org/download_jmeter.cgi).
3. UMS must be running (see how to install and run UMS [here](https://github.com/nrccua/ums)).

## Installing Jmeter:

Unzip the zip/tar file into the directory where you want JMeter to be installed.

## Running the tests:

* `/ums-test-automation/FunctionalTests` has the test plans that hold the test cases for the functional tests for the APIs.
* `/ums-test-automation/PerformanceTests` has the test plans that hold the test cases for the performance tests. (to be developed)

### Using GUI Mode

* Run the file `/bin/jmeter.bat` to start JMeter in GUI mode.
* Open the file [/FunctionalTests/FT_Test_Plan_UMS.jmx](https://github.com/nrccua/ums-test-automation/blob/master/FunctionalTests/FT_Test_Plan_UMS.jmx)
* `Run > Start`
* A `.jtl` file will be generated with the results.

#### To execute in Development enviroment
Change the parameters in the `HTTP Request Defaults` config element screen:
* **protocol** must be `https`
* **host** must be `api-dev-ums.nrccua.org/v1` and
* **port** must be empty.


### Using Command Line Mode

You must be inside the folder where is the test plan file `.jmx`.
```sh
$ <Jmeter_path>\bin\jmeter.bat -n -t <path>/FunctionalTests/FT_Test_Plan_UMS.jmx -l <path>/FunctionalTests/FT_Test_Plan_UMS.jtl
```

or if you are inside the `<Jmeter_path>\bin` and the `.jmx` file must be also inside this folder:
```sh
$ jmeter -n -t <path>/FT_Test_Plan_UMS.jmx -l <path>/FT_Test_Plan_UMS.jtl
```

The `.jtl` file is generated with the results of the tests.

#### To execute in Development enviroment
Increase `-Jhost.ip=api-dev-ums.nrccua.org/v1 -Jhost.port=443 -Jhost.protocol=https` parameters in your jmeter command line above.

