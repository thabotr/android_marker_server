package com.example.calculatorapplication;

import android.content.Context;

import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.rule.ActivityTestRule;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static androidx.test.espresso.matcher.ViewMatchers.withText;
import static org.junit.Assert.*;

@RunWith(AndroidJUnit4.class)
public class MainActivityInstrumentedTest {

    @Rule
    public ActivityTestRule<MainActivity> activityRule = new ActivityTestRule<>(MainActivity.class);

    @Test
    public void checkZeroButton () {
        onView(withId(R.id.button_0)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("0")));
    }

    @Test
    public void checkOneButton () {
        onView(withId(R.id.button_1)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("1")));
    }

    @Test
    public void checkTwoButton () {
        onView(withId(R.id.button_2)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("2")));
    }

    @Test
    public void checkThreeButton () {
        onView(withId(R.id.button_3)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("3")));
    }

    @Test
    public void checkFourButton () {
        onView(withId(R.id.button_4)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("4")));
    }

    @Test
    public void checkFiveButton () {
        onView(withId(R.id.button_5)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("5")));
    }

    @Test
    public void checkSixButton () {
        onView(withId(R.id.button_6)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("6")));
    }

    @Test
    public void checkSevenButton () {
        onView(withId(R.id.button_7)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("7")));
    }

    @Test
    public void checkEightButton () {
        onView(withId(R.id.button_8)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("8")));
    }

    @Test
    public void checkNineButton () {
        onView(withId(R.id.button_9)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("9")));
    }

    @Test
    public void checkOperationButton () {
        onView(withId(R.id.button_2)).perform(click());
        onView(withId(R.id.button_multiply)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("2.0*")));
    }

    @Test
    public void checkClearButton () {
        onView(withId(R.id.button_9)).perform(click());
        onView(withId(R.id.button_1)).perform(click());
        onView(withId(R.id.button_1)).perform(click());
        onView(withId(R.id.button_backspace)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("")));
    }

    @Test
    public void checkAddition () {
        onView(withId(R.id.button_1)).perform(click());
        onView(withId(R.id.button_plus)).perform(click());
        onView(withId(R.id.button_1)).perform(click());
        onView(withId(R.id.button_equals)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("2.0")));
    }

    @Test
    public void checkSubtration () {
        onView(withId(R.id.button_1)).perform(click());
        onView(withId(R.id.button_minus)).perform(click());
        onView(withId(R.id.button_1)).perform(click());
        onView(withId(R.id.button_equals)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("0.0")));
    }

    @Test
    public void checkMultiplication () {
        onView(withId(R.id.button_4)).perform(click());
        onView(withId(R.id.button_multiply)).perform(click());
        onView(withId(R.id.button_4)).perform(click());
        onView(withId(R.id.button_equals)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("16.0")));
    }

    @Test
    public void checkDivision () {
        onView(withId(R.id.button_9)).perform(click());
        onView(withId(R.id.button_divide)).perform(click());
        onView(withId(R.id.button_4)).perform(click());
        onView(withId(R.id.button_equals)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("2.25")));
    }

    @Test
    public void checkPercent () {
        onView(withId(R.id.button_8)).perform(click());
        onView(withId(R.id.button_percent)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText("0.08")));
    }

    @Test
    public void checkPeriod () {
        onView(withId(R.id.button_period)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText(".")));
    }

}
