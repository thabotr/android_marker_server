<?php
$target_dir = "/var/www/html/PROTECTED_marker_data/" ;
 #$target_file = $target_dir . basename( $_FILES["zipFile"]["name"]);
$target_file_path = $target_dir . "uploadedZipFile.zip" ;
$file_extension = strtolower( pathinfo( $target_file_path, PATHINFO_EXTENSION));

 //check if zip file is actual zip and not fake
if( !isset( $_POST["submit"]))
{
//    $check = getimagesize($_FILES["zipFile"]["tmp_name"]);g
//
//    if( $check !== false)
//    {
//        echo "File is a - " . $check["mime"] . ".";
//    }else
//    {
//        echo "File not a zip.\n";
//        echo $_FILES["zipFile"]["tmp_name"] . " \n" ;
//        print_r( pathinfo( $_FILES["zipFile"]["tmp_name"])) ;
//        exit(0);
//    }
    echo "File not found.";
    exit(0) ;
}

if( !isset( $file_extension) || $file_extension !== "zip")
{
    echo "Invalid file uploaded. Please submit a zip file.";
    exit(0) ;
}

//discarding file if already exists
if( file_exists( $target_file_path))
{
    echo "Your file already exists.";
    exit(0);
}

if( filesize($_FILES["zipFile"]["tmp_name"]) > 500_000)
{
    echo "Sorry, file too large.";
    exit(0) ;
}

//upload file
//create target file
//$dir = fopen( "/var/www/html/ams/html", 'r');
$target_file = fopen( $target_file_path, 'a') ;
if( !isset( $target_file) || $target_file === false)
{
    echo "Sorry, there was an error uploading file." ;
    error_log("Could not open destination file " . $target_file_path . " to place temporary file ". $_FILES["zipFile"]["tmp_name"]) ;
    exit(0) ;
}
fclose( $target_file) ;

if( move_uploaded_file($_FILES["zipFile"]["tmp_name"], $target_file_path))
{
    echo "File ". htmlspecialchars( basename( $_FILES["zipFile"]["name"])) . " has been uploaded.";
}else
{
    echo "Sorry, there was an error uploading file.";
    error_log("Could not move uploaded temporary file " . $_FILES["zipFile"]["tmp_name"] . " to " . $target_file_path) ;
    exit(0) ;
}