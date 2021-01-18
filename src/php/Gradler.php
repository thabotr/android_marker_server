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
     * @param string $pproject_root absolute or relative path project folder
     * @return bool true if the task succeeded else false
     */
    public static function runWrapperCommand( string $task, string $project_root) : bool
    {
        //store current directory
        $current_directory = getcwd() ;

        if( !is_dir( $project_root))
        {
            error_log( "GradleWrapper Error: '$project_root' is not a valid project directory.") ;
            return false ;
        }

        exec( "cd $project_root", $output, $status);
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
