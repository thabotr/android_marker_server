package com.example.android_demo1;

public class ArithmeticInBase
{
	public int baseValue ;
	public ArithmeticInBase( int baseValue)
	{
		this.baseValue = baseValue ;
	}
	
	public void validateNumber( int value) throws NumberFormatException
	{
		if( value < 0 && value < -1 * baseValue || Math.abs( value) > this.baseValue || value == this.baseValue)
		{
			throw new NumberFormatException( String.format( "Value %d is does not exist in base %d arithmetic.", value, this.baseValue));
		}
	}
	
	public int add( int num1, int num2) throws NumberFormatException
	{
		int sum = num1 + num2 ;
		//TODO refactor
		return sum ;
	}
}
