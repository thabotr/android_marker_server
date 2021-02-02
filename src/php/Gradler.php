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
     * @param string $project_root absolute or relative path project folder
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

        try
        {
            if (!chdir($project_root))
            {
                error_log("GradleWrapper Error: Cannot change into directory '$project_root'.");
                return false;
            }
        }catch( Exception $e)
        {
            error_log("GradleWrapper Error: " . $e->getMessage());
            return false ;
        }

        exec( "find gradlew", $output, $status);
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

        chdir( $current_directory);
        error_log( "GradleWrapper Log:" . implode( "\n", $output));
        return true ;
    }

    /**
     * @param string $xml_directory directory containing xml files with results for unit tests
     * @return array empty if results not found else an associative array of test results
     */
    public static function getXMLTestResults( string $xml_directory) : ?array
    {
        if( !is_dir( $xml_directory))
        {
            error_log("Gradler Error: '$xml_directory' is not a valid results directory.");
            return null;
        }

        exec( "find  $xml_directory/*.xml", $output, $status);
        if( $status !== 0)
        {
            error_log( "Gradler Error: " . implode( "\n", $output));
            return [] ;
        }

        //TODO process each xml file
        $res_array = [] ;
        foreach( $output as $directory)
        {
            $xml_object = simplexml_load_file( $directory);
            if( $xml_object)
            {
                array_push( $res_array, json_encode( $xml_object));
            }
        }
        return $res_array;
    }

    /**
     * UNIT TEST CASE JSON ENCODED XML RESULTS STRUCTURE
     * from getXMLTestResults()
     * [
     *      {
     *      "@attributes" : { "name" : "fullyQualifiedNameForTestClass", "tests" : "totalNumberOfTests", "skipped" : "value", "failures": "value", "errors" : "value", "timestamp" : "value", "hostname" : "value", "time" : "cumulativeTimeForAllTests"},
     *      "properties" : {},
     *      "testcase" : [
     *          foreachTestCase-> { "attributes" : { "name" : "value", "classname": "value", "time" : "value"}, existsOnlyOnTestFailure-> "failure" : "ErrorLog"},
     *          { ANOTHER TESTCASE},
     *          ...
     *       ],
     *         "system-out" : {},
     *          "system-err" : {}
     *      },
     *      { ANOTHER OBJECT CORRESPONDING TO TEST CLASS },
     *      ...
     * ]
     *
     * Desired array outcome
     * [
     * { "summary" : { classNames : [ name1, name2, ..], numberOfTests : value, skipped : value, numberFailed : value, errors : value, cumulativeTimeForAll : value},
     *   "classes" : [
     *      { testClass1 : { numTests : value, skipped : value, failures : value, errors : value, timestamp : value, time : value, testCases : [ { name : value, success : "true|LOG"}, {}, ...], sysout : {}, syserr : {}}
     * ]
     */
}
