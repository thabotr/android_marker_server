<?php
namespace unit;
use Codeception\Test\Unit;
use UnitTester;

require_once( getcwd() . '/src/php/Gradler.php');
use Gradler;

class GradlerTest extends Unit
{
    /**
     * @var UnitTester
     */
    protected UnitTester $tester;
    
    protected function _before()
    {
        exec( "sudo chmod -R 775 ./tests/_data/CalculatorApplication");
    }

    protected function _after()
    {
    }

    // tests
    public function testOnGradleUnavailable_runCommand_returnsFalse()
    {
        $this->markTestSkipped("For non-version 20 ubuntu");
        $this->assertFalse( Gradler::runCommand( " --version")) ;
    }

    //TODO enable test on non-ubuntu 20
    public function testOnGradleAvailableAndVersionRequested_runCommand_returnsTrue()
    {
        #$this->assertTrue( $this->installGradle()); //enable on non-version 20
        $this->assertTrue( Gradler::runCommand( " --version"));
    }

    public function testOnInvalidCommand_runCommand_returnsFalse()
    {
        $this->assertFalse( Gradler::runCommand( "gibberishTask")) ;
    }

    public function testOnInvalidDirectory_runWrapperCommand_returnsFalse()
    {
        $this->assertFalse( Gradler::runWrapperCommand( "tasks", "./tests/_data/CalculatorApplicationNotExist"));
    }

    public function testOnDirectoryNoRead_runWrapperCommand_returnsFalse()
    {
        exec( "sudo chmod -R 000 ./tests/_data/CalculatorApplication");
        $this->assertFalse( Gradler::runWrapperCommand( "tasks", "./tests/_data/CalculatorApplication"));
        exec( "sudo chmod -R 775 ./tests/_data/CalculatorApplication");
    }

    public function testOnWrapperNotFound_runWrapperCommand_returnsFalse()
    {
        $this->assertFalse( Gradler::runWrapperCommand( "tasks", "./tests/_data/"));
    }

    public function testOnInvalidTaskToGradleWrapper_runWrapperCommand_returnsFalse()
    {
        $this->assertFalse( Gradler::runWrapperCommand( "invalidTask", "./tests/_data/CalculatorApplication"));
    }

    public function testOnValidTaskToGradleWrapper_runWrapperCommand_returnsTrue()
    {
        $this->assertTrue( Gradler::runWrapperCommand( "build", "./tests/_data/CalculatorApplication"));
    }

    public function installGradle() : bool
    {
        exec("
        #update apt repositories
                                    sudo apt-get update
                                    #set gradle environment
                                    source src/gradle_setup.bash
                                    source set_env_vars.bash

                                    set_var_gradle

                                    install_java
                                    mkdir -p \$GRADLE
                                    install_gradle \$GRADLE

        ", $output, $status);
        return $status === 0 ;
    }

    public function testOnInvalidDirectory_getXMLTestResults_returnsNull()
    {
        $this->assertNull( Gradler::getXMLTestResults( "DoesNotExistDirectory")) ;
    }

    public function testOnNoXMLFilesInDirectory_getXMLTestResults_returnsEmptyArray()
    {
        $this->assertTrue( Gradler::getXMLTestResults( "./tests/_data/CalculatorApplication") === []);
    }

    public function testOnXMLFilesFound_getTestResults_returnsExpectedArray()
    {
        //build apk and run unit tests
        $this->assertTrue( Gradler::runWrapperCommand( "testDebugUnitTest", "./tests/_data/android-demo1")) ;
        Gradler::getXMLTestResults( "./tests/_data/android-demo1/app/build/test-results/testDebugUnitTest") ;
    }
}