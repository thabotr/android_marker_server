<?php
class Gradler
{
    /**
     * @param string $command gradle command to be run
     * @return bool
     */
    public static function runCommand( string $command) : bool
    {
        exec( "gradle $command", $output, $status);
        if( $status !== 0)
        {
            error_log( "Gradler Error: " . implode( "\n", $output)) ;
            return false ;
        }

        error_log("Gradler Log: " . implode( "\n", $output));
        return true ;
    }

    /**
     * @param string $task wrapper task to execute
     * @param string $path absolute or relative path to gradle wrapper
     * @return bool true if the task succeeded else false
     */
    public static function runWrapperCommand( string $task, string $path) : bool
    {
        if( !is_file( $path))
        {
            error_log("Wrapper Error: '$path' is an invalid path to gradle wrapper.");
            return false ;
        }

        return true ;
    }
}
