/*
 Copyright 2014 Black Pear Software Ltd.
 License: GNU GPL3 (see README.md)
 */
var qrisk2 = require('qrisk2-2014');

var fs = require('fs');
var liner = require('./liner');
var files = [
        __dirname + '/regression-testcases.1.txt',
        __dirname + '/regression-testcases.2.txt',
        __dirname + '/regression-testcases.3.txt'];
require('chai').should();


function makeTestCase(line) {
    var values = line.split(' ');

    var testCase = {};
    testCase.age = Number(values[0]);
    testCase.b_AF = Number(values[1]);
    testCase.b_ra = Number(values[2]);
    testCase.b_renal = Number(values[3]);
    testCase.b_treatedhyp = Number(values[4]);
    testCase.b_type1 = Number(values[5]);
    testCase.b_type2 = Number(values[6]);
    testCase.bmi = Number(values[7]);
    testCase.ethrisk = Number(values[8]);
    testCase.fh_cvd = Number(values[9]);
    testCase.rati = Number(values[10]);
    testCase.sbp = Number(values[11]);
    testCase.smoke_cat = Number(values[12]);
    testCase.surv = Number(values[13]);
    testCase.town = Number(values[14]);
    testCase.expected = {
        female: Number(values[15]),
        male: Number(values[16])
    };

    return testCase;
}

var lineCount = 0;
files.forEach(function (file) {
    var source = fs.createReadStream(file);
    source.pipe(liner);
    liner.on('readable', function () {
        var line;
        while (line = liner.read()) {

            var testCase = makeTestCase(line);

            function female(testCase) {
                var result = qrisk2.female(testCase);

                result.score.should.equal(testCase.expected.female);
            }


            function male(testCase) {
                var result = qrisk2.male(testCase);

                result.score.should.equal(testCase.expected.male);
            }

            try {
                female(testCase);
                male(testCase);
                lineCount++;
                console.log(lineCount, line, 'OK')
            }
            catch (err) {
                console.log(lineCount, line, 'ERR', err.message);
            }
        }


    });
    liner.on('close', function () {
    });
    liner.on('error', function (err) {
        console.log(err);
    });
});
