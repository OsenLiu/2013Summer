package me.xiangchen.app.smartwatchtouch;

import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import com.sony.smallapp.SmallAppWindow;
import com.sony.smallapp.SmallApplication;


public class SmartWatchTouch extends SmallApplication {
	final int width = 200;
	final int height = 300; 
	
	LinearLayout layout;
	
	@Override
    public void onCreate() {
        super.onCreate();
        
        SmallAppWindow.Attributes attr = getWindow().getAttributes();
        attr.width = width;
        attr.height = height;
        
        layout = new LinearLayout(this);
        
        ImageView imgView = new ImageView(this);
        imgView.setImageResource(R.drawable.doraemon);
    	layout.addView(imgView, new LinearLayout.LayoutParams(
				LayoutParams.FILL_PARENT,
				LayoutParams.WRAP_CONTENT));
    	
    	layout.setOnTouchListener(new View.OnTouchListener() {
			
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				// TODO Auto-generated method stub
				System.out.println(event.getActionMasked());
				return true;
			}
		});
        
        setContentView(layout);
       
	}
	
	@Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }
    
}
