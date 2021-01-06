<?php

class File
{
    // @attribute id - unique identifier of the file in the database
    private int $id;
    // @attribute sha256sum
    private string $sha256hash;
    //@attribute abs_path
    private string $abs_path;
    // @attribute extension
    private string $extension ;

    public function __construct( string $sha256hash, string $file_path, string $extension = null, int $id = null)
    {
        if( is_file( $file_path))
        {
            $this->abs_path = realpath( $file_path) ;
        }
        else
        {
            error_log("File creation error: File '" . $file_path . "' does not exist. Aborting file creation.") ;
            throw new Exception("File creation error: File '" . $file_path . "' does not exist. Aborting file creation.") ;
        }

        $this->sha256hash = $sha256hash;

        if( isset($extension))
        {
            $this->extension = $extension;
        }


        if( isset( $id))
        {
            $this->id = $id ;
        }
    }

    /**
     * @return int
     */
    public function getId(): int
    {
        return $this->id;
    }

    /**
     * @return string
     */
    public function getExtension(): string
    {
        return $this->extension;
    }

    /**
     * @return string
     */
    public function getAbsPath(): string
    {
        return $this->abs_path;
    }

    /**
     * @return string
     */
    public function getSha256hash(): string
    {
        return $this->sha256hash;
    }

    public function addFileToDB( DBapi $DBapi) : bool
    {
        return $DBapi->insertRowIntoTable("ams", "file", [ "absolute_path" => $this->abs_path, "sha256hash"=> $this->sha256hash, "extension" => $this->extension]) ;
    }

    public function setFileIdBySha256hash( DBapi $DBapi) : bool
    {
        if( $arr = $DBapi->getRowsFromCompoundKey("ams", "file", [ "sha256hash" => $this->sha256hash]))
        {
            if( count($arr) === 0)
            {
                error_log("File error: Could not find file with sha256hash '" . $this->sha256hash . "' in DB.") ;
                return false ;
            }
            $this->id = $arr[0]["id"] ;
            return true ;
        }
        return false ;
    }

    public static function getFileFromDB( int $file_id, DBapi $DBapi) : ?File
    {
        //get file details from DB using the given id
        //construct a new file object and return it
        $res = $DBapi->getRowsFromCompoundKey("ams", "file", [ "id" => $file_id]) ;

        if( isset( $res) && count($res) > 0)
        {
            $arr = $res[0] ;
            return new File( $arr["sha256hash"], $arr["absolute_path"], $arr["extension"], $arr["id"]) ;
        }
        error_log("File error: File of id '". $file_id . "' not found.") ;
        return null ;
    }

    /**
     * Checks if the file still exists in the file system and whether the sha256hash is still the same
     * @return bool
     */
    public function validatePhysicalFile() : bool
    {
        if( !is_file( $this->abs_path))
        {
            error_log( "File error: File validation failed. '" . $this->abs_path . "' is not a file. Possible cause: File has been removed or renamed.") ;
            return false ;
        }

        if( ( $new_sha256hash = hash_file("sha256", $this->abs_path)) !== $this->sha256hash)
        {
            error_log("File error: File '" . $this->abs_path . "' has sha256hash '" . $new_sha256hash . "' when '" . $this->sha256hash . "' was expected. File corrupted. Recommended actions: Recover or remove file.") ;
            return false ;
        }
        return true ;
    }
}