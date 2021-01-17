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
            error_log( "Gradler Error: " . implode( $output)) ;
            return false ;
        }

        error_log("Gradler Log: " . implode( $output));
        return true ;
    }
}
