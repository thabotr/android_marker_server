<?php

use Codeception\Stub\Expected;
use Codeception\Test\Unit;

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

    // tests
    public function testOnInvalidDirectory_buildProjectEnvironment_returnsFalse()
    {
        $this->assertFalse( buildProjectEnvironment( 1, 2, "./tests/_data/some_other_unavailable_dir/", $this->makeEmpty("DBapi")));
    }

    public function testOnInvalidSubmissionId_buildProjectEnvironment_returnsFalse()
    {
        try
        {
            $this->make("DBapi", Expected::once( ["getRowsFromCompoundKey" => []]));
            $this->assertFalse( buildProjectEnvironment( 1, 2, "./tests/_data", $this->makeEmpty("DBapi")));
        } catch (Exception $e)
        {
            error_log("Verification Error: ". $e->getMessage());
            $this->assertTrue(false);
        }

    }
    public function testOnValidSubmissionFileDbEntry_buildProjectEnvironment_makesTheRequiredDirectories()
    {
        $file_id = 1;
        //create zip file
        $abs_path = $this->createZipFile()["name"];
        $hash = hash_file("sha256", $abs_path);
        $ext = "zip";
        $sub_id = 2;
        $sess_id = 4 ;

        //insert file into db
        try
        {
            $DBapi = $this->make("DBapi", [ "getRowsFromCompoundKey" => Expected::exactly( 2, function( $arg1, $arg2, $arg3) use ($sub_id, $ext, $hash, $abs_path, $file_id)
            {
                if( $arg2 === "file")
                {
                    return [ "id" => $file_id, "absolute_path" => $abs_path, "sha256hash" => $hash, "extension" => $ext];
                }
                else if( $arg2 === "submission_file")
                {
                    return [ "file_id" => $file_id, "submission_id" => $sub_id];
                }
                return 0 ;
            })]);

            $final_dir = "./$sess_id/$sub_id" ;
            $this->assertTrue( buildProjectEnvironment( $sub_id, $sess_id, "./", $DBapi));
            $this->tester->assertDirectoryExists($final_dir);

            //assert contents of zip file are in created directories
            $this->tester->assertFileExists( $final_dir . "/tests/_data/file1.txt");

            //remove zip file
            $this->removeZipFile( $abs_path);
            //remove built directory
            exec("rm -rf ./$sess_id") ;

        } catch (Exception $e)
        {
            error_log("Verification Error: " . $e->getMessage());
            $this->assertTrue(false);
        }
    }

    private function createZipFile() : array
    {
        //setup zip file to use
        exec("
        #create files to zip
        touch ./tests/_data/file{1,2,3,4}.txt
        echo hello >> ./tests/_data/file1.txt
        echo hey >> ./tests/_data/file2.txt
        echo hi >> ./tests/_data/file3.txt
        echo bye >> ./tests/_data/file4.txt
        #zip files
        zip ./tests/_data/testZip.zip ./tests/_data/file*.txt
        #remove files
        rm ./tests/_data/file*.txt
        ") ;

        return [ "name" => realpath( "./tests/_data/testZip.zip")];
    }

    private function removeZipFile( string $name)
    {
        //clean up created zip file
        exec("rm $name") ;
    }

    public function testOnInvalidJsonString_processEnvironmentArguments_returnsFalse()
    {
        $json_string = "{
        \"query\" : hello, { \"\"
        }" ;

        $this->assertFalse( processEnvironmentArguments( 0, $json_string));
    }
}