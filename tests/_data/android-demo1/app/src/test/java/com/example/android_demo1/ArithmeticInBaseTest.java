package com.example.android_demo1;

import org.junit.Before;
import org.junit.Test;
import org.junit.Rule ;
import org.junit.rules.ExpectedException;

import static org.junit.Assert.*;

public class ArithmeticInBaseTest
{
	ArithmeticInBase aib ;
	
	@Rule
	public ExpectedException thrown = ExpectedException.none() ;
	
	@Before
	public void Setup()
	{
		aib = new ArithmeticInBase(6) ;
	}
	
	@Test
	public void onNegetiveFive_validateNumber_throwsNothing()
	{
		aib.validateNumber( -5);
	}
	
	@Test
	public void onNegetiveSix_validateNumber_throwsNothing()
	{
		aib.validateNumber( -6);
	}

	@Test
	public void onNumberLessThanNegativeSix_validateNumber_throwsNumberFormatException()
	{
		thrown.expect( NumberFormatException.class);
		aib.validateNumber( -7);
		aib.validateNumber( -10);
	}
	
	@Test
	public void onNumberPositiveSix_validateNumber_throwsNumberFormatException()
	{
		thrown.expect( NumberFormatException.class);
		aib.validateNumber( 6);
	}
	
	@Test
	public void onNumberGreaterThanSix_validateNumber_throwsNumberFormatException()
	{
		thrown.expect( NumberFormatException.class);
		aib.validateNumber( 7);
		aib.validateNumber( 11);
	}

	@Test
	public void onNumberBetweenNegSixAndFive_validateNumber_throwsNothing()
	{
		//to fail test
		thrown.expect( NumberFormatException.class) ;
	}
}
