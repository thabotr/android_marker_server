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
        $path = realpath( $path) ;
        //store current directory
        $current_directory = getcwd() ;

        if( !is_dir( dirname( $path)))
        {
            error_log( "GradleWrapper Error: '" . dirname( $path) . "' is not a valid project directory.") ;
            return false ;
        }

        if( !is_file( $path))
        {
            error_log("GradleWrapper Error: '$path' is an invalid path to gradle wrapper.");
            return false ;
        }

        exec( "cd " . dirname( $path), $output, $status);
        if( $status !== 0)
        {
            error_log( "GradleWrapper Error: " . implode( "\n", $output)) ;
            return false ;
        }
        exec( "./gradlew $task", $output, $status) ;

        if( $status !== 0)
        {
            error_log( "GradleWrapper Error: " . implode( "\n", $output));
            return false;
        }

        exec( "cd" . $current_directory);
        error_log( "GradleWrapper Log:" . implode( "\n", $output));
        return true ;
    }
}
