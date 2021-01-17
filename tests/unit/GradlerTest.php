<?php
require_once ("../../src/php") ;
use Gradler ;
use Codeception\Test\Unit;

class GradlerTest extends Unit
{
    /**
     * @var UnitTester
     */
    protected $tester;
    
    protected function _before()
    {
    }

    protected function _after()
    {
    }

    // tests
    public function testOnGradleUnavailable_runCommand_returnsFalse()
    {
        Gradler::runCommand( " --version") ;
    }
}