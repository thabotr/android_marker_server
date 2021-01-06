<?php
namespace unit;
use Codeception\Test\Unit;
use UnitTester;

require_once( getcwd() . '/src/php/DBapi.php');
use DBapi;

class DBapiTest extends Unit
{
    /**
     * @var UnitTester
     */
    protected UnitTester $tester;

    /**
     * @var DBapi
     */
    private DBapi $DBapi ;

    protected function _before()
    {
        $this->DBapi = new DBapi() ;
    }

    protected function _after()
    {

    }

    public function testOnCompleteColumns_insertRowIntoTable_returnsTrue()
    {
        $this->tester->dontSeeInDatabase('cars', [ "name" => "BMW", "price" => 232_112]) ;
        $this->assertTrue( $this->DBapi->insertRowIntoTable("test", "cars", [ "name" => "BMW", "price" => 232_112]));
        $this->tester->SeeInDatabase('cars', [ "name" => "BMW", "price" => 232_112]) ;
    }

    public function testOnExtraColumns_insertRowIntoTable_returnsTrue()
    {
        $this->tester->dontSeeInDatabase('cars', [ "name" => "Toyota", "price" => 137_000]) ;
        $this->assertTrue( $this->DBapi->insertRowIntoTable( "test", "cars", [ "name" => "Toyota", "mileage" => 30_000, "price" => 137_000]));
        $this->tester->seeInDatabase('cars', [ "name" => "Toyota", "price" => 137_000]) ;
    }

    public function testOnMissingNotRequiredColumns_insertRowIntoTable_returnsTrue()
    {
        $this->tester->dontSeeInDatabase('cars', ["name"=>"Porsche"]) ;
        $this->assertTrue( $this->DBapi->insertRowIntoTable( "test", "cars", [ "name" => "Porsche", "mileage" => 30_000]));
        $this->tester->seeInDatabase("cars", [ "name"=>"Porsche"]);
    }

    public function testOnMissingRequiredColumns_insertRowIntoTable_returnsFalse()
    {
        $this->tester->seeNumRecords( 0, "guns");
        $this->assertFalse( $this->DBapi->insertRowIntoTable("test", "guns", ["magazine_capacity" => 15, "licence" => "none", "scope_name" => "eagle 6"])) ;
        $this->tester->seeNumRecords( 0, "guns");
    }

    public function testOnDuplicationOfUniqueColumn_insertRowIntoTable_returnsFalse()
    {
        $this->tester->dontSeeInDatabase("guns", [ "name" => "colt", "magazine_capacity" => 14]) ;
        $this->assertTrue( $this->DBapi->insertRowIntoTable("test", "guns", [ "name" => "colt", "magazine_capacity" => 14 ]));
        $this->tester->seeInDatabase("guns", [ "name" => "colt", "magazine_capacity" => 14]) ;
        $this->assertFalse( $this->DBapi->insertRowIntoTable("test", "guns", [ "name" => "colt", "magazine_capacity" => 8 ]));
        $this->tester->seeNumRecords( 1, "guns") ;
    }

    public function testOnUnavailableValue_getRowsFromCompoundKey_returnsEmptyArray()
    {
        $this->tester->dontSeeInDatabase("guns", ["name" => "colt"]) ;
        $this->assertTrue( $this->DBapi->getRowsFromCompoundKey( "test", "guns", ["name" => "colt"]) === []);
    }

    public function testOnKeyMatchToMultipleRows_getRowsFromCompoundKey_returnsMultipleRows()
    {
        $this->tester->haveInDatabase("guns", [ "name" => "colt", "magazine_capacity" => 14]) ;
        $this->tester->haveInDatabase("guns",  [ "name" => "dessert eagle", "magazine_capacity" => 14]) ;
        $this->tester->seeNumRecords(2, "guns") ;
        $this->assertTrue( count( $this->DBapi->getRowsFromCompoundKey("test", "guns", ["magazine_capacity" => 14])) === 2);
    }

    public function testOnAvailableSingleValue_getRowsFromCompoundKey_returnsSingleRow()
    {
        $this->tester->haveInDatabase("guns", ["name" => "colt", "magazine_capacity" => 13]);
        $arr = $this->DBapi->getRowsFromCompoundKey("test", "guns", [ "name" => "colt"]);
        $this->assertIsArray($arr);
        $this->assertArrayHasKey( "name", $arr[0]);
    }


    public function testOnInvalidColumnKey_getRowsFromCompoundKey_returnsNull()
    {
        $this->assertNull( $this->DBapi->getRowsFromCompoundKey("test", "guns", ["scope" => 0]));
    }

    public function testOnExactCompoundKeyMatch_getRowsFromCompoundKey_returnsOneRow()
    {
        $this->tester->haveInDatabase("guns", [ "name" => "gun_name", "magazine_capacity" => 0, "licence" => "none"]) ;
        $this->tester->haveInDatabase("guns", [ "name" => "gun", "magazine_capacity" => 0, "licence" => "none"]) ;
        $arr = $this->DBapi->getRowsFromCompoundKey("test", "guns", [ "name" => "gun_name", "magazine_capacity" => 0]) ;
        $this->assertIsArray($arr);
        $this->assertTrue( count( $arr) === 1);
        $this->assertArrayHasKey( "magazine_capacity", $arr[0]);
    }
}
