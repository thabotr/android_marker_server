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
}