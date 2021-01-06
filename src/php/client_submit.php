<?php
require_once( "./DBapi.php");
$db = new DBapi();
$db->getRowsFromCompoundKey([]) ;
exit(0);

$submission_id = null;
$access_token = null ;
$environment_arguments = null ;
$zip_file_sha256sum = null ;

if( !isset($_POST["submit"]))
{
    echo "Submission form not found." ;
    exit(0) ;
}

if( !isset( $_POST["submissionId"]))
{
    echo "Please specify submission id.";
    exit(0);
}else
{
    $submission_id = $_POST["submissionId"] ;
}

if( !isset( $_POST["accessToken"]))
{
    echo "Please specify access token." ;
    exit(0);
}else
{
    $access_token = $_POST["accessToken"] ;
}

if( isset( $_FILES["zipFile"]["name"]))
{
    if( !isset( $_POST["sha256sum"]))
    {
        echo "Please specify the sha256sum of the zip file for authenticity checks.";
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
    save_submitted_file( $destination_directory, $file_name) ;
}

if( !isset( $_POST["environmentArguments"]))
{
    $environment_arguments = $_POST["environmentArguments"] ;
}

function validate_and_return_user()
{
    //validates user credentials and returns role as admin, student or teacher
    //which will determine what types of actions the user can perform with the marker
}

function process_environment_arguments( $user, $environment_args)
{
    //will perform some environment operations permissible to the given user
}

/* @param string $file_name unique name to identify the submitted zip file in the file system.
 * @param string $destination_directory name of the directory into which the zip file is to be saved. Must be accessible to php webserver.
 * @return array with bool result indicating success of file save as well as a string with error log.
 * @function save_submitted_file - saves zip file that came with the submission into the destination directory
 */
function save_submitted_file(string $destination_directory, string $file_name) : array
{
    $rand = rand(0, 100_000);
    if( !is_dir( $destination_directory))
    {
        error_log( "Directory error($rand): Invalid destination directory '". $destination_directory) . "'" ;
        return [ false, "Directory error($rand): Inform administrator."];
    }

    //discarding file if already exists
    $target_file = $destination_directory . "/" . $file_name ;
    if( file_exists( $target_file))
    {
        return [ true, "Your file already exists."];
    }

    //enforce maximum filesize
    $max_file_size = 500_000 ; // can be changed to appropriate max file size
    if( filesize($_FILES["zipFile"]["tmp_name"]) > $max_file_size)
    {
        return [ False, "File error: File too large. File size limit is " . $max_file_size . "bytes."];
    }

    //saving file to permanent directory
    $tmp_res = fopen( $target_file, 'a') ;
    if( !isset( $tmp_res) || $tmp_res === false)
    {
        error_log("Directory error($rand): Could not open destination file " . $target_file . " to place temporary file ". $_FILES["zipFile"]["tmp_name"]) ;
        return [ False, "Directory error($rand): There was an error uploading file. Inform administrator."] ;
    }
    fclose( $tmp_res) ;

    if( !move_uploaded_file($_FILES["zipFile"]["tmp_name"], $target_file))
    {
        error_log("Directory error($rand): Could not move uploaded file to destination file '" . $target_file . "'");
        return [ False, "Directory error($rand): There was an error uploading file. Inform administrator."] ;
    }

    return [ true, "Zip file uploaded."];
}