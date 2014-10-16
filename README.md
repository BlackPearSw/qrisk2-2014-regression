QRisk2-2014-regression
======================
Regression tests for qrisk2-2014 to demonstrate that it returns identical values to the reference implementation.

For further details of the algorithm see the [QRisk website](http://qrisk.org/index.php) 

Generating test cases
---------------------
An additional set of regression tests can be executed to prove that this module returns the same values as the QRisk2
reference implementation. 

Build the reference implementation from http://svn.clinrisk.co.uk/opensource/qrisk2.
Save the reference implementation in ./bin .

A tSQL script (make-testcases.sql) creates the cartesian set of sets of representative inputs for each 
variable in the algorithm. Each record in the set is transformed to a bash script to calculate the output of each
of the QRisk2 algorithms. 
 
To output the test cases to file:
 
    bcp qrisk..TestCase out regression.cases.sh -c -T

Use dos2unix to correct line endings and then prepend the file with the bash header (#! /bin/bash). 

NB: The sql and bash scripts for testcase generation can take hours and will require significant disk-space!

For your convenience, 3 pregenerated files (regression-testcases.n.txt) contain more than 2 million cases. 
Please note the following disclaimer accompanying the risk scores in these test cases:
> The initial version of this file, to be found at http://svn.clinrisk.co.uk/opensource/qrisk2, faithfully 
> implements QRISK2-2014.
> 
> ClinRisk Ltd. have released this code under the GNU Lesser General Public License to enable others to implement 
> the algorithm faithfully.
> 
> However, the nature of the GNU Lesser General Public License is such that we cannot prevent, for example, someone
> accidentally altering the coefficients, getting the inputs wrong, or just poor programming.
> 
> ClinRisk Ltd. stress, therefore, that it is the responsibility of the end user to check that the source that they
> receive produces the same results as the original code posted at http://svn.clinrisk.co.uk/opensource/qrisk2.
>
> Inaccurate implementations of risk scores can lead to wrong patients being given the wrong treatment. 

Test
----
To execute regression tests:

    npm install
    node regression-tests.js regression-testcases.1.txt
    node regression-tests.js regression-testcases.2.txt
    node regression-tests.js regression-testcases.3.txt

Copyright
---------
Copyright 2014 Black Pear Software Ltd.

License
-------
qrisk2-2014-regression is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

qrisk2-2014-regression is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Acknowledgements
----------------
Supported by [Black Pear Software Ltd](www.blackpear.com)
