<?php
require_once ("HelperFunctions.php") ;
$submission_id = null;
$access_token = null ;
$environment_arguments = null ;
$zip_file_sha256sum = null ;

if( !isset($_POST["submit"]) || $_POST["submit"] === "")
{
    echo "Required Field Error: Submission form not found." ;
    exit(0) ;
}

if( !isset( $_POST["submissionId"]) || $_POST["submissionId"] === "")
{
    echo "Required Field Error: Please specify submission id.";
    exit(0);
}else
{
    $submission_id = $_POST["submissionId"] ;
}

if( !isset( $_POST["accessToken"]) || $_POST["accessToken"] === "")
{
    echo "Required Field Error: Please specify access token." ;
    exit(0);
}else
{
    $access_token = $_POST["accessToken"] ;
}

//get user role
$user_role = validate_and_return_user( $access_token) ;

if( !isset( $user_role))
{
    echo "Authentication error: Invalid access token given.";
    exit(0);
}

if( isset( $_FILES["zipFile"]["name"]) && $_FILES["zipFile"]["name"] !== "")
{
    if( !isset( $_POST["sha256sum"]) || $_POST["sha256sum"] === "")
    {
        echo "Required Field Error: Please specify the sha256sum of the zip file for authenticity checks.";
        exit(0) ;
    }
    $zip_file_sha256sum = $_POST["sha256sum"] ;

    //validate file authenticity before saving it
    $hash_result = hash_file( "sha256", $_FILES["zipFile"]["tmp_name"]);
    if( $hash_result !== $zip_file_sha256sum)
    {
        echo "Zip file corrupted. Please resubmit file.";
        exit(0);
    }
    //save zip file
    $file_name = "zipFile" . $submission_id . ".zip";
    $destination_directory = "/var/www/html/PROTECTED_marker_data" ;
    save_submitted_file( $_FILES["zipFile"]["tmp_name"], $destination_directory, $file_name) ;
}

if( isset( $_POST["environmentArguments"]) && $_POST["environmentArguments"] !== "")
{
    $environment_arguments = $_POST["environmentArguments"] ;

    //process environment variables
    //do back ground processing or foreground querying and return results
}

echo "Submission successful." ;