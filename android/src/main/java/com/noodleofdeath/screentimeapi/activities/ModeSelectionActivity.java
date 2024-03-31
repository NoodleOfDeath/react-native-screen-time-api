package com.noodleofdeath.screentimeapi.activities;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.noodleofdeath.screentimeapi.R;
import com.noodleofdeath.screentimeapi.utils.Constant;

import de.hdodenhof.circleimageview.CircleImageView;

public class ModeSelectionActivity extends AppCompatActivity {
	private CircleImageView imgParentSignUp;
	private TextView txtParentSignUp;
	
	private CircleImageView imgChildSignUp;
	private TextView txtChildSignUp;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_mode_selection);
		
		txtParentSignUp = findViewById(R.id.txtParentSignUp);
		imgParentSignUp = findViewById(R.id.imgParentSignUp);
		imgParentSignUp.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				startParentSignUp();
			}
		});
		
		
		txtChildSignUp = findViewById(R.id.txtChildSignUp);
		imgChildSignUp = findViewById(R.id.imgChildSignUp);
		imgChildSignUp.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				startChildSignUp();
			}
		});
		
	}
	
	private void startParentSignUp() {
		Intent intent = new Intent(this, SignUpActivity.class);
		intent.putExtra(Constant.PARENT_SIGN_UP, true);
		startActivity(intent);
	}
	
	private void startChildSignUp() {
		Intent intent = new Intent(this, SignUpActivity.class);
		intent.putExtra(Constant.PARENT_SIGN_UP, false);
		startActivity(intent);
		
	}
}
