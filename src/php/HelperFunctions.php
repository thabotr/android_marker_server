<?php

function process_environment_arguments( int $user_role, string $environment_args) : bool
{
    //will perform some environment operations permissible to the given user

    //get query

    //get process request
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