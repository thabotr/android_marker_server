<?php
/**
 * @function this function, having a knowledge on how unit test results are in xml, will generate a summary for those tests combined
 * @param string $json_array_string the encoded XML contents
 * @return array|null TODO desired unit tests summary in the following format, but for now
 * we return number of tests, number failed, and total time
 * [
 * { "summary" : { classNames : [ name1, name2, ..], numberOfTests : value, skipped : value, numberFailed : value, errors : value, cumulativeTimeForAll : value},
 *   "classes" : [
 *      { testClass1 : { numTests : value, skipped : value, failures : value, errors : value, timestamp : value, time : value, testCases : [ { name : value, success : "true|LOG"}, {}, ...], sysout : {}, syserr : {}}
 * ]
 */
function getUnitTestResults( string $json_array_string) : ?array
{
    try
    {
        $total_tests = 0 ;
        $total_failed = 0 ;
        $total_time = 0 ;
        $json_object = json_decode( $json_array_string, true) ;
        foreach( $json_object as $result)
        {
            $old_attr = $result["@attributes"];
            $total_tests += $old_attr["tests"] ;
            $total_failed += $old_attr["failures"];
            $total_time += $old_attr["time"];
        }
        return [ "tests" => $total_tests, "failures" => $total_failed, "time" => $total_time] ;
    }catch ( Exception $e)
    {
        error_log("getUnitTestResults failed : " . $e->getMessage());
        return null ;
    }
}