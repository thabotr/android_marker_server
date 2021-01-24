<?php

use Codeception\Stub\Expected;
use Codeception\Test\Unit;
require_once ( "./src/php/Gradler.php");

require_once ( "./src/php/HelperFunctions.php") ;

class HelperFunctionsTest extends Unit
{
    /**
     * TODO test validate_file
     */

    /**
     * @var UnitTester
     */
    protected UnitTester $tester;
    
    protected function _before()
    {
    }

    protected function _after()
    {
    }

    public function testOnValidJsonResults_getUnitTestResults_returnsExpectedArray()
    {
        $arr = Gradler::getXMLTestResults( "./tests/_data/android-demo1/app/build/test-results/testDebugUnitTest") ;
        $this->assertContains( "time", $arr);
        $this->assertContains( "failures", $arr);
        $this->assertContains( "tests", $arr);
    }
}