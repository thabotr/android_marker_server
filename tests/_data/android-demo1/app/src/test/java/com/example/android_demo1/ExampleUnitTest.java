package com.example.android_demo1;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
public class ExampleUnitTest {
    MainActivity ma ;
    @Before
    public void setUp()
    {
        ma = new MainActivity() ;
    }
    @Test
    public void mainActFunTest()
    {
        assertTrue(ma.mainActFun());
    }

    @Test
    public void mainActFunTest0()
    {
        assertTrue(ma.mainActFun0());
    }

    @Test
    public void mainActFunTest1()
    {
        assertTrue(ma.mainActFun1());
    }

    @Test
    public void mainActFunTest2()
    {
        assertTrue(ma.mainActFun2());
    }

    @Test
    public void mainActFunTest3()
    {
        assertTrue(ma.mainActFun3());
    }

    @Test
    public void mainActFunTest4()
    {
        assertTrue(ma.mainActFun4());
    }

    @Test
    public void mainActFunTest5()
    {
        assertTrue(ma.mainActFun5());
    }
}