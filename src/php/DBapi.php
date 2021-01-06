<?php

class DBapi
{

    function insertRowIntoTable(string $db_name , string $table_name, array $attribute_value_pairs) : bool
    {
        try
        {
            $db = new SQLite3($db_name . ".db") ;
            //get column names
            $res = $db->query("SELECT name FROM PRAGMA_TABLE_INFO('". $db::escapeString($table_name). "')") ;
            $row = $res->fetchArray() ;
            $column_names = [ $row["name"]] ;

            while( $row = $res->fetchArray())
            {
                array_push( $column_names, $row["name"]) ;
            }

            //prepare insert statement
            $statement_values = "" ;
            $statement_attributes = "" ;
            $comma_sep = false ;
            foreach( $attribute_value_pairs as $attribute => $value)
            {
                //if attribute specified in the function call is in the column names, add it to attribute list and append its corresponding value
                if( in_array( $attribute, $column_names))
                {
                    if( $comma_sep )
                    {
                        $statement_attributes .= "," ;
                        $statement_values .= "," ;
                    }else
                        $comma_sep = true ;

                    $statement_attributes .= $db::escapeString( $attribute) ;
                    if( is_string( $value))
                        $statement_values .= "'" . $db::escapeString($value) . "'" ;
                    else
                        $statement_values .= $value ;
                }
            }

            $statement = "INSERT INTO " . $db::escapeString($table_name) . "(" . $statement_attributes . ") VALUES (" . $statement_values . ")" ;
            return $db->exec( $statement) ;
        }catch ( \Exception $e)
        {
            error_log("DBapi error: ". $e->getMessage()) ;
        }
        return false ;
    }
    /*
     * @param string $db_name
     * @param string $table_name
     * @param array $key an associative array of attribute-value pairs that will be used to return a row of a relation
     * @return null - on fail | array - associative array of attribute value pairs
     */
    function getRowsFromCompoundKey(string $db_name, string $table_name, array $compound_key): ?array
    {
        try
        {
            //connect to database
            $db = new SQLite3($db_name . ".db");
            //append sanitized parameters to query
            $statement = "SELECT * FROM ". $db::escapeString($table_name) . " WHERE ";

            $append_and = false;
            foreach ($compound_key as $attribute => $value)
            {
                $attribute = $db::escapeString($attribute) ;

                if( is_string($value))
                {
                    $value = "'" . $db::escapeString($value) . "'" ;
                }

                if ($append_and)
                {
                    $statement = $statement . " and " . $attribute . "=" . $value ;
                } else
                {
                    $statement = $statement . $attribute . "=" . $value;
                    $append_and = true;
                }
            }
            //enable exceptions for efficient error handling
            $db->enableExceptions(true);

            $res = $db->query($statement);
            if( !$res)
                return null ;

            $arr = $res->fetchArray();

            if( $arr)
            {
                $multi_array = [] ;
                array_push( $multi_array, $arr) ;
                while( $arr = $res->fetchArray())
                {
                    array_push( $multi_array, $arr) ;
                }
                return $multi_array ;
            }
            else
                return [] ;

        } catch (\Exception $e)
        {
            error_log( "DBapi error: " . $e->getMessage());
        }
        return null;
    }
}