<?php
require_once ("./src/php/DBapi.php");

/**
 * @param int $user_role
 * @param string $environment_args_json
 * @return bool
 */
function processEnvironmentArguments( int $user_role, string $environment_args_json) : bool
{

    //will perform some environment operations permissible to the given user
    //unpack json into associative array
    $requests = json_decode( $environment_args_json, $associative = true);
    if( !isset( $requests) || !$requests)
    {
        error_log("Environment Arguments Error: Failed to decode json string.");
        return false ;
    }



    //get query

    //get process request
    return true ;
}

//to build lecture sub we need
//create session entry in DB[status to pending] TODO sessionStatusUpdate() and create session in db
//build directories[update database session.status prior and post] DONE!
//run gradle tests[update database session.status prior and post] TODO runGradleCommand()
//get gradle results to db as json string() TODO processHtmlResults() with processUnitTest() and processInstrumentationTest()
//

/**
 * @param string $command
 * @return array
 */
function runGradleCommand( string $command): array
{
    exec( "gradle --version");
}


/**
 * @function builds a directory named /<sess_id>/<sub_id> and unzips all the contents of zip file into this directory
 * @param int $submission_id
 * @param int $session_id
 * @param string $buildDirectory
 * @param DBapi $DBapi
 * @return bool
 */
function buildProjectEnvironment( int $submission_id, int $session_id, string $buildDirectory, DBapi $DBapi) : bool
{
    //make the project directory
    if (!is_dir($buildDirectory))
    {
        error_log("Project Environment Error:'$buildDirectory' is not a valid directory.");
        return false;
    }

    //get submission file from DB
    $submission_file = $DBapi->getRowsFromCompoundKey("ams", "submission_file", ["submission_id" => $submission_id]);
    if (!isset($submission_file) || $submission_file === [])
    {
        error_log("Project Environment Error: Submission file of submission id '$submission_id' not found in database.");
        return false;
    }

    //get file id
    $file_id = $submission_file["file_id"];

    //get file from id
    $file = $DBapi->getRowsFromCompoundKey("ams", "file", ["id" => $file_id]);

    //validate zip file
    if (!validate_file($file["absolute_path"], $file["sha256hash"]))
    {
        return false;
    }

    //build destination directory
    $dest_dir_name = realpath($buildDirectory) . "/$session_id/$submission_id";

    if (!mkdir($dest_dir_name, $permissions = 0775, $recursive = true))
    {
        return false;
    }

    //unzip zip file into destination dir
    try
    {
        $zipper = new ZipArchive();
        $zipper->open($file["absolute_path"]);
        $zipper->extractTo($dest_dir_name);
        $zipper->close();
    }catch( Exception $e)
    {
        error_log("Build Directory Error: " . $e->getMessage());
        return false ;
    }

    return true;
}

function validate_file( string $file_path, string $file_hash) : bool
{
    if( !is_file($file_path))
    {
        error_log("File Validation Error: File '" . $file_path . "' does not exist.") ;
        return false ;
    }

    if( ( $new_sha256hash = hash_file("sha256", $file_path)) !== $file_hash)
    {
        error_log("File error: File '" . $file_path . "' has sha256hash '" . $new_sha256hash . "' when '" . $file_hash . "' was expected. File corrupted. Recommended actions: Recover or remove file.") ;
        return false ;
    }
    return true ;
}

/**
 * @param string $temp_file_dir temporary servername of file
 * @param string $file_name unique name to identify the submitted zip file in the file system.
 * @param string $destination_directory name of the directory into which the zip file is to be saved. Must be accessible to php webserver.
 * @return array with bool result indicating success of file save as well as a string with error log.
 * @function save_submitted_file - saves zip file that came with the submission into the destination directory
 */
function save_submitted_file( string $temp_file_dir, string $destination_directory, string $file_name) : array
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
    if( filesize( $temp_file_dir) > $max_file_size)
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

    if( !move_uploaded_file( $temp_file_dir, $target_file))
    {
        error_log("Directory error($rand): Could not move uploaded file to destination file '" . $target_file . "'");
        return [ False, "Directory error($rand): There was an error uploading file. Inform administrator."] ;
    }

    return [ true, "Zip file uploaded."];
}

/**
 * @param string $accessToken unique token to differentiate user roles
 * @return int 0 = student, 1 = teacher, 2 = admin
 */
function validate_and_return_user( string $accessToken) : ?int
{
    $ROLE_STUDENT = 0;
    $ROLE_TEACHER = 1;
    $ROLE_ADMIN = 2;
    //validates user credentials and returns role as admin, student or teacher
    //which will determine what types of actions the user can perform with the marker
    switch( $accessToken)
    {
        case "student":
            return $ROLE_STUDENT;
        case "teacher":
            return $ROLE_TEACHER ;
        case "admin":
            return $ROLE_ADMIN ;
        default:
            return null ;
    }
}