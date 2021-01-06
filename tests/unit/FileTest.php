<?php

namespace unit;
use Codeception\Test\Unit;
use Codeception\Stub\Expected;
require_once( "./src/php/File.php");
require_once("./src/php/DBapi.php");
use Exception;
use File;
use UnitTester;

class FileTest extends Unit
{
    /**
     * @var File
     */
    protected File $file ;

    /**
     * @var UnitTester
     */
    protected UnitTester $tester ;

    public function _before()
    {
        exec( "echo 'This is a test file with gibberish.' >> ./tests/_data/test_file.file", $output, $status);
        if( $status !== 0)
        {
            error_log( "Command output for file creation(Status code $status):". $output);
            return ;
        }

        try
        {
            $this->file = new File(hash_file("sha256", "./tests/_data/test_file.file"), "./tests/_data/test_file.file", "file");
        } catch ( Exception $e)
        {
        }
    }

    public function _after()
    {
        exec( "rm -rf ./tests/_data/test_file.file") ;
    }

    public function testOnCall_getExtension_returnsTheCorrectFileExtension()
    {
        $this->assertEquals(  "file", $this->file->getExtension()) ;
    }

    public function testOnCall_getAbsPath_returnsFullPathToFile()
    {
        $this->assertEquals( getcwd() . "/tests/_data/test_file.file", $this->file->getAbsPath()) ;
    }

    public function testOnCall_getSha256hash_returnsCorrectResult()
    {
        exec( "sha256sum ./tests/_data/test_file.file", $output, $status_code) ;
        $this->assertEquals( 0, $status_code) ;
        //sha256sum outputs <sha256sum_of_file><space_char><file_name>, so we need to get the first part for comparison
        $this->assertEquals( explode( " ", $output[0])[0], $this->file->getSha256hash()) ;
    }

    public function testOnValidFile_validatePhysicalFile_returnsTrue()
    {
        $this->assertTrue( $this->file->validatePhysicalFile()) ;
    }

    public function testOnChangedFilePath_validatePhysicalFile_returnsFalse()
    {
        //tinker with file name
        exec( "mv ./tests/_data/test_file.file ./tests/_data/test_file.file.hold");
        $this->assertFalse( $this->file->validatePhysicalFile());
        //restore file name for cleaning by _after()
        exec( "mv ./tests/_data/test_file.file.hold ./tests/_data/test_file.file");
    }

    public function testOnChangedSha256hash_validatePhysicalFile_returnsFalse()
    {
        //tinker with file contents
        exec( "echo 'boo' >> ./tests/_data/test_file.file");
        $this->assertFalse( $this->file->validatePhysicalFile());
    }

    public function testOnInvalidFilePath_fileConstructor_throwsException()
    {
        $this->tester->expectThrowable( new Exception("File creation error: File 'invalid_file' does not exist. Aborting file creation."), function(){ new File( "", "invalid_file");}) ;
    }

    public function testOnValidId_getFileFromDB_returnsNewFileObject()
    {
        //create test file
        exec( "echo 'test_file' >> ./tests/_data/test_file.ext") ;
        try
        {
            //mock DPapi collaborator
            $DBapi = $this->make("DBapi", [ "getRowsFromCompoundKey" => Expected::once( function()
            {
                return [["id" => 7, "sha256hash" => hash_file( "sha256", "./tests/_data/test_file.ext"), "extension" => "ext", "absolute_path" => getcwd() . "/tests/_data/test_file.ext"]];
            })]);
            //test target function by ensuring file object is as expected
            $file = $this->file::getFileFromDB( 7, $DBapi) ;
            $this->tester->assertEquals( 7, $file->getId()) ;
            $this->tester->assertEquals( getcwd() . "/tests/_data/test_file.ext", $file->getAbsPath()) ;
        }
        catch( Exception $e)
        {
            error_log("Verification error: " . $e->getMessage()) ;
            $this->assertTrue(false) ;
        }

        //clean up
        exec("rm -rf ./tests/_data/test_file.ext") ;
    }

    public function testOnInvalidID_getFileFromDB_returnsNull()
    {
        try
        {
            //mock DPapi collaborator
            $DBapi = $this->make("DBapi", [ "getRowsFromCompoundKey" => Expected::once( function()
            {
                return [];
            })]);
            //test target function by ensuring file object is as expected
            $file = $this->file::getFileFromDB( 7, $DBapi) ;
            $this->assertNull( $file);
        }
        catch( Exception $e)
        {
            error_log("Verification error: " . $e->getMessage()) ;
            $this->assertTrue(false) ;
        }
    }
}
