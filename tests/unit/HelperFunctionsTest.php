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
        //build apk and run unit tests
        $this->assertTrue( Gradler::runWrapperCommand( "testDebugUnitTest", "./tests/_data/android-demo1")) ;
        $arr = Gradler::getXMLTestResults( "./tests/_data/android-demo1/app/build/test-results/testDebugUnitTest") ;
        $this->tester->assertArrayHasKey( "time", $arr);
        $this->tester->assertArrayHasKey( "failures", $arr);
        $this->tester->assertArrayHasKey( "tests", $arr);
        $this->tester->assertEquals( 13, $arr["tests"]) ;
        $this->tester->assertEquals( 1, $arr["failures"]) ;
    }
}