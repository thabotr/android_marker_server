package com.example.calculatorapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    Float numValue1, numValue2;
    boolean btnAddition, btnSubtraction, btnMultiplication, btnDivision;
    Button btnPlus;
    Button btnMinus;
    Button btnMultiply;
    Button btnDivide;
    Button btnEquals;
    Button btnZero;
    Button btnOne;
    Button btnTwo;
    Button btnThree;
    Button btnFour;
    Button btnFive;
    Button btnSix;
    Button btnSeven;
    Button btnEight;
    Button btnNine;
    Button btnBackSpace;
    Button btnPeriod;
    Button btnPercent;
    TextView txt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btnPlus = findViewById(R.id.button_plus);
        btnMinus = findViewById(R.id.button_minus);
        btnMultiply = findViewById(R.id.button_multiply);
        btnDivide = findViewById(R.id.button_divide);
        btnEquals = findViewById(R.id.button_equals);
        btnZero = findViewById(R.id.button_0);
        btnOne = findViewById(R.id.button_1);
        btnTwo = findViewById(R.id.button_2);
        btnThree = findViewById(R.id.button_3);
        btnFour = findViewById(R.id.button_4);
        btnFive = findViewById(R.id.button_5);
        btnSix = findViewById(R.id.button_6);
        btnSeven = findViewById(R.id.button_7);
        btnEight = findViewById(R.id.button_8);
        btnNine = findViewById(R.id.button_9);
        btnBackSpace = findViewById(R.id.button_backspace);
        btnPeriod = findViewById(R.id.button_period);
        btnPercent = findViewById(R.id.button_percent);
        txt = findViewById(R.id.textView);

        btnPlus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                numValue1 = Float.parseFloat(txt.getText()+"");
                btnAddition = true;
                txt.setText(Float.toString(numValue1)+"+");
            }
        });

        btnMinus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                numValue1 = Float.parseFloat(txt.getText()+"");
                btnSubtraction = true;
                txt.setText(Float.toString(numValue1)+"-");
            }
        });

        btnMultiply.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                numValue1 = Float.parseFloat(txt.getText()+"");
                btnMultiplication = true;
                txt.setText(Float.toString(numValue1)+"*");
            }
        });

        btnDivide.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                numValue1 = Float.parseFloat(txt.getText()+"");
                btnDivision = true;
                txt.setText(Float.toString(numValue1)+"/");
            }
        });

        btnEquals.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String temp = txt.getText().toString();
                if (btnAddition) {
                    String operands[] = temp.split("\\+");
                    numValue2 = Float.parseFloat(operands[1]);
                    txt.setText(numValue1+numValue2+"");
                    btnAddition = false;
                    temp = "";
                }
                if (btnSubtraction) {
                    String operands[] = temp.split("-");
                    numValue2 = Float.parseFloat(operands[1]);
                    txt.setText(numValue1-numValue2+"");
                    btnSubtraction = false;
                    temp = "";
                }
                if (btnMultiplication) {
                    String operands[] = temp.split("\\*");
                    numValue2 = Float.parseFloat(operands[1]);
                    txt.setText(numValue1*numValue2+"");
                    btnMultiplication = false;
                    temp = "";
                }
                if (btnDivision) {
                    String operands[] = temp.split("/");
                    numValue2 = Float.parseFloat(operands[1]);
                    txt.setText(numValue1/numValue2+"");
                    btnDivision = false;
                    temp = "";
                }
            }
        });

        btnZero.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"0");
            }
        });

        btnOne.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"1");
            }
        });

        btnTwo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"2");
            }
        });

        btnThree.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"3");
            }
        });

        btnFour.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"4");
            }
        });

        btnFive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"5");
            }
        });

        btnSix.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"6");
            }
        });

        btnSeven.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"7");
            }
        });

        btnEight.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"8");
            }
        });

        btnNine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+"9");
            }
        });

        btnPeriod.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText(txt.getText()+".");
            }
        });

        btnBackSpace.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                txt.setText("");
            }

        });

        btnPercent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Float temp = Float.parseFloat(txt.getText()+"");
                float f = 0.01F;
                Float temp1 = Float.valueOf(f);
                temp = temp*temp1;
                txt.setText(Float.toString(temp)+"");
            }
        });

    }
}
