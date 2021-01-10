<?php 

class SubmitCest
{
    public function _before(AcceptanceTester $I)
    {
    }

    // tests

    public function testAsATeacher_whenOnSubmissionPage_ICanSeeAllEssentialFormFieldsAlongWithTheirLabels( AcceptanceTester  $I)
    {
        $I->am("Teacher");
        $I->amOnPage("/client_submit.html");

        $I->canSee("Select zip");
        $I->canSeeElement('input', [ "name" => "zipFile", "type" => "file"]);

        $I->canSee("Zip file hash");
        $I->canSeeElement( 'input', [ "type" => "text", "name" => "sha256sum"]) ;

        $I->canSee('Submission Id');
        $I->canSeeElement("input", [ "type" => "number", "name" => "submissionId"]);

        $I->canSee("Access token");
        $I->canSeeElement('input', [ "type" => "text", "name" => "accessToken"]);

        $I->canSee("environment arguments");
        $I->canSeeElement('textarea', [ "name" => "environmentArguments"]);

        $I->canSeeElement('input', [ "name" => "submit"]) ;
    }

    public function testOnFormSubmission_ifSubmissionIdNotSpecified_anErrorIsReturned( AcceptanceTester $I)
    {
        $I->amOnPage("/client_submit.html");
        $I->click("Submit form");
        $I->canSee("Required Field Error");
        $I->canSee("submission id");
    }

    public function testOnFormSubmission_ifAccessTokenNotSpecified_anErrorIsReturned( AcceptanceTester $I)
    {
        $I->amOnPage("/client_submit.html");
        $I->fillField("submissionId", 3);
        $I->click("submit");
        $I->canSee("Required Field Error");
        $I->canSee("access token");
    }

    public function testOnFormSubmission_ifFileAttachedButNoHashSpecified_anErrorIsReturned( AcceptanceTester $I)
    {
        $I->amOnPage("/client_submit.html");
        $I->fillField("submissionId", 3);
        $I->fillField("accessToken", "student");
        $file_name = $this->createZipFile()["name"];
        $I->attachFile( "zipFile", basename($file_name));
        $I->click("submit");
        $I->canSee("Required Field Error");
        $I->canSee("sha256sum");
        $this->removeZipFile( $file_name);
    }

    public function testOnFormSubmission_ifFileAttachedWithIncorrectHashSpecified_anErrorIsReturned( AcceptanceTester $I)
    {
        $I->amOnPage("/client_submit.html");
        $I->fillField("submissionId", 3);
        $I->fillField("accessToken", "student");
        $file_name = $this->createZipFile()["name"];
        $I->attachFile( "zipFile", basename($file_name));
        $I->fillField("sha256sum", "fake_hash");
        $I->click("submit");
        $I->canSee("corrupt");
        $this->removeZipFile( $file_name);
    }

    public function testOnFormSubmission_ifSubmissionValid_successReturned( AcceptanceTester $I)
    {
        $I->amOnPage("/client_submit.html");
        $I->fillField("submissionId", 3);
        $I->fillField("accessToken", "student");
        $file_name = $this->createZipFile()["name"];
        $file_hash = hash_file( "sha256", $file_name);
        $I->attachFile( "zipFile", basename($file_name));
        $I->fillField("sha256sum", $file_hash);
        $I->click("submit");
        $I->canSee("successful");
        $this->removeZipFile( $file_name);
    }

    public function testOnFormSubmission_ifAccessTokenInvalid_authenticationErrorReturned( AcceptanceTester $I)
    {
        $I->amOnPage("/client_submit.html");
        $I->fillField("submissionId", 3);
        $I->fillField("accessToken", "invalid_access_token");
        $I->click("submit");
        $I->canSee("Authentication error");
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
//    public function testOnSubmitPage_canUploadZipFile( AcceptanceTester $I)
//    {
//        //setup zip file to use
//        exec("
//        #create files to zip
//        touch ./tests/_data/file{1,2,3,4}.txt
//        echo hello >> ./tests/_data/file1.txt
//        echo hey >> ./tests/_data/file2.txt
//        echo hi >> ./tests/_data/file3.txt
//        echo bye >> ./tests/_data/file4.txt
//        #zip files
//        zip ./tests/_data/testZip.zip ./tests/_data/file*.txt
//        #remove files
//        rm ./tests/_data/file*.txt
//        ") ;
//
//        #get hash key of zip file
//        $hash_key = null ;
//        if( is_file("./tests/_data/testZip.zip"))
//            $hash_key = hash_file( "sha256", "./tests/_data/testZip.zip");
//        else
//        {
//            error_log("SubmitCest Error: File './tests/_data/testZip.zip' not found") ;
//            $I->canSee("nothing");
//        }
//
//        $I->amOnPage("http://localhost/ams/html/client_submit.html");
//        //fill form field using label
//        $I->fillField("Zip file hash", $hash_key) ;
//        //fill field using component name
//        $I->fillField("submissionId", 3);
//        $I->fillField("accessToken", "teacher") ;
//        //interact with form element using value
//        $I->click("Submit form") ;
//

//    }

//    public function tryToTest(AcceptanceTester $I)
//    {
//        $I->amOnPage("/client_submit.html");
//    }
}
